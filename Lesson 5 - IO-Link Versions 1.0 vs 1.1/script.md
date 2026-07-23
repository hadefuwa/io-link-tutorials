# Lesson 5 — Script: IO-Link 1.0 vs 1.1 (dashboard-led)

**Runtime:** ~5–6 min · Channel: @hamedadefuwa
*Clean narration. The `▶` lines are the only actions — they tell you which dashboard tab to be on.*

---

## COLD OPEN

Two sensors. Both photoelectric. Both detect an object. Same cable, same comms speed, same connector.

But one of them will cost you an hour every single time it fails — and the only real difference between them is a version number.

---

## INTRO

Hey guys, welcome back to the IO-Link practical course. Today it's IO-Link **1.0 versus 1.1**.

I've got one of each sitting on the bench, and rather than just tell you the differences, I've built a dashboard so you can actually see them. Let's go.

---

## ▶ LIVE TAB

Here they are, side by side.

On the left, a Carlo Gavazzi PD30 — that's **version 1.1**. On the right, a Contrinex — **version 1.0**.

And watch them work. Both detecting. Both streaming live data back to me. Both running at the same 38.4 kBaud. If this screen was all you ever saw, you'd say these two sensors are identical.

And for the basic job — is something there, yes or no — they genuinely are.

---

## ▶ SETTINGS TAB

This is where it starts to change.

Same two sensors. The **1.1** device gives me **twenty-six** settings I can change from here. The **1.0** device gives me **ten**.

But here's the bit most people get wrong — and I want to be really clear about it. That 1.0 sensor is **not** read-only. I can set its sensitivity from here. I can fire a teach command at it. All over the wire, no screwdriver, no ladder, no walking out to the machine.

So it's not "configurable versus not configurable." It's **fewer settings**, and they're packed into one block instead of each having its own address.

---

## ▶ THE FILE TAB

Now, don't take my word for any of this — the sensors tell you themselves.

Every IO-Link device ships with an IODD file, and right at the top of that file it declares its own version. There it is. **V1.1**. **V1.0**. Written into the file by the manufacturer.

And look at the size difference. **175 kilobytes** against **19**. Same job, nine times the description — more parameters, more labels, more menus. The file size alone tells you how much sensor you're getting.

---

## ▶ VERSIONS TAB

So what actually changed between the two? Four things.

**Speed.** 1.1 makes the fast COM3 rate mandatory — but mandatory for the **master**, not the device. Devices still only ever run one speed. My 1.1 sensor here runs COM2, same as the old one.

**Process data.** 1.1 allows up to 32 bytes per port, so there's room for sensors that send you a lot more than on-off.

**Compatibility.** A 1.1 master runs both old and new devices. A 1.0 master only runs 1.0 devices. So whatever else you do — buy a 1.1 master.

And number two. The one that actually matters. **Data Storage.**

On 1.1, the master remembers the sensor's settings. The sensor fails, an operator plugs a new one in, and the master writes every setting back automatically. Line runs.

On 1.0, somebody is walking out there with a laptop.

---

## OUTRO

So — is 1.0 rubbish? Honestly, no. It still gives you identity, remote configuration, real diagnostics — everything a standard on-off sensor simply cannot do.

But if you're buying today, buy **1.1**. And definitely buy a **1.1 master**. That one feature — Data Storage — is the one you'll thank yourself for at two in the morning.

If this helped, hit subscribe — the channel's @hamedadefuwa. Next video we start pulling this data out with a PLC. Cheers.

---

## Filming checklist
- [ ] Dashboard open, **Port A = X04 PD30 (1.1)**, **Port B = X03 Contrinex (1.0)**
- [ ] Start on the **Live** tab; move a target so both LEDs fire during the opening
- [ ] Tab order: **Live → Settings → The File → Versions** (matches the script top to bottom)
- [ ] On Settings, hover/point at **26** and **10**
- [ ] On The File, point at the `iolinkRevision` line and the file-size bars
- [ ] On Versions, land hard on **row 2 (Data Storage)** — that's the money line
- [ ] Have both sensors physically on the bench for the cold open
