# Lesson 6 — YouTube description (copy-paste ready)

**IO-Link Practical Course #6 – Reading IO-Link Sensors with Just HTTP (No PLC, No Driver)**

The ifm AL1350 has a simple HTTP/JSON API — and once you know it, you can read or write any IO-Link sensor from a terminal, a Python script, a Node server, a browser, or a PLC. No driver to install. No SCADA licence. Just HTTP POST requests and a hex value back.

In this video I show you the whole IoT Core API from scratch: reading live process data, reading acyclic parameters by index, writing values back to the device — all with plain PowerShell, on camera, against a real sensor.

🔧 WHAT YOU'LL LEARN
• The AL1350 IoT Core API — one endpoint, one verb, one JSON shape
• Reading process data (the sensor's live switching state every ~4 ms)
• Reading parameters with index + subindex: signal level, temperature, operating hours
• Writing parameters back live (changing the switching threshold on camera)
• Where the index numbers come from — the IODD as your parameter address book
• How the dashboard app uses these exact same calls under the hood
• One gotcha to avoid: why getdatamulti returns empty on this firmware

🧠 THE KEY IDEA
Three things is all you need: the address, the index, and that the value is always hex. Once you have those, you can build whatever you like on top — a Python logger, a browser dashboard, a REST proxy, or a PLC integration. That's what this series does next.

⏱️ CHAPTERS
0:00 – Reading a sensor in one HTTP call
0:00 – The API structure (one endpoint, JSON in, hex out)
0:00 – Reading process data (live switching state)
0:00 – Reading parameters: signal level & temperature
0:00 – Where index numbers come from (the IODD)
0:00 – Writing a parameter live on camera (SP1 threshold)
0:00 – How the dashboard uses these same calls
0:00 – One gotcha: don't use getdatamulti
0:00 – What's next: the same thing from a Siemens PLC

🛠️ HARDWARE IN THIS VIDEO
• IO-Link Master: ifm AL1350 (4-port, IoT Core)
• Sensor: Pepperl+Fuchs OBD1000 diffuse photoelectric
• A PC + PowerShell — that's it

📺 IO-LINK PRACTICAL COURSE
Watch the full series from the start: [playlist link]
• #1 – What Is IO-Link?
• #2 – Manufacturer's Software (ifm moneo)
• #3 – The IO-Link Master Web Server
• #4 – IODD Files & the IODD Database
• #5 – IO-Link Versions 1.0 vs 1.1
• #6 – Reading IO-Link Data Over HTTP (this video)

🔗 USEFUL LINKS
• IO-Link Consortium: https://io-link.com
• IODD Finder (device files): https://ioddfinder.io-link.com
• ifm AL1350 product page: https://www.ifm.com
• Pepperl+Fuchs OBD1000: https://www.pepperl-fuchs.com

👋 CONNECT
YouTube: https://www.youtube.com/@hamedadefuwa
[LinkedIn / website / other socials]

💬 What system are you reading IO-Link data into? PLC, Python, Node, something else? Drop it in the comments — next video is Siemens S7-1200 over HTTP.

👍 If this helped, like and subscribe — next up: the same API call, but from a Siemens PLC with no Profinet.

#IOLink #IndustrialAutomation #ifm #IoT #Sensors #PLC #Automation #Industry40 #HTTP #API #PowerShell #HamedAdefuwa
