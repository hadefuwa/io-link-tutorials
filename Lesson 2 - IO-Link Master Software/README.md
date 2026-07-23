# Lesson 2 — IO-Link Master Software (ifm moneo)

**Status:** ✅ Published · **Length:** ~10 min · Channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)

## Hook
*Configure a smart sensor in minutes — no code.*

## Description
Show the power and simplicity of ifm's own configuration software. Add the master,
browse the device with the IODD auto-loaded, and read/write parameters.

## Shot list / segments
- What moneo is and where it fits
- Add the AL1350 as an **ifm Device (IoT Core)**: `192.168.7.4`, port `80`, HTTP (no login)
- Browse port X01 — the auto-loaded IODD gives human-readable parameter names
- Read live values; change the switching set-point and see the effect
- moneo vs raw JSON vs a custom app — when to use which

## On-screen demo
Add the master in moneo, read signal level / temperature, change the switch point,
watch the detection behaviour change.

## Gear / props
- ifm AL1350, OBD1000 sensor
- PC with **ifm moneo** installed

## Gotchas to mention on camera
- Select **ifm Device (IoT Core)** (not UDP / VSE) — the AL1350 speaks IoT Core JSON over HTTP.
- Port **80**, HTTPS **off**, username/password **blank**.
- Only **one** app should hold the master's parameter channel at a time — close any custom
  dashboard first, or moneo throws a "connection to sensor not possible" error.

## Resources
- **Sensor reference (IODD + datasheet):** `../docs/OBD1000-R100-2EP-IO-V31/`
- Raw recordings → `recording/`, thumbnails & graphics → `assets/`, any exports → `resources/`.

## YouTube description (draft — tidy before posting)
> **IO-Link Practical Course #2 – Manufacturer's Software (ifm moneo)**
>
> You don't need to write code to configure an IO-Link sensor. In this episode I use ifm's
> moneo software to connect to the AL1350, browse the sensor, and change its parameters live —
> with the IODD doing all the translation for you.
>
> 🔧 In this video: what moneo is · adding the master over IoT Core · reading live diagnostics ·
> changing the switch point · when to use moneo vs a custom app.
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #ifm #moneo #IndustrialAutomation #Sensors
