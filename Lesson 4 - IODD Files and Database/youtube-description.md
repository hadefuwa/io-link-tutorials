# Lesson 4 — YouTube description (copy-paste ready)

**IO-Link Practical Course #4 – IODD Files Explained (+ the IODD Database)**

An IO-Link sensor just sends raw bytes down the wire — so how does your software turn that into "object detected" or "Signal Level: 300"? The answer is the IODD: a machine-readable datasheet that every manufacturer ships with their device. In this video I show you the free global database where you download them, what actually comes in the folder, and then we crack open a real IODD XML and break it down into plain English.

🔧 WHAT YOU'LL LEARN
• What an IODD file actually is — and why nothing works properly without one
• The IODD Finder database: finding and downloading files for any device, any brand
• What's inside the download (XML + a pile of images)
• How to read an IODD XML without drowning in it
• How moneo and your IO-Link master use it to decode raw sensor data

📄 AN IODD XML IS REALLY JUST 5 PARTS
1. ID card — `<DeviceIdentity>` — who made it and what it is (the same Vendor/Device ID your master shows)
2. Pictures — `<DeviceVariant>` — it only *links* to image files, which is why it's a folder
3. The bytes — `<ProcessDataCollection>` — the process-data map (bit 0 = the switching signal)
4. Settings list — `<VariableCollection>` — every parameter, by index number
5. The dictionary — `<ExternalTextCollection>` — the human-readable names ("Signal Level", etc.)

Trace one parameter's text ID into the dictionary and you've watched decoding happen — that's the whole trick.

⏱️ CHAPTERS
0:00 – Why raw bytes need decoding
0:00 – What is an IODD file?
0:00 – The IODD Finder database
0:00 – Downloading the IODDs for my three devices
0:00 – What's actually in the folder
0:00 – Breaking down the XML: the 5 parts
0:00 – How your software uses it
0:00 – What's next

🛠️ HARDWARE IN THIS VIDEO
• IO-Link Master: ifm AL1350
• Devices: Pepperl+Fuchs OBD1000 · ifm TP9237 · PD30 photoelectric

📺 IO-LINK PRACTICAL COURSE
Watch the series from the start: [playlist link]
• #1 – What Is IO-Link?
• #2 – Manufacturer's Software (ifm moneo)
• #3 – The IO-Link Master Web Server
• #4 – IODD Files & the IODD Database (this video)

🔗 USEFUL LINKS
• IODD Finder (download device files): https://ioddfinder.io-link.com
• IO-Link Consortium: https://io-link.com
• ifm: https://www.ifm.com

👋 CONNECT
YouTube: https://www.youtube.com/@hamedadefuwa
[LinkedIn / website]

💬 Got a device whose IODD you can't track down? Drop it in the comments and I'll take a look.

👍 If this helped, like and subscribe — next up we start pulling data straight out of the master.

#IOLink #IODD #IndustrialAutomation #Sensors #ifm #Automation #Industry40 #PLC #ControlSystems
