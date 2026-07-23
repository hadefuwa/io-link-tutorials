# Lesson 1 — Overview: What Is IO-Link

**Status:** ✅ Published · **Length:** ~8–10 min · Channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)

## Hook
*What IO-Link actually is — demonstrated, not lectured.*

## Description
Series opener. Show a real IO-Link sensor working and explain why it beats a plain
on/off sensor. Live demo with the AL1350 master, a photoelectric sensor, and the
custom PC dashboard.

## Shot list / segments
- What IO-Link is: point-to-point, IEC 61131-9, vs a standard digital sensor
- Master vs Device — the C/Q line carries data, not just on/off
- Process data (cyclic) vs service data (parameters + diagnostics)
- Live demo: the object-detected bit changing in real time
- The reveal: the SAME sensor also gives signal strength, temperature, hours

## On-screen demo
Wave a hand in front of the sensor → detection LED flips. Then show the extra data
(signal level, temperature) on the custom dashboard.

## Gear / props
- ifm AL1350 IO-Link master
- Pepperl+Fuchs OBD1000-R100-2EP-IO-V31 photoelectric sensor
- PC + the custom dashboard app

## Resources
- **Custom dashboard app:** `../io-link-dashboard/` (double-click `start.bat`)
- **Sensor reference (IODD + datasheet):** `../docs/OBD1000-R100-2EP-IO-V31/`
- Put raw screen/camera recordings in `recording/`, thumbnails & graphics in `assets/`.

## YouTube description (ready to paste)
> **IO-Link Practical Course #1 – What Is IO-Link?**
>
> Ever wondered what IO-Link actually is — and why it's quietly taking over industrial
> sensing? I wire up a sensor, build a custom app on my PC, and pull data off the sensor
> a normal switch could never give you.
>
> 🔧 In this video: what IO-Link is vs a standard sensor · connecting the ifm AL1350 to a
> photoelectric sensor · a live dashboard on the PC · the hidden extra data (signal, quality,
> temperature, hours).
>
> 🛠️ Hardware: ifm AL1350 · Pepperl+Fuchs OBD1000 · PC dashboard.
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #IndustrialAutomation #Sensors #Automation #Industry40
