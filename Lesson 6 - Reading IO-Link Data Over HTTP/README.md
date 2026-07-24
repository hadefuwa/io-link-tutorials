# Lesson 6 — Reading IO-Link Data Over HTTP (AL1350 IoT Core API)

**Status:** 🔵 Planned · **Length:** ~12–15 min · Channel: [@hamedadefuwa](https://www.youtube.com/@hamedadefuwa)
**Master IP:** `192.168.7.4` · **Sensor:** OBD1000 on port X01

## Title options
- "Reading IO-Link Sensors with Just HTTP — No PLC, No Software"
- "IO-Link Practical Course #6: Pull Sensor Data with a Single HTTP Call"
- "The IO-Link API Nobody Talks About (AL1350 IoT Core)"

## Hook
*Three lines of PowerShell. That's all it takes to read a live sensor value out of an IO-Link master — no PLC, no SCADA, no driver. Let me show you.*

## The one-sentence idea
The AL1350's IoT Core is a simple HTTP/JSON API: POST one request, get sensor data back as hex — and once you know the address structure, you can read anything the device publishes.

---

## Script / segment outline (with rough timings)

**0:00 — Cold open.** Terminal on screen. Type one PowerShell command live. A hex value comes back.
"That's the switching state of my sensor. Live. Right now. And I didn't install anything."

**0:40 — Recap / context.** Brief callback: Lesson 3 showed the master's web page — we saw it was "just a view of an API underneath it." This episode is that API. We're going to pull the data ourselves, understand the format, and decode it.

**2:00 — The API in one sentence.** The AL1350 IoT Core accepts a single HTTP POST to `http://192.168.7.4/`.
Body is always the same shape:
```json
{
  "code": "request",
  "cid": 1,
  "adr": "<address>",
  "data": {}
}
```
The master replies:
```json
{
  "cid": 1,
  "data": { "value": "<hex>" },
  "code": 200
}
```
That's it. One endpoint, one verb, one format. The only thing that changes is `adr`.

**4:00 — Reading PROCESS DATA (cyclic).** Process data = the live output the sensor sends every cycle (~4 ms).
- Address: `/iolinkmaster/port[1]/iolinkdevice/pdin/getdata`
- Show the raw response: `"value": "01"` (1 byte). That single byte IS the sensor output.
- Decode: the OBD1000 puts its switching state in **bit 0** of byte 0. `0x01` = object detected. `0x00` = clear.
- Live demo: wave hand in front of sensor — value flips between `01` and `00` in the terminal.

**6:30 — Reading PARAMETERS (acyclic).** Parameters = everything else — signal level, temperature, serial number, thresholds. These aren't broadcast continuously; you have to ask for them.
- Address: `/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic`
- Extra fields needed in `data`: `{"index": 236, "subindex": 1}` → signal level (strength)
- Response: `"value": "03E8"` → hex `0x03E8` = 1000 decimal. Signal level scale is 0–1000.
- Second read: `{"index": 226, "subindex": 1}` → temperature. Response: `"value": "0019"` = 25 °C.
- Explain index/subindex = the IODD "address book" for every parameter. (IODD lesson recap.)

**9:00 — Where do index numbers come from?** Quick IODD callback: the IODD XML lists every readable/writable parameter with its index and subindex. Open the OBD1000 IODD, find index 236 — it says `SignalLevel`, type `UIntegerT`, size 16 bits. That's how you know `03E8` is a 16-bit unsigned int = 1000.

Key indices cheat-sheet on screen:
| Index | Sub | What you get |
|-------|-----|--------------|
| pdin  | —   | Process data (switching state) |
| 236   | 1   | Signal level (0–1000, higher = stronger) |
| 226   | 1   | Temperature (°C) |
| 224   | 0   | Operating hours |
| 70    | 0   | SP1 switching threshold |
| 192   | 0   | User tag (device label string) |

**10:30 — WRITING a parameter.** It goes the other way too. Change SP1 (index 70) live on camera:
- Address: `/iolinkmaster/port[1]/iolinkdevice/iolwriteacyclic`
- `"data": {"index": 70, "subindex": 0, "value": "01F4"}` → sets SP1 to 500
- Read it back to confirm it changed.
- ⚠️ Note: max value is 1000 (`03E8`). The device rejects values above that with an error response.

**12:00 — How the dashboard uses this.** Cut to the dashboard (`io-link-dashboard/`):
- `server.ps1` is just making these exact same POST calls — show the relevant lines side-by-side with the raw terminal commands.
- `index.html` fires them via `fetch()` from the browser; the PowerShell server proxies them to the master (solves CORS).
- The "signal level" bar in the dashboard = the 0–1000 value from index 236, scaled to a percentage.
- It's the same 3 fields: the address, the index, the hex value. Once you know those, you can build anything.

**13:30 — One gotcha to know.** `getdatamulti` — it looks like a batch read and the docs mention it, but **this firmware returns empty on the AL1350**. Always use individual calls. (The dashboard does this already; just flagging it so you don't waste debugging time.)

**14:30 — Outro / tease.** "So now you can read and write any IO-Link sensor, from any PC on the network, with plain HTTP. No driver, no OPC UA, no SCADA licence.
Next video — same thing, but from a **Siemens S7-1200 PLC**. No Profinet, no special IO-Link module. Just the PLC's built-in HTTP client talking directly to the master. I'll see you there."

---

## ⭐ Best live demos (do these on camera)

1. **Single PowerShell command → hex response** — the "wow" moment. Do this first before explaining anything.
2. **Wave hand → pdin value flips** — proves it's live process data, not cached.
3. **Write SP1 → read it back changed** — proves it's bidirectional.
4. **Show dashboard source** — side-by-side `server.ps1` calls vs raw terminal: "it's the same thing."

## Gear / props
- ifm AL1350 at `192.168.7.4`
- Pepperl+Fuchs OBD1000 on port X01
- PC with PowerShell + a browser (for the dashboard reveal)

## Graphics / B-roll ideas
- Annotated JSON request/response diagram (label each field: `code`, `cid`, `adr`, `data`, `value`)
- "Cyclic vs Acyclic" split graphic — process data left, parameters right
- Index/subindex cheat-sheet table (see above) as a lower-third or full-frame card
- Side-by-side: raw PowerShell output ↔ dashboard UI showing the same value

## Lower-third callouts
- `"adr" = the sensor's address on the master`
- `pdin = live process data · iolreadacyclic = parameters`
- `"value" is always hex`
- `index + subindex = parameter address from the IODD`

## PowerShell snippets (include in resources/)
```powershell
# Read process data (switching state)
$body = '{"code":"request","cid":1,"adr":"/iolinkmaster/port[1]/iolinkdevice/pdin/getdata","data":{}}'
(Invoke-WebRequest -Uri "http://192.168.7.4/" -Method POST -Body $body -ContentType "application/json").Content

# Read signal level (ISDU index 236, sub 1)
$body = '{"code":"request","cid":2,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":236,"subindex":1}}'
(Invoke-WebRequest -Uri "http://192.168.7.4/" -Method POST -Body $body -ContentType "application/json").Content

# Read temperature (ISDU index 226, sub 1)
$body = '{"code":"request","cid":3,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolreadacyclic","data":{"index":226,"subindex":1}}'
(Invoke-WebRequest -Uri "http://192.168.7.4/" -Method POST -Body $body -ContentType "application/json").Content

# Write SP1 threshold (ISDU index 70, sub 0) — value 500 = 0x01F4
$body = '{"code":"request","cid":4,"adr":"/iolinkmaster/port[1]/iolinkdevice/iolwriteacyclic","data":{"index":70,"subindex":0,"value":"01F4"}}'
(Invoke-WebRequest -Uri "http://192.168.7.4/" -Method POST -Body $body -ContentType "application/json").Content
```

## Fact-check before recording
- Confirm `pdin` returns `01`/`00` for detected/clear on the OBD1000 (process data bit layout matches IODD)
- Confirm index 236 sub 1 = signal level, index 226 sub 1 = temperature on live hardware
- Confirm max SP1 value is 1000 (IODD-specified); test that 1001 returns an error response
- Confirm `getdatamulti` still returns empty on current firmware (v3.1.97) before warning viewers

## Resources
- IODD reference: `../docs/OBD1000-R100-2EP-IO-V31/`
- Dashboard source (working example): `../io-link-dashboard/server.ps1` and `index.html`
- Protocol details: `../CLAUDE.md` — "AL1350 IoT Core protocol" section
- PowerShell snippets: `resources/api-snippets.ps1` (create alongside this lesson)

## YouTube description (draft — finalise after recording)
> **IO-Link Practical Course #6 – Reading Sensors with Just HTTP**
>
> The ifm AL1350 has a simple HTTP/JSON API — and once you know it, you can read or write any
> IO-Link sensor from a terminal, a Python script, a Node server, a browser, or a PLC. In this
> video I show you the whole thing from scratch: process data, acyclic parameters, and how to
> write values back — all with plain PowerShell, no drivers needed.
>
> 🔧 In this video: the IoT Core API format (one endpoint, one verb) · reading process data
> (switching state, live) · reading parameters with index/subindex (signal level, temperature) ·
> writing parameters live on camera · how the dashboard app uses these same calls · one gotcha
> (getdatamulti) to avoid.
>
> 🛠️ Hardware: ifm AL1350 · Pepperl+Fuchs OBD1000
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #IndustrialAutomation #ifm #IoT #Sensors #Industry40 #PowerShell #HTTP #API
