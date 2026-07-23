# IO-Link Tutorials

[![GitHub](https://img.shields.io/badge/GitHub-hadefuwa%2Fio--link--tutorials-blue)](https://github.com/hadefuwa/io-link-tutorials)

Hands-on video tutorials and reference materials for learning **IO-Link** — from the basics through real-world setup, configuration, and data access.

This repository supports the accompanying **YouTube tutorial series**. Each episode walks through practical steps using real industrial hardware so you can follow along at your own pace.

**Repository:** [github.com/hadefuwa/io-link-tutorials](https://github.com/hadefuwa/io-link-tutorials)
**YouTube:** [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)

---

## What is IO-Link?

**IO-Link** is a standardized point-to-point communication protocol (IEC 61131-9) for connecting sensors and actuators to automation systems.

Unlike a simple on/off digital signal, IO-Link lets you:

- Read **process data** (e.g. object detected, distance, temperature)
- Access **service data** (parameters, diagnostics, device identification)
- **Configure devices** remotely without opening the enclosure
- Use **IODD files** (IO Device Description) to understand what each device can do

Think of it as giving every sensor a small, standardized "data sheet" that your master can read automatically.

---

## Hardware Used in This Series

| Role | Device | Description |
|------|--------|-------------|
| **IO-Link Master** | [ifm AL1350](https://www.ifm.com) | DataLine 4-port IO-Link master with built-in IoT interface |
| **IO-Link Device** | [Pepperl+Fuchs OBD1000-R100-2EP-IO-V31](https://www.pepperl-fuchs.com/en/products-gp25581/69880) | Diffuse-mode photoelectric sensor with IO-Link 1.1 (main demo device) |
| **IO-Link Device** | Carlo Gavazzi PD30CTDR10BPM5IO | Diffuse photoelectric sensor with IO-Link 1.1 |
| **IO-Link Device** | Contrinex LLR-C23PA-NMS-400 | Photoelectric sensor with IO-Link **1.0** — used to demo 1.0 vs 1.1 differences (Lesson 5) |

Datasheets and IODD files for all three sensors are in [docs/](docs/).

### ifm AL1350 — IO-Link Master (IoT)

| Feature | Detail |
|---------|--------|
| IO-Link ports | 4 × Class A ports (X01–X04) |
| Digital inputs | 8 (4 ports × 2 pins each in SIO mode) |
| Fieldbus | PROFINET, EtherNet/IP, EtherCAT, POWERLINK, Modbus TCP (multiprotocol) |
| IoT interface | HTTP(S), JSON, MQTT — send data to IT/cloud without a PLC |
| Supply voltage | 24 V DC (10.8–30 V DC) |
| Protection | IP65 / IP66 / IP67 |
| Configuration | Integrated web server, ifm software, IoT Core |

The AL1350 is a great learning platform because it combines traditional fieldbus connectivity with a direct IoT path — so you can see IO-Link data on a PLC *and* on a PC or cloud service.

### Pepperl+Fuchs OBD1000-R100-2EP-IO-V31 — Photoelectric Sensor

| Feature | Detail |
|---------|--------|
| Type | Diffuse-mode photoelectric sensor |
| Detection range | 2–1000 mm (adjustable 50–1000 mm) |
| IO-Link revision | 1.1 |
| Device ID | `0x110101` (1114369) |
| Transfer rate | COM2 (38.4 kbit/s) |
| Process data | 1 bit input, 2 bits output |
| SIO mode | Supported (works as a standard digital sensor too) |
| Connection | M8 × 1, 4-pin |
| Supply voltage | 10–30 V DC |
| Protection | IP67 / IP69 / IP69K |

This sensor is ideal for tutorials: it is small, affordable, easy to demo (wave your hand in front of it), and exposes useful IO-Link parameters like switching state, diagnostics, and configuration.

---

## Wiring Overview

A minimal bench setup looks like this:

```
┌─────────────────┐         M12 cable          ┌──────────────────────────────┐
│   24 V DC       │───────────────────────────►│  ifm AL1350                  │
│   Power Supply  │                            │  IO-Link Master              │
└─────────────────┘                            │                              │
                                               │  Port X01 ──► OBD1000 sensor │
┌─────────────────┐         Ethernet           │  Port X02–X04 (spare)        │
│   PC / PLC      │◄──────────────────────────►│  Fieldbus + IoT ports      │
└─────────────────┘                            └──────────────────────────────┘
```

### IO-Link cable pinout (Class A, 4-pin M12)

| Pin | Signal | Purpose |
|-----|--------|---------|
| 1 | L+ | 24 V DC supply |
| 2 | L− | 0 V (ground) |
| 3 | DI / DO | Digital I/O (SIO mode) |
| 4 | C/Q | Communication / switching (IO-Link data line) |

> **Tip:** Use a shielded IO-Link cable (M12 to M8 adapter if needed) and keep cable lengths within the device specifications for reliable COM2 communication.

---

## Tutorial Series

Each lesson has its own folder with a README, video script, and YouTube description.

| # | Topic | Status | What you'll learn |
|---|-------|--------|-------------------|
| 1 | [What Is IO-Link?](Lesson%201%20-%20Overview/README.md) | ✅ Published | IO-Link vs standard digital I/O, master/device roles, when to use it |
| 2 | [IO-Link Master Software (ifm moneo)](Lesson%202%20-%20IO-Link%20Master%20Software/README.md) | ✅ Published | Configuring smart devices with manufacturer software — no code |
| 3 | [The IO-Link Master Web Server](Lesson%203%20-%20IO-Link%20Master%20Web%20Server/README.md) | 🔵 Planned | The AL1350's built-in web server — read live data with no software installed |
| 4 | [IODD Files & the IODD Database](Lesson%204%20-%20IODD%20Files%20and%20Database/README.md) | 🔵 Planned | How software understands any sensor from any brand; reading the IODD XML |
| 5 | [IO-Link Versions: 1.0 vs 1.1](Lesson%205%20-%20IO-Link%20Versions%201.0%20vs%201.1/README.md) | 🔵 Planned | What changed between versions and why it matters before you buy a sensor |
| — | HTTP from an S7-1200 PLC (no Profinet) | 🔵 Planned | Reading IO-Link data over HTTP from a Siemens PLC |
| — | MQTT from an S7-1200 PLC (no Profinet) | 🔵 Planned | Streaming IO-Link data over MQTT from a Siemens PLC |

See [course-description.md](course-description.md) for the full playlist description and [course-plan.html](course-plan.html) for the visual course plan.

> YouTube channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)

---

## Repository Structure

```
io-link-tutorials/
├── README.md                              ← You are here
├── course-description.md                  ← Playlist description (copy-paste ready)
├── course-plan.html                       ← Visual course plan
├── Lesson 1 - Overview/                   ← Per-lesson README, script, YouTube description
├── Lesson 2 - IO-Link Master Software/
├── Lesson 3 - IO-Link Master Web Server/
├── Lesson 4 - IODD Files and Database/
├── Lesson 5 - IO-Link Versions 1.0 vs 1.1/
├── docs/
│   ├── OBD1000-R100-2EP-IO-V31/           ← Pepperl+Fuchs sensor: IODD 1.1, datasheet, images
│   ├── Carlo Gavazzi PD30CTDR10BPM5IO/    ← Carlo Gavazzi sensor: IODD 1.1, datasheet
│   ├── Contrinex LLR-C23PA-NMS-400/       ← Contrinex sensor: IODD 1.0.1, datasheets
│   └── User Manual.pdf                    ← ifm AL1350 manual
├── images/                                ← Thumbnails and screenshots
└── io-link-dashboard/                     ← Live browser dashboard (see below)
```

### IODD Files

Each sensor folder in `docs/` contains the **IODD** (IO Device Description) XML describing that device — its parameters, process data layout, and text labels. Load an IODD into ifm's engineering software or compatible IO-Link tools to get human-readable parameter names instead of raw index numbers.

The main demo device is the Pepperl+Fuchs OBD1000:

- Device ID: `1114369` (`0x110101`)
- IO-Link revision: 1.1

---

## Live Dashboard App (`io-link-dashboard/`)

A zero-install browser dashboard that reads and writes the sensor live through the AL1350's IoT Core (HTTP/JSON) interface. **Windows PowerShell + a browser only** — no Node, no admin rights.

```
Browser (index.html) ◄──► server.ps1 (loopback proxy) ◄──► AL1350 IoT Core (192.168.7.4)
```

- **Run it:** double-click `io-link-dashboard/start.bat` — it starts a small PowerShell web server (auto-picks a free port from 8088) and opens the dashboard.
- Live process data, ISDU parameter read/write (signal level, temperatures, operating hours, SP1 threshold, switching logic, user tag), all decoded per the OBD1000 IODD.
- Master IP and ports are configured in `config.json`, editable live in the UI.
- Extras: `explorer.html` (IoT Core API explorer), `demo-dashboard.html` (offline demo), `deck.html` / `present.html` (presentation decks), `test-connection.ps1` and `plc-test.ps1` (CLI probes).

---

## Software & Tools

| Tool | Purpose | Link |
|------|---------|------|
| ifm AL1350 web interface | Configure ports, view connected devices | `http://<master-ip>` (default via DHCP or USB) |
| ifm moneo configure | Device parameterization, IODD import | [ifm moneo](https://www.ifm.com) |
| ifm IoT Core | Cloud/edge connectivity for AL1350 | [ifm IoT Core](https://www.ifm.com) |
| IO-Link Community IODD finder | Download IODD files for other devices | [ioddfinder.io-link.com](https://ioddfinder.io-link.com) |
| Live dashboard (this repo) | Browser dashboard for live sensor data via IoT Core | [io-link-dashboard/](io-link-dashboard/) |

---

## Quick Start Checklist

1. **Power** the AL1350 with 24 V DC
2. **Connect** the OBD1000 sensor to port X01 with an IO-Link cable (M12 on master side, M8 on sensor side)
3. **Connect** your PC to the AL1350 via Ethernet
4. **Open** the AL1350 web interface in a browser
5. **Set** port X01 operating mode to **IO-Link**
6. **Verify** the sensor is detected (vendor: Pepperl+Fuchs, Device ID: 1114369)
7. **Load** the IODD file from `docs/OBD1000-R100-2EP-IO-V31/` into your configuration tool
8. **Read** process data — wave an object in front of the sensor and watch the switching state change

---

## Key IO-Link Concepts (Glossary)

| Term | Meaning |
|------|---------|
| **Master** | Gateway that talks to IO-Link devices (here: AL1350) |
| **Device** | Sensor or actuator with an IO-Link interface (here: OBD1000) |
| **Port** | One physical connection on the master (AL1350 has 4) |
| **Process Data** | Cyclic real-time data (e.g. "object detected" bit) |
| **Service Data** | Acyclic parameter access (configuration, diagnostics) |
| **IODD** | XML file describing a device's parameters and data structure |
| **SIO mode** | Standard IO — device behaves like a normal digital sensor |
| **COM2** | IO-Link communication speed (38.4 kbit/s) |

---

## Useful Links

- [IO-Link Consortium](https://www.io-link.com) — official specification and resources
- [ifm AL1350 product page](https://www.ifm.com)
- [ifm IO-Link learning hub](https://www.ifm.com/us/en/us/learn-more/io-link)
- [Pepperl+Fuchs OBD1000 datasheet](https://www.pepperl-fuchs.com/en/products-gp25581/69880)
- [IEC 61131-9 (IO-Link standard)](https://webstore.iec.ch/en/publication/4552)

---

## Contributing

Found an error in the docs, have a wiring tip, or want to suggest a tutorial topic?

- [Open an issue](https://github.com/hadefuwa/io-link-tutorials/issues)
- [Submit a pull request](https://github.com/hadefuwa/io-link-tutorials/pulls)

---

## License

Documentation and tutorial materials in this repository are provided for educational purposes. Hardware trademarks belong to their respective owners (ifm electronic, Pepperl+Fuchs, Carlo Gavazzi, Contrinex, Siemens).

---

## About

Created by [hadefuwa](https://github.com/hadefuwa) to help engineers, technicians, and automation enthusiasts understand IO-Link through practical, follow-along video tutorials.

- **GitHub:** [hadefuwa/io-link-tutorials](https://github.com/hadefuwa/io-link-tutorials)
- **YouTube:** [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)
