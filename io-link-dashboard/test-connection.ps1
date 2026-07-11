<#
  Standalone AL1350 connectivity + PDin/PDout probe.
  Run this ON the PC wired to the AL1350. It does NOT need the web server.
  Usage:  powershell -ExecutionPolicy Bypass -File test-connection.ps1 [-Ip 192.168.7.2] [-Port 1]
#>
param([string]$Ip = '192.168.7.4', [int]$Port = 1)

$ErrorActionPreference = 'Continue'
$base = "/iolinkmaster/port[$Port]/iolinkdevice"

function Req($adr, $data=$null){
    $body = @{ code='request'; cid=1; adr=$adr }
    if ($data) { $body.data = $data }
    $json = $body | ConvertTo-Json -Compress -Depth 8
    try {
        $r = Invoke-WebRequest -Uri "http://$Ip/" -Method Post -Body $json -ContentType 'application/json' -TimeoutSec 5 -UseBasicParsing
        return $r.Content | ConvertFrom-Json
    } catch {
        Write-Host "  ! request failed: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

Write-Host "== AL1350 probe @ $Ip  port X0$Port ==" -ForegroundColor Cyan

$ping = Test-Connection -ComputerName $Ip -Count 1 -Quiet -ErrorAction SilentlyContinue
Write-Host ("ping           : {0}" -f ($(if($ping){'reachable'}else{'NO REPLY'})))

$vendor  = Req "$base/vendorname/getdata"
$product = Req "$base/productname/getdata"
$devid   = Req "$base/deviceid/getdata"
$pdin    = Req "$base/pdin/getdata"
$pdout   = Req "$base/pdout/getdata"

Write-Host ("vendor         : {0}" -f $vendor.data.value)
Write-Host ("product        : {0}" -f $product.data.value)
Write-Host ("deviceid       : {0}" -f $devid.data.value)
Write-Host ("pdin  (raw)    : {0}   code={1}" -f $pdin.data.value, $pdin.code)
Write-Host ("pdout (raw)    : {0}   code={1}" -f $pdout.data.value, $pdout.code)

if ($pdin.data.value -ne $null) {
    $n = [Convert]::ToInt32(("" + $pdin.data.value), 16)
    $ssc = $n -band 1
    Write-Host ("PDin decode    : SSC (Switching Signal) = {0}" -f ($(if($ssc){'ACTIVE (object detected)'}else{'inactive'}))) -ForegroundColor Green
}
Write-Host "== done ==" -ForegroundColor Cyan
