# Lesson 3 — Video Script: The IO-Link Master Web Server

**Runtime:** ~10–12 min · Channel: @hamedadefuwa
*Clean spoken narration — stage directions removed. Shot/demo list is in the Production checklist at the bottom.*

---

## COLD OPEN / HOOK

Right — this little box here is an IO-Link master. And most people don't realise… it's actually a web server.

You just type its IP address into a browser… and boom. Every sensor plugged into it, right there. No software to install, no PLC, nothing. Just a browser.

Now — it's a *bit* basic, and we'll be honest about that. But stick around, because by the end of this video I'll show you how we take everything on this page and build something a lot nicer.

---

## INTRO

Hey guys, welcome back to the IO-Link practical course.

In the last two videos we covered what IO-Link actually is, and we configured a sensor using ifm's moneo software. This time we're going even simpler — no software at all. We're just going to open the master's built-in web page and see how much it can tell us. Let's get into it.

---

## SEGMENT 1 — Finding your master's IP address

So first — how do you even get to this page. Every ifm IoT master, like this AL1350, has a web server built in. All you need is its IP address… but that's exactly the bit that trips people up. How do you find the IP in the first place?

There are a few ways. Straight out of the box, the master is set to **DHCP**. So if you've got a router or a DHCP server on your network, the master just gets handed an address automatically. The easy option is to open your router's list of connected devices and find it in there.

And to know *which* one is yours — the master's **MAC address is printed on the label** on the side of the unit. Just match that up in the list.

But the proper way — the way ifm intend — is with their software. **LR DEVICE**, or **moneo**, has a "scan network" button. Hit that and it goes and finds the master for you and shows you its IP — and here's the clever part: it works **even if your PC isn't on the same IP range yet**, because it uses a discovery protocol rather than needing the address up front. That's the one I'd reach for.

One more to know about: if the master has **never seen a DHCP server**, it falls back to an address starting `169.254` — that's its factory default. So if you ever spot that, it just means "nobody's given me a proper address yet."

Right — once you've got the IP, the rest is easy. Drop it into any browser on the same network — mine's `192.168.7.4` — hit Enter, and you're in. No login, no software.

Quick note — if you've got the right IP but the page still won't load, that's almost always a networking thing: your PC needs to be on the same range as the master. I'll pop a video on that in the corner.

---

## SEGMENT 2 — The port table

Right, this top table is the good stuff. This is every port on the master — it's a 4-port master, so ports 1 through 4 — and exactly what's plugged into each one. Let me walk across the columns.

First, **Mode**. All four of mine say "IO-Link" in green — that means the port's in full IO-Link mode, talking data. You *can* set a port to behave like a plain on-off input instead, but here they're all IO-Link.

Next, **Comm Mode** — 38.4 kBaud. That's the comms speed. IO-Link has three: COM1, COM2, COM3. This is COM2, and honestly that's what the big majority of devices use.

Then **Master Cycle Time**. Port 1's at 3.9 milliseconds, port 4's at 5. That's how often the master talks to that device — basically how fresh your data is. Different devices, different speeds.

Now these two — **Vendor ID** and **Device ID** — this is my favourite bit. Every IO-Link device carries its own little ID card. Plug it in, and it tells the master "here's who made me, and here's exactly what I am." The master reads that automatically. So Vendor 0001 here is Pepperl+Fuchs, 0136 is ifm, and 0380 is a third manufacturer.

And that's where the **Name** and **Serial** come from — read straight off the device.

So look what I've actually got. Port 1 — that's the Pepperl+Fuchs photoelectric from video one. Port 2 — an ifm temperature device. Port 3 — nothing plugged in. Port 4 — another photoelectric, different brand again.

And this is what I want you to notice. Three different manufacturers. Three different types of sensor. One master, one page — and they all just… show up. That's IO-Link. It's a standard language every device speaks, so your master doesn't care who made it. That's the whole point of it.

And to prove it's live — watch. I'll plug a sensor into that empty port 3… refresh… and there it is. The master found it, identified it, done. Pull it out, refresh — gone. No config, no code.

---

## SEGMENT 3 — Supervision (the master's own health)

Scroll down and there's a second table — **Supervision**. This one isn't about the sensors, it's the master checking on *itself*.

**Current** — 117 milliamps. That's the total power all my sensors are pulling through the master right now. Really handy — if a sensor goes faulty and starts drawing loads, you'd spot it here.

Actually — watch this number when I unplug a sensor… see it drop? That's that sensor's current disappearing. Plug it back… back up. Live, in real time.

**Voltage** — 24 thousand-ish millivolts, so 24.4 volts. That's my supply voltage, live. If that started sagging, you'd know something was up.

**Status** — zero. Zero is good. Zero means no faults.

And **Temperature** — 41 degrees. That's the master's own internal temperature. So it's literally monitoring its own health and handing it to you on a web page.

And just think about that — normally, to get current, voltage and temperature off a device, you'd be writing PLC code. Here it's just… there. In a browser.

---

## SEGMENT 4 — Software / firmware

Last table — **Software**. Firmware, container, and bootloader versions. Bit dry, but genuinely useful: if you're troubleshooting, or following a guide, or ifm say there's an update — this is where you check what you're on. Mine's firmware v3.1.97.

And these orange links — product page, the setup guide and software download, and the open-source licences. Handy shortcuts, worth knowing they're there.

---

## SEGMENT 5 — The honest take

So… that's the page. And I'll be straight with you — it *is* basic. It's a bit ugly, it doesn't update on its own so you're constantly hitting refresh, and it won't show you live *readings* from the sensors — just what's connected.

But here's the important bit, and it's the thing most people miss. This page isn't really "the product." Every number you're looking at — the master is *also* serving all of it up as data, through an API. This web page is just one simple little view of it.

Which means we are absolutely not stuck with this. We can grab that same data ourselves and do whatever we like with it.

---

## SEGMENT 6 — The cliffhanger / reveal

And that's exactly what I've done. Same master, same data — but live, auto-updating, every port at once, the master's health on a little graph… and it actually looks half decent.

I'm going to show you how to build this yourself — no fancy software, runs in a browser — over the next couple of videos, where we pull data straight out of the master with plain HTTP, and even talk to it from a Siemens PLC with no Profinet in sight.

---

## OUTRO / CTA

So — the master's web page: brilliant for a quick look, dead simple, zero software. Just don't stop there, because there's a whole API underneath it waiting to be used.

If this helped you out, hit subscribe — the channel's @hamedadefuwa — and I'll see you in the next one, where we start pulling this data out for ourselves. Cheers.

---

## Production checklist
- [ ] Have all 3 devices connected (Port 1 OBD1000 · Port 2 TP9237 · Port 4 PD30); leave Port 3 free for the plug-in demo.
- [ ] **Segment 1 B-roll:** router client list · close-up of the master's label (MAC) · LR DEVICE/moneo "scan network" finding the master.
- [ ] Screen-record the page at 1080p+; zoom/crop each table in post.
- [ ] Capture the two live demos: **plug into Port 3** (device appears) and **unplug** (Current drops).
- [ ] Grab one shot of a raw JSON response for Segment 5.
- [ ] Have the custom dashboard ready to cut to in Segment 6.
- [ ] Confirm on camera: Vendor `0380` maker. (Orange Port 2 = **ifm article, links to the ifm product page** — per the manual; just click it.)
