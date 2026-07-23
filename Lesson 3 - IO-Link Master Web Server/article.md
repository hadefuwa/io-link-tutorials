---
title: "Your IO-Link Master Is a Web Server — A Tour of the ifm AL1350 Page"
series: "IO-Link Practical Course"
episode: 3
author: "Hamed Adefuwa"
channel: "https://www.youtube.com/@hamedadefuwa"
tags: [IO-Link, ifm, AL1350, IoT, industrial-automation, sensors]
date: ""   # fill in on publish
---

# Your IO-Link Master Is a Web Server

Most people who use an ifm IO-Link master never realise the thing is a fully working
web server. You don't need special software, you don't need a PLC, and you don't need
to install anything. You just point a browser at it — and it shows you every sensor
plugged in, plus a live read-out of its own health.

In this third part of the IO-Link Practical Course we're doing exactly that: opening
the built-in web page on an **ifm AL1350** and seeing how much it can tell us for free.
It's the simplest possible way to look inside an IO-Link setup — and, as we'll see at
the end, it's also the doorway to something much more powerful.

![The AL1350 web interface](assets/al1350-webpage.png)

## What you'll need

- An **ifm IO-Link master** with an IoT interface (I'm using the AL1350, 4-port)
- One or more **IO-Link devices** plugged in
- A **PC on the same network** as the master, and any web browser

That's it. No licences, no engineering tool.

## Opening the page

Every ifm IoT master runs a small web server on its IoT port. To reach it you only need
its IP address. Mine is `192.168.7.4`, so I type that straight into the browser's address
bar and the page loads.

If nothing comes up, it's almost always a networking issue rather than a fault: your PC
has to be on the **same IP range** as the master. Sort that out and the page appears
instantly — no reconnecting, no login.

## Reading the port table

The table at the top is the heart of the page. It lists every port on the master and
exactly what's connected to each one. Here's what each column is telling you.

| Column | What it means |
|---|---|
| **Mode** | The port's operating mode. Mine all show *IO-Link* (in green) — full data comms. A port can also run as a plain digital input instead. |
| **Comm. Mode** | The communication speed. `38.4 kBaud` is **COM2** — the speed the vast majority of IO-Link devices use (the others are COM1 at 4.8k and COM3 at 230.4k). |
| **MasterCycleTime** | How often the master exchanges data with that device — effectively how fresh the data is. It varies per device (mine are 3.9 ms and 5.0 ms). |
| **Vendor ID / Device ID** | The device's built-in "ID card". On connection every IO-Link device tells the master who made it and precisely what it is, as hex IDs the master reads automatically. |
| **Name / Serial** | The product name and unique serial number, read straight off the device. |

Now look at what's actually connected in my setup:

- **Port 1** — `OBD1000-R100-2EP-IO-V31`, Vendor `0001` (Pepperl+Fuchs): the photoelectric sensor from Episode 1.
- **Port 2** — `TP9237`, Vendor `0136` (ifm): a temperature device.
- **Port 3** — IO-Link mode, but nothing plugged in.
- **Port 4** — `PD30CTDR10BPM5IO`, Vendor `0380`: another photoelectric sensor, from a different manufacturer again.

And that's the point worth pausing on. **Three different manufacturers, three different
kinds of sensor, one master, one page** — and they all simply appear, correctly
identified, with no configuration on my part. That's the whole promise of IO-Link: a
standard language every device speaks, so the master doesn't care who built it.

To prove it's live, plug a device into the empty port and refresh the page — it shows up
immediately, fully identified. Pull it out and refresh — it's gone. No setup, no code.

## The master's own health (Supervision)

Scroll down and you get a second table, labelled **Supervision**. This one isn't about
your sensors at all — it's the master monitoring *itself*.

| Value | Reading | Why it matters |
|---|---|---|
| **Current** | `117 mA` | Total current all connected devices are drawing through the master. A device developing a fault and pulling too much current shows up here. |
| **Voltage** | `24399 mV` (24.4 V) | Your live supply voltage. If it starts sagging under load, you'll see it. |
| **Status** | `0` | Zero means healthy — no fault. |
| **Temperature** | `41 °C` | The master's own internal temperature — condition monitoring of the master itself. |

There's a nice demonstration hiding in here: unplug a sensor and watch the **Current**
figure drop by that device's consumption, then climb back when you reconnect it. It's all
live. And it's worth appreciating that current, voltage and temperature are exactly the
sort of readings you'd normally need PLC code to obtain — here they're simply presented
in a browser.

## Firmware and software

The last table lists the master's **firmware, container and bootloader** versions. It's
dry, but genuinely useful when you're troubleshooting, following a setup guide, or
checking whether an update applies to you. Mine is on firmware `v3.1.97`. Alongside it
are handy links to the product page, the setup guide and software download, and the
open-source licences included in the product.

## The honest verdict: basic by design

Let's be straight about it — the page is basic. It's plain to look at, it doesn't refresh
on its own so you're forever hitting reload, and it won't show you live *readings* from
the sensors, only what's connected.

But here's the part most people miss: **this page isn't really the product.** Every value
on it is also served up by the master as machine-readable data through an API — ifm call
it the IoT Core. The web page is just one simple view of that data. The master isn't
limited to this page at all; *we* are, only for as long as we choose to look at it this
way.

## So can we do better? Absolutely

Because all of this comes from an API, we're free to grab the same data ourselves and
present it however we like — live, auto-updating, every port at once, with the master's
health plotted over time, and styled to actually look good. No vendor software required;
it can run in the very same browser.

That's where this series goes next. In the upcoming episodes we pull data straight out of
the master with plain **HTTP**, then do it from a **Siemens S7-1200 PLC with no Profinet**,
and build a custom dashboard on top of it all.

The built-in web page is the perfect starting point: it proves, in about ten seconds and
with zero software, that your IO-Link master is an open, queryable device. Everything else
we build stands on that.

---

*Part of the IO-Link Practical Course by Hamed Adefuwa.
Subscribe on YouTube: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa).*
