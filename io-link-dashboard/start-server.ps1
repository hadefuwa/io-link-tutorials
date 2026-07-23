# Runs ON PLC-PC (via SSH). Starts the dashboard server as a persistent scheduled
# task so it survives the SSH session, then reports the bound URL.
$task='IOLinkDeck'
& schtasks.exe /delete /tn $task /f 2>$null | Out-Null
Remove-Item 'C:\io-link-dashboard\running.txt' -ErrorAction SilentlyContinue
& schtasks.exe /create /tn $task /f /sc ONCE /st 00:00 /ru SYSTEM /rl HIGHEST `
    /tr 'powershell -NoProfile -ExecutionPolicy Bypass -File C:\io-link-dashboard\server.ps1' | Out-Null
& schtasks.exe /run /tn $task | Out-Null
Start-Sleep -Seconds 4
if(Test-Path 'C:\io-link-dashboard\running.txt'){ 'STARTED: ' + (Get-Content 'C:\io-link-dashboard\running.txt' -Raw) }
else { 'server did not report a port yet' }
