# Lesson 3 — IO-Link Master Web Server (AL1350)

**Status:** 🔵 Planned · **Length:** ~10–12 min · Channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)
**Device page:** `http://192.168.7.4/`

## Title options
- "Your IO-Link Master is a WEB SERVER (no software needed) — ifm AL1350"
- "IO-Link Practical Course #3: The AL1350 Built-In Web Server"
- "See Every Sensor in a Browser — IO-Link Master Web Interface"

## Hook
*No software, no PLC — just type the master's IP into a browser and see every sensor at once.*

## The one-sentence idea
The AL1350 is itself a tiny web server: point a browser at its IoT IP and you instantly
get live device identity, master health, and firmware info — for **every port, from any
vendor** — without installing a thing.

---

## Script / segment outline (with rough timings)

**0:00 — Cold open.** Screen-record typing `192.168.7.4` into a browser → the page loads.
"This is my IO-Link master. No software installed. Just a browser. Look what it's already
telling me — three sensors, from three different manufacturers, all on one page."

**0:30 — What is this page?** Every ifm IoT master runs a built-in web server. Type the
master's **IoT port IP** into any browser on the same network and you get this live status
page, free. (Quick callback: how you find/set that IP — see Lesson on networking.)

**1:30 — The port table (the heart of it).** Walk each column on camera:
| Column | What to say |
|---|---|
| **Port / Mode** | 4 ports, all in **IO-Link** mode (vs DI/DO/deactivated). Green = active IO-Link comms. |
| **Comm. Mode** | `38.4 kBaud` = **COM2**. IO-Link speeds: COM1 4.8k · COM2 38.4k · COM3 230.4k. Most devices are COM2. |
| **MasterCycleTime** | `3.9 ms` / `5.0 ms` — how often the master swaps process data with **that** device. Varies per device. |
| **Vendor ID / Device ID** | Every device announces *who made it* and *what it is*, as hex IDs the master reads on connect. |
| **Name / Serial** | Product name + unique serial, read straight from the device. |

Point at the actual rows:
- **Port 1** → `OBD1000-R100-2EP-IO-V31`, Vendor `0001` (**Pepperl+Fuchs**) — our Episode 1 sensor.
- **Port 2** → `TP9237`, Vendor `0136` (**ifm**) — a temperature device (note it's highlighted/linked — click it on camera to see what the link does).
- **Port 3** → IO-Link mode, **no device** plugged in.
- **Port 4** → `PD30CTDR10BPM5IO`, Vendor `0380` — a third-vendor photoelectric (PD30 series).

**⭐ Headline point:** three vendors, three device types, one master, one page — that's
**IO-Link interoperability**. A standard datasheet-in-the-device that any master can read.

**5:30 — Supervision (the master's OWN health).**
- **SW-Version** `3`
- **Current** `118 mA` — total current the master is supplying to all sensors. Spot a hungry/shorted device here.
- **Voltage** `24399 mV` = **24.4 V** — your supply, live. Watch it sag under load.
- **Status** `0` — 0 = healthy / no fault.
- **Temperature** `41 °C` — the master's internal temp = condition monitoring of the master itself.

Teaching point: this is diagnostics you'd normally need a PLC + code for — here it's a web page.

**7:30 — Software / firmware panel.**
- Firmware `AL1x5x_fw_it_f7_v3.1.97` · Container `AL1x5x_cn_it_v3.1.97` · Bootloader `AL1xxx_bl_f7_v2.4.1`.
- Why versions matter (features, fixes, IoT-Core behaviour); where to update (ifm site / moneo).
- The **Product information** links: product page, setup guide & software, open-source licences.

**9:00 — What this page ISN'T.** It's a **read-only overview** — you can't change parameters
here. For that you use moneo (Ep. 2) or the IoT Core API. Tease: "Behind this pretty page is a
JSON API — next episode I read a sensor from it directly, then from a PLC with no Profinet."

**10:00 — Outro / CTA.** Subscribe; next up: the IoT Core API.

---

## ⭐ Best live demos (do these on camera)
1. **Plug/unplug a sensor, then refresh** → the port row appears/empties. Proves the master
   auto-detects any device. (Plug something into the empty **Port 3** and watch it populate.)
2. **Watch the `Current (mA)` change** as you add/remove a sensor — ties the Supervision
   numbers to something physical.
3. **Click the highlighted Port 2 entry** to show what the link does (device look-up).

## Gear / props
- ifm AL1350 with **3 devices**: OBD1000 (P+F, port 1), TP9237 (ifm, port 2), PD30 (port 4)
- PC + browser on the `192.168.7.x` network

## Graphics / B-roll ideas
- Callout boxes labelling each table column as you talk.
- A COM1/COM2/COM3 speed-comparison graphic.
- Vendor ID → manufacturer logo mapping (P+F `0001`, ifm `0136`, `0380`).
- Zoom-ins on the Supervision values; a lower-third "Status 0 = healthy".

## Lower-third callouts
- "COM2 = 38.4 kBaud" · "Vendor ID + Device ID = the device's fingerprint"
- "Master Cycle Time = process-data refresh rate" · "Status 0 = healthy"

## Fact-check before recording
- Confirm the **Vendor `0380`** manufacturer live on camera via the device look-up link
  (PD30 is commonly a Carlo Gavazzi part) — let the page reveal it rather than asserting.
- Confirm what the **orange/highlighted** Port 2 entries link to.

## Resources
- Sensor reference (IODD + datasheet): `../docs/OBD1000-R100-2EP-IO-V31/`
- Protocol cheat-sheet for the next episode: the "AL1350 IoT Core protocol" section of `../CLAUDE.md`
- Raw recordings → `recording/`, graphics → `assets/`, screenshots/exports → `resources/`

## YouTube description (draft — finalise after recording)
> **IO-Link Practical Course #3 – Your IO-Link Master is a Web Server**
>
> Your ifm AL1350 is already a web server — no PLC, no software. In this episode I point a
> browser at the master and read a live status page: every connected sensor (from three
> different manufacturers!), the master's own health — current, voltage, temperature — and its
> firmware, all in one place.
>
> 🔧 In this video: the built-in web interface · reading the port table (vendor/device IDs, cycle
> time, COM2) · IO-Link interoperability across vendors · the master's supervision/diagnostics ·
> firmware info · and why this page is read-only (and what to use instead).
>
> 🛠️ Hardware: ifm AL1350 · Pepperl+Fuchs OBD1000 · ifm TP9237 · PD30 photoelectric.
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #IndustrialAutomation #ifm #IoT #Sensors #Industry40
