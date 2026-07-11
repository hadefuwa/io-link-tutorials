<#
  IO-Link Dashboard - local server
  ---------------------------------
  Zero-install web server for showing live IO-Link process data from an
  ifm AL1350 master (IoT Core JSON API). Runs on Windows PowerShell 5.1+
  with no modules and no admin rights (loopback TcpListener only).

  It does two jobs:
    1. Serves index.html (the dashboard) to the browser.
    2. Proxies the browser's IO-Link requests to the AL1350 so the browser
       never has to deal with CORS or the master's IP directly.

  Endpoints:
    GET  /                 -> index.html
    GET  /api/config       -> { masterIp, port, listenPort }
    POST /api/config       -> update masterIp / port, persists config.json
    POST /api/al           -> forwards raw ifm IoT-Core JSON to the master
#>

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$configPath = Join-Path $scriptDir 'config.json'

function Load-Config {
    if (Test-Path $script:configPath) {
        try { return (Get-Content $script:configPath -Raw | ConvertFrom-Json) } catch {}
    }
    return [pscustomobject]@{ masterIp = '192.168.7.4'; port = 1; listenPort = 8088; openBrowser = $true }
}

function Save-Config($cfg) {
    ($cfg | ConvertTo-Json) | Set-Content -Path $script:configPath -Encoding UTF8
}

$cfg = Load-Config
$listenPort = [int]$cfg.listenPort
if (-not $listenPort) { $listenPort = 8088 }

# --- HTTP helpers over a raw loopback socket (no HttpListener => no urlacl/admin) ---

function Read-HttpRequest($stream) {
    $headerBytes = New-Object System.Collections.Generic.List[byte]
    $one = New-Object byte[] 1
    while ($true) {
        $n = $stream.Read($one, 0, 1)
        if ($n -le 0) { break }
        $headerBytes.Add($one[0])
        $c = $headerBytes.Count
        if ($c -ge 4 -and $headerBytes[$c-4] -eq 13 -and $headerBytes[$c-3] -eq 10 `
            -and $headerBytes[$c-2] -eq 13 -and $headerBytes[$c-1] -eq 10) { break }
        if ($c -gt 65536) { break }
    }
    if ($headerBytes.Count -eq 0) { return $null }
    $headerText = [System.Text.Encoding]::ASCII.GetString($headerBytes.ToArray())
    $lines = $headerText -split "`r`n"
    $parts = $lines[0] -split ' '
    $method = $parts[0]
    $path   = if ($parts.Count -ge 2) { $parts[1] } else { '/' }
    $contentLength = 0
    foreach ($l in $lines) {
        if ($l -match '^(?i)Content-Length:\s*(\d+)') { $contentLength = [int]$Matches[1] }
    }
    $body = ''
    if ($contentLength -gt 0) {
        $buf = New-Object byte[] $contentLength
        $read = 0
        while ($read -lt $contentLength) {
            $n = $stream.Read($buf, $read, $contentLength - $read)
            if ($n -le 0) { break }
            $read += $n
        }
        $body = [System.Text.Encoding]::UTF8.GetString($buf, 0, $read)
    }
    return @{ Method = $method; Path = $path; Body = $body }
}

function Send-HttpResponse($stream, $status, $contentType, $bodyString) {
    $bodyBytes = [System.Text.Encoding]::UTF8.GetBytes($bodyString)
    $head = "HTTP/1.1 $status`r`n" +
            "Content-Type: $contentType`r`n" +
            "Content-Length: $($bodyBytes.Length)`r`n" +
            "Cache-Control: no-store`r`n" +
            "Connection: close`r`n`r`n"
    $headBytes = [System.Text.Encoding]::ASCII.GetBytes($head)
    $stream.Write($headBytes, 0, $headBytes.Length)
    if ($bodyBytes.Length -gt 0) { $stream.Write($bodyBytes, 0, $bodyBytes.Length) }
    $stream.Flush()
}

# --- Proxy a browser request through to the AL1350 IoT Core ---

function Invoke-AlProxy($rawBody) {
    $ip = $script:cfg.masterIp
    try {
        $resp = Invoke-WebRequest -Uri "http://$ip/" -Method Post -Body $rawBody `
                    -ContentType 'application/json' -TimeoutSec 5 -UseBasicParsing
        return @{ ok = $true; content = $resp.Content }
    } catch {
        $msg = $_.Exception.Message
        return @{ ok = $false; content = (@{ code = 503; error = "$msg"; masterIp = $ip } | ConvertTo-Json -Compress) }
    }
}

# --- Start listening on loopback (with fallback if the port is busy) ---

$listener = $null
$bound = $listenPort
foreach ($try in 0..10) {
    $candidate = $listenPort + $try
    try {
        $l = New-Object System.Net.Sockets.TcpListener ([System.Net.IPAddress]::Loopback, $candidate)
        $l.Start()
        $listener = $l; $bound = $candidate; break
    } catch {
        Write-Host "Port $candidate busy, trying next..." -ForegroundColor DarkGray
    }
}
if ($null -eq $listener) { Write-Host "Could not bind any port in $listenPort..$($listenPort+10)." -ForegroundColor Red; exit 1 }
$listenPort = $bound
$url = "http://localhost:$listenPort/"
# startup marker (lets a remote deploy confirm the server actually bound)
try { "listening $url  master=$($cfg.masterIp)  pid=$PID" | Set-Content -Path (Join-Path $scriptDir 'running.txt') -Encoding UTF8 } catch {}
Write-Host "IO-Link Dashboard running at $url" -ForegroundColor Green
Write-Host "AL1350 master: $($cfg.masterIp)  (port X0$($cfg.port))" -ForegroundColor Cyan
Write-Host "Press Ctrl+C in this window to stop." -ForegroundColor DarkGray

if ($cfg.openBrowser) {
    try { Start-Process $url | Out-Null } catch {}
}

$indexPath = Join-Path $scriptDir 'index.html'

try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $client.NoDelay = $true
            $stream = $client.GetStream()
            $req = Read-HttpRequest $stream
            if ($null -eq $req) { $client.Close(); continue }

            $pathOnly = ($req.Path -split '\?')[0]

            switch -Regex ($pathOnly) {
                '^/api/config$' {
                    if ($req.Method -eq 'POST') {
                        try {
                            $incoming = $req.Body | ConvertFrom-Json
                            if ($incoming.masterIp) { $script:cfg.masterIp = "$($incoming.masterIp)" }
                            if ($incoming.port)     { $script:cfg.port = [int]$incoming.port }
                            Save-Config $script:cfg
                        } catch {}
                    }
                    $out = @{ masterIp = $script:cfg.masterIp; port = [int]$script:cfg.port; listenPort = $listenPort } | ConvertTo-Json -Compress
                    Send-HttpResponse $stream '200 OK' 'application/json' $out
                    break
                }
                '^/api/al$' {
                    $result = Invoke-AlProxy $req.Body
                    $status = if ($result.ok) { '200 OK' } else { '502 Bad Gateway' }
                    Send-HttpResponse $stream $status 'application/json' $result.content
                    break
                }
                '^/(index\.html)?$' {
                    if (Test-Path $indexPath) {
                        $html = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8)
                        Send-HttpResponse $stream '200 OK' 'text/html; charset=utf-8' $html
                    } else {
                        Send-HttpResponse $stream '404 Not Found' 'text/plain' 'index.html missing'
                    }
                    break
                }
                default {
                    Send-HttpResponse $stream '404 Not Found' 'text/plain' 'Not found'
                }
            }
        } catch {
            Write-Host "Request error: $($_.Exception.Message)" -ForegroundColor Yellow
        } finally {
            $client.Close()
        }
    }
} finally {
    $listener.Stop()
}
