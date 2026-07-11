IO-Link Live Dashboard  -  Pepperl+Fuchs OBD1000 via ifm AL1350
================================================================

RUN
  Double-click the "IO-Link Dashboard" shortcut on the desktop
  (or start.bat in this folder). The browser opens at http://localhost:8088/.
  Master is at 192.168.7.4 (editable top-right if it ever changes).

WHAT IT SHOWS
  Detection      - live Switching Signal (object detected) + a detection counter
  Signal Level   - reflected-signal strength vs the switching threshold + signal
                   quality (idx 236). NOTE: this is signal strength, not distance -
                   it RISES as the target gets closer/more reflective.
  Diagnostics    - current/max temperature, operating hours, fault status
  Configuration  - read/WRITE the sensor over IO-Link:
                     * Switching threshold SP1 (signal level 1-1000, idx 70)
                     * Switching logic  (light-on/NO vs dark-on/NC, idx 71)
                     * Device tag/name  (idx 192)
                   Detection range in mm is a separate read-only value (idx 232).
  Identity       - vendor, product, device ID, serial, firmware, master

HOW IT WORKS
  start.bat -> server.ps1 : a tiny local web server (Windows PowerShell only,
  no install, no admin). It serves index.html and proxies the browser's
  requests to the AL1350 IoT Core JSON API (cyclic process data + acyclic
  ISDU parameter read/write). All decoding follows the OBD1000 IODD.

FILES
  start.bat            launcher (double-click)
  server.ps1           local web server + AL1350 proxy
  index.html           the dashboard
  config.json          masterIp / port / listenPort
  test-connection.ps1  command-line probe (no browser)

NOTES
  - PDout (CSC1 transducer-disable / CSC2 evaluation-hold) is not served by the
    master port here, so those controls show "not available" - normal, not needed
    for detection.
  - The PC uses a static secondary IP 192.168.7.10 on Ethernet 2 to reach the
    master, alongside the normal LAN address.
