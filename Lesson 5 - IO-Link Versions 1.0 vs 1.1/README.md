# Lesson 5 — IO-Link Versions: 1.0 vs 1.1

**Status:** 🔵 Planned · **Length:** ~8–10 min · Channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)

## Title options
- "IO-Link 1.0 vs 1.1 — CHECK THIS Before You Buy a Sensor"
- "The IO-Link Version Trap (1.0 vs 1.1 Explained)"
- "IO-Link Practical Course #5: Why Version 1.1 Matters"

## Hook
*Two sensors, same job, same price — one of them will cost you an hour every time it fails.
The difference is a version number on the datasheet.*

## The one-sentence idea
IO-Link 1.1 added **Data Storage** — the master backs up a device's settings and automatically
restores them to a replacement — plus bigger process data. Buy 1.1.

---

## ⚠️ ACCURACY NOTE — verify before recording
The claim *"1.0 is read-only, you can't write parameters"* does **not** appear to be correct.
Parameter read **and** write over ISDU exists in 1.0 too. What's true is that **ISDU support was
optional in 1.0**, so some cheap 1.0 devices expose few or no writable parameters.

**Lead with Data Storage instead** — it's the real, defensible difference and a stronger argument.
Double-check these against the spec / a datasheet before filming:
- [ ] Data Storage is 1.1-only ✔ (headline claim)
- [ ] Process data: 1.0 = max 2 bytes each way · 1.1 = up to 32 bytes
- [ ] Block parameterisation is 1.1-only
- [ ] A 1.1 **master** works with 1.0 devices; a 1.0 master struggles with 1.1 devices

---

## Segment outline

**1 — The setup.** Two sensors on the bench that look identical and do the same job. One's 1.0,
one's 1.1. Why should you care? (Tease: one of them costs you an hour every time it breaks.)

**2 — What actually changed in 1.1.** Keep it to four things, in plain English:
- **Data Storage** ⭐ — the master remembers the device's settings and writes them into a
  replacement automatically.
- **Bigger process data** — 1.0 caps at ~2 bytes each way; 1.1 goes up to 32. That's why richer
  sensors (distance + quality + temperature at once) need 1.1.
- **Block parameterisation** — write a whole settings set in one consistent go.
- **ISDU** — parameter read/write exists in both, but was *optional* in 1.0, so cheap 1.0 devices
  may barely expose anything. (Correct the common myth here rather than repeat it.)

**3 — Why Data Storage is the one that matters.** The maintenance story: sensor fails at 2am, an
operator swaps it, the master pushes the old settings in automatically, line runs. Versus 1.0:
find the laptop, find the software, find the settings, reconfigure by hand.

**4 — How to check what version you've got.** Three places:
- The **datasheet** — look for "IO-Link revision 1.1"
- The **IODD** — the file itself is versioned (ours is an IODD 1.1)
- The **master / moneo** — it reports the connected device's revision

**5 — Buying advice (the takeaway).**
- Always buy a **1.1 master** — it's backwards compatible with 1.0 devices.
- Prefer **1.1 devices**; check the datasheet line before you order.
- A 1.0 device isn't useless — it just won't auto-restore, and can't send much data.

**6 — Tease next.** Now that we know what we're buying and how to decode it, next we start pulling
the data out ourselves — HTTP, then from a PLC.

---

## ⭐ Best demo — Data Storage in action
This *shows* the whole argument in 60 seconds:
1. Change a parameter on the OBD1000 (e.g. set the switching threshold to something obvious).
2. Unplug it. Plug in an identical device at factory settings.
3. The master **automatically writes the stored parameters back** — the new device comes up
   already configured.
4. Say: *"That's Data Storage. On a 1.0 device, none of that happens."*

*(The AL1350 supports Data Storage — it's in the manual under the port/data-storage settings.)*

## Secondary demos
- Show the version field on a datasheet, in the IODD, and in moneo — three places, same answer.
- Compare two devices' process-data sizes to make the 2-byte vs 32-byte point concrete.

## Gear / props
- ifm AL1350 + at least one 1.1 device (OBD1000 is **IO-Link 1.1**)
- Ideally a **1.0 device** to contrast — if you don't have one, use datasheets on screen instead
- A spare/identical sensor for the Data Storage swap demo
- moneo (to show the reported revision)

## Resources
- OBD1000 datasheet + IODD: `../docs/OBD1000-R100-2EP-IO-V31/`
- AL1350 manual (Data Storage section): `../docs/User Manual.pdf`
- Raw recordings → `recording/`, graphics → `assets/`, datasheet clips → `resources/`

## YouTube description (draft — finalise after recording)
> **IO-Link Practical Course #5 – IO-Link 1.0 vs 1.1 (Check Before You Buy!)**
>
> Two IO-Link sensors can look identical and do the same job — but if one is version 1.0, it'll
> cost you every time it fails. In this video I explain the real differences between IO-Link 1.0
> and 1.1, why **Data Storage** is the feature that actually matters, and the three places to check
> a device's version before you buy it.
>
> 🔧 In this video: what changed in IO-Link 1.1 · Data Storage explained (and demonstrated) ·
> process data limits · how to check a device's version · what to look for when buying.
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #IndustrialAutomation #Sensors #Automation #ifm #Maintenance
