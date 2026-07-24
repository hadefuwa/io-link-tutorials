# IO-Link AL1350 IoT Core API — PowerShell snippets
# Master IP: 192.168.7.4  |  Sensor: OBD1000 on port[1]
# Usage: run individual lines in a PowerShell terminal on the same network segment.

$master = "http://192.168.7.4/"

# ── PROCESS DATA (cyclic) ──────────────────────────────────────────────────────
# Switching state: 0x01 = object detected, 0x00 = clear (bit 0 of byte 0)
$body = '{"code":"request","cid":1,"adr":"/iolinkmaster/port[1]/iolinkdevice/pdin/getdata","data":{}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# ── READ PARAMETERS (acyclic) ─────────────────────────────────────────────────
# Signal level — index 236, sub 1 — range 0–1000 (higher = stronger return)
$body = '{"code":"request","cid":2,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":236,"subindex":1}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# Temperature — index 226, sub 1 — value in °C
$body = '{"code":"request","cid":3,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":226,"subindex":1}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# Operating hours — index 224, sub 0
$body = '{"code":"request","cid":4,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":224,"subindex":0}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# SP1 switching threshold — index 70, sub 0 — range 1–1000
$body = '{"code":"request","cid":5,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":70,"subindex":0}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# User tag — index 192, sub 0 — ASCII string label written to the device
$body = '{"code":"request","cid":6,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":192,"subindex":0}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# ── WRITE PARAMETERS (acyclic) ────────────────────────────────────────────────
# Set SP1 threshold to 500 (hex 01F4) — valid range 1–1000; device rejects >1000
$body = '{"code":"request","cid":7,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolwriteacyclic","data":{"index":70,"subindex":0,"value":"01F4"}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# Set SP1 back to 800 (hex 0320)
$body = '{"code":"request","cid":8,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolwriteacyclic","data":{"index":70,"subindex":0,"value":"0320"}}'
(Invoke-WebRequest -Uri $master -Method POST -Body $body -ContentType "application/json").Content

# ── INDEX CHEAT-SHEET ─────────────────────────────────────────────────────────
# pdin          process data (switching state, bit 0 = output)
# index 236 s1  signal level           0–1000 (UInt16)
# index 226 s1  temperature            °C     (UInt16)
# index 224 s0  operating hours               (UInt32)
# index  70 s0  SP1 switching threshold 1–1000 (UInt16)
# index  71 s0  output logic           0=light-on/NO, 1=dark-on/NC
# index 192 s0  user tag               ASCII string
# index  37 s0  detailed device status        (UInt8 flags)
# index 232 s0  detection range        mm     (read-only)
