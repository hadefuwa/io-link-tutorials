# Stops the SYSTEM scheduled-task server and frees port 8088 (run on PLC-PC).
try { Unregister-ScheduledTask -TaskName 'IOLinkDeck' -Confirm:$false -ErrorAction SilentlyContinue } catch {}
$c = Get-NetTCPConnection -LocalPort 8088 -State Listen -ErrorAction SilentlyContinue
if ($c) { $c.OwningProcess | Sort-Object -Unique | ForEach-Object { Stop-Process -Id $_ -Force -ErrorAction SilentlyContinue } }
Start-Sleep -Seconds 1
'port 8088 free: ' + (-not [bool](Get-NetTCPConnection -LocalPort 8088 -State Listen -ErrorAction SilentlyContinue))
