# IO-Link Tutorials

[![GitHub](https://img.shields.io/badge/GitHub-hadefuwa%2Fio--link--tutorials-blue)](https://github.com/hadefuwa/io-link-tutorials)

Hands-on video tutorials and reference materials for learning **IO-Link** — from the basics through real-world setup, configuration, and data access.

This repository supports the accompanying **YouTube tutorial series**. Each episode walks through practical steps using real industrial hardware so you can follow along at your own pace.

**Repository:** [github.com/hadefuwa/io-link-tutorials](https://github.com/hadefuwa/io-link-tutorials)

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
| **IO-Link Device** | [Pepperl+Fuchs OBD1000-R100-2EP-IO-V31](https://www.pepperl-fuchs.com/en/products-gp25581/69880) | Diffuse-mode photoelectric sensor with IO-Link |

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

## Tutorial Series (Planned)

| # | Topic | What you'll learn |
|---|-------|-------------------|
| 1 | **What is IO-Link?** | IO-Link vs standard digital I/O, master/device roles, when to use it |
| 2 | **Hardware & Wiring** | Power, cabling, port modes, first physical connection |
| 3 | **Master Setup** | AL1350 web interface, port configuration, device detection |
| 4 | **SIO Mode** | Using the sensor as a normal digital input (no IO-Link stack) |
| 5 | **IO-Link Mode** | Enabling IO-Link, reading process data, device identification |
| 6 | **IODD & Parameters** | Loading the IODD, reading/writing device parameters |
| 7 | **Diagnostics** | Device status, error codes, maintenance data |
| 8 | **IoT Data Path** | MQTT/JSON from the AL1350 IoT port to a PC or dashboard |
| 9 | **PLC Integration** | Connecting via PROFINET or EtherNet/IP (overview) |

> YouTube playlist link: *coming soon*

---

## Repository Structure

```
io-link-tutorials/
├── README.md                          ← You are here
├── docs/
│   └── OBD1000-R100-2EP-IO-V31/
│       └── Pepperl-Fuchs_OBD1000_R10x-20180815-IODD1.1.xml   ← Device description (IODD)
├── wiring/                            ← Wiring diagrams and photos (planned)
├── configs/                           ← Example master configs and exports (planned)
└── scripts/                           ← Helper scripts for MQTT/JSON demos (planned)
```

### IODD File

The **IODD** (IO Device Description) XML file in `docs/` describes the Pepperl+Fuchs OBD1000 sensor — its parameters, process data layout, and text labels. Load this file into ifm's engineering software or compatible IO-Link tools to get human-readable parameter names instead of raw index numbers.

- Device ID: `1114369` (`0x110101`)
- IO-Link revision: 1.1

---

## Software & Tools

| Tool | Purpose | Link |
|------|---------|------|
| ifm AL1350 web interface | Configure ports, view connected devices | `http://<master-ip>` (default via DHCP or USB) |
| ifm moneo configure | Device parameterization, IODD import | [ifm moneo](https://www.ifm.com) |
| ifm IoT Core | Cloud/edge connectivity for AL1350 | [ifm IoT Core](https://www.ifm.com) |
| IO-Link Community IODD finder | Download IODD files for other devices | [io-link.com](https://www.io-link.com) |

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

Documentation and tutorial materials in this repository are provided for educational purposes. Hardware trademarks belong to their respective owners (ifm electronic, Pepperl+Fuchs).

---

## About

Created by [hadefuwa](https://github.com/hadefuwa) to help engineers, technicians, and automation enthusiasts understand IO-Link through practical, follow-along video tutorials.

- **GitHub:** [hadefuwa/io-link-tutorials](https://github.com/hadefuwa/io-link-tutorials)
- **YouTube:** *channel link coming soon*
