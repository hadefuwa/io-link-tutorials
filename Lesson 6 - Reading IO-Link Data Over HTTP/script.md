# Lesson 6 — Video Script: Reading IO-Link Data Over HTTP

**Runtime:** ~12–15 min · Channel: @hamedadefuwa
*Clean spoken narration — stage directions removed. Shot/demo list is in the Production checklist at the bottom.*

---

## COLD OPEN / HOOK

Right — watch this.

*[terminal on screen, type the command live]*

One POST request. That's a live reading from my IO-Link sensor, right now. Hex value, straight back from the master. No PLC. No SCADA. No driver to install. Nothing but HTTP.

That little hex value — I'm going to show you exactly what it means, where it comes from, and how you can do the same thing yourself in about five minutes.

---

## INTRO

Hey guys, welcome back to the IO-Link practical course.

In Lesson 3 we looked at the AL1350's built-in web page — and I said at the end: that page isn't really the product. It's just one simple view of an API sitting underneath. Today we go behind the page and use that API directly.

By the end of this video you'll be able to read any value your IO-Link sensor publishes — switching state, signal level, temperature, operating hours — with a single HTTP call. And write values back too.

Let's get into it.

---

## SEGMENT 1 — The API in one sentence

So first — what are we actually dealing with. The AL1350 runs something called the IoT Core. It's a tiny HTTP server, and it accepts POST requests on one single endpoint: the master's IP address, port 80, root path. That's it. No routes, no versioning. One endpoint.

Every request has the same structure. It's JSON, and there are four fields. `"code"` is always `"request"`. `"cid"` is just a number — a correlation ID so you can match requests to responses when you're sending lots of them; I usually just set it to 1. `"adr"` is the address — that's the thing that changes between calls, it tells the master *what* you want. And `"data"` carries any extra arguments, like which parameter index to read.

The master replies with the same `cid` back, a `"code"` of 200 for success — like an HTTP status code, but in the body — and a `"data"` object containing the value as a hex string.

That's the whole API. Once you've seen it once, you've seen it. Let's use it.

---

## SEGMENT 2 — Reading process data

The first thing to know is the difference between two types of data. **Process data** is the live output the sensor broadcasts every cycle — every four milliseconds or so. It's always fresh, always running. For the OBD1000 photoelectric, that's its switching state: is there an object in front of it or not.

The address for process data on port 1 is: `/iolinkmaster/port[1]/iolinkdevice/pdin/getdata`.

*[send the request live in terminal]*

`"value": "01"`. One byte, one hex pair. And according to the OBD1000's IODD — which we covered in Lesson 4 — bit 0 of that byte is the switching output. `01` means the bit is set: object detected. `00` means clear.

Watch — I'll put my hand in front of the sensor.

*[send the request again with hand in front]*

Still `01`. Pull my hand away.

*[send the request]*

`00`. It switched. That's live process data, read over plain HTTP, with one command.

---

## SEGMENT 3 — Reading parameters

The second type of data is **acyclic parameters** — everything else. Signal level, temperature, operating hours, the switching threshold, even the device's serial number. These aren't broadcast automatically; you have to request them specifically.

The address for a parameter read is: `/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic`.

And now you need the `data` field. You pass two numbers: an `"index"` and a `"subindex"`. Think of these as the parameter's address in the IODD — every readable value has a fixed index number.

Let's read signal level. That's index 236, subindex 1.

*[send request live]*

`"value": "03E8"`. Hex `0x03E8` is 1000 decimal. The OBD1000 reports signal level on a scale of 0 to 1000 — 1000 means maximum signal strength. I've got a bright target right in front of it, so that makes sense.

Let's read temperature. Index 226, subindex 1.

*[send request live]*

`"value": "0019"`. Hex `0x19` is 25 decimal. Twenty-five degrees Celsius. That's the sensor's internal temperature — and that value lives right there in the device, all the time, ready to read.

---

## SEGMENT 4 — Where do the index numbers come from

So where did I get 236 and 226? From the IODD.

If you remember Lesson 4, the IODD is the XML file that describes everything about a device — what data it publishes, what each byte means, and yes, what the parameter index numbers are. Open the OBD1000 IODD and search for `SignalLevel` — you'll find it at index 236, subindex 1, type unsigned integer, 16 bits. That tells you the response will be a 16-bit unsigned number, so `03E8` decodes to 1000.

The same goes for everything else. Here's a quick reference for the OBD1000:

Process data — `pdin` — gives you the switching state, bit 0.
Index 236, sub 1 — signal level, 0 to 1000.
Index 226, sub 1 — temperature in degrees Celsius.
Index 224, sub 0 — operating hours.
Index 70, sub 0 — SP1, the switching threshold.
Index 192, sub 0 — user tag, a label you can write to the device.

The IODD is the key. Every index, every data type, every scale factor — it's all in there. You look it up once, and then you know exactly what to ask for and how to decode the answer.

---

## SEGMENT 5 — Writing a parameter

Reading is one thing. But the API goes the other way too — you can write parameter values back to the device.

The write address is: `/iolinkmaster/port[1]/iolinkdevice/iolwriteacyclic`.

Same `index` and `subindex`, but now you add a `"value"` field in the `data` object — and it's hex, same as the responses.

Let me change the SP1 switching threshold. That's index 70. I'll set it to 500 — which in hex is `01F4`.

*[send the write request live]*

Code 200 — success. Let me read it back to confirm.

*[send iolreadacyclic for index 70]*

`"value": "01F4"`. 500. It changed. Live. And if you look at the sensor LED now — *[show sensor]* — the switching distance has shifted because we just moved the threshold.

One thing to know: the OBD1000 won't accept an SP1 value above 1000. Pass `03E9` or higher and it'll come back with an error code rather than 200. The IODD specifies the allowed range — always check it.

---

## SEGMENT 6 — How the dashboard does this

Now let me show you something. *[cut to dashboard source code]*

This is `server.ps1` — the PowerShell server that powers the dashboard. And this is the bit that reads the sensor. It's making exactly the same POST call I just made in the terminal. Same URL, same JSON shape, same hex response. The only difference is it's being done in a loop, every second, and the result gets pushed to the browser.

And in `index.html` — when you slide the threshold control, it builds a write request with the new value and sends it. Same `iolwriteacyclic`, same index 70, same hex value. The whole dashboard — every number you see on it — is just these calls, automated.

That's the point. Once you understand three things — the address, the index, and that the value is always hex — you can build whatever you want on top of this. A Python script, a web dashboard, a logging tool, a Node server. It doesn't matter. It's just HTTP.

---

## SEGMENT 7 — One gotcha

Before I wrap up, one thing worth flagging so you don't waste debugging time like I did.

The AL1350 docs mention something called `getdatamulti` — it sounds like a batch read, and in theory it should let you pull multiple values in one call. Don't bother. On this firmware, it returns empty. Every time.

The right approach is individual calls, which is what the dashboard does and what I've shown you here. Not as elegant as a single batch request, but it works reliably. Just don't go adding getdatamulti trying to "optimise" things — it'll silently return nothing and you'll spend an hour wondering what's wrong.

---

## OUTRO / CTA

So — the AL1350 IoT Core API. One endpoint, POST requests, JSON in, hex out. Process data on `pdin/getdata`, parameters on `iolreadacyclic` and `iolwriteacyclic`. Index and subindex from the IODD.

That's genuinely everything you need to start reading and writing IO-Link sensors from any system that can make an HTTP call.

Next up — same thing, but from a **Siemens S7-1200 PLC**. No Profinet, no IO-Link module, no specialist hardware. Just the PLC's built-in HTTP client talking to the master directly. If you want to see that, subscribe — it's the next video.

Cheers.

---

## Production checklist
- [ ] Cold open: terminal ready, `pdin` command pre-typed, sensor in frame.
- [ ] Have all 4 requests ready as copy-paste in the terminal: pdin read, index 236 read, index 226 read, index 70 write + read-back.
- [ ] **Live demos:** hand in front of sensor (pdin flip) · SP1 write → read-back → LED change visible on camera.
- [ ] Screen-record terminal at 1080p+; annotate JSON fields in post (label `code`, `cid`, `adr`, `data`, `value`).
- [ ] Dashboard reveal: side-by-side `server.ps1` lines ↔ raw terminal commands to show they're identical.
- [ ] Capture IODD open in browser/editor — zoom to index 236 definition for the "where do numbers come from" segment.
- [ ] Index cheat-sheet card: build as a full-frame graphic for on-screen display during Segment 4.
- [ ] Confirm getdatamulti still returns empty on current firmware before recording the warning.
