$b=@{code='request';cid=1;adr='/iolinkmaster/port[4]/iolinkdevice/pdin/getdata'}|ConvertTo-Json -Compress
try{"direct master: "+(Invoke-WebRequest 'http://192.168.7.4/' -Method Post -Body $b -ContentType 'application/json' -UseBasicParsing -TimeoutSec 8).Content}catch{"direct FAIL: $($_.Exception.Message)"}
try{"local proxy  : "+(Invoke-WebRequest 'http://localhost:8088/api/al' -Method Post -Body $b -ContentType 'application/json' -UseBasicParsing -TimeoutSec 8).Content}catch{"proxy FAIL: $($_.Exception.Message)"}
