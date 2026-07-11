# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This repo supports a YouTube tutorial series (Hamed Adefuwa, @hamedadefuwa) teaching **IO-Link** (IEC 61131-9), the point-to-point protocol for connecting industrial sensors/actuators to automation systems. It is two things:

1. **Documentation/reference** — `README.md`, plus the sensor's IODD, datasheet, and images under `docs/`.
2. **A working demo app** — `io-link-dashboard/`, a live browser dashboard that reads/writes a real sensor through an ifm master.

There is no formal build/test system. "Running" means launching the dashboard (below); doc work means editing Markdown and keeping it consistent with the fixed bench setup.

## Layout

- `README.md` — hardware specs, wiring pinouts, tutorial episode plan, glossary, quick-start.
- `docs/OBD1000-R100-2EP-IO-V31/` — the **IODD XML** (`Pepperl-Fuchs_OBD1000_R10x-20180815-IODD1.1.xml`), the vendor datasheet (PDF + extracted `.txt`), and device/connector images. Treat the IODD as **read-only vendor reference**; keep image filenames it references (`VendorLogo`, `deviceSymbol`, `deviceIcon`) in sync with the `.png`s beside it.
- `io-link-dashboard/` — the demo app (see below).

## The fixed bench setup (keep consistent everywhere)

- **Master:** ifm AL1350 — 4-port Class A IO-Link master with IoT Core (HTTP/JSON). Its IoT port is at **`192.168.7.4`** on a dedicated segment; a PC reaches it via a static secondary IP `192.168.7.10/24` on the same NIC as its normal LAN address.
- **Device:** Pepperl+Fuchs **OBD1000-R100-2EP-IO-V31** diffuse photoelectric sensor on **port X01** (`port[1]`). Device ID `1114369` = `0x110101`, IO-Link 1.1, COM2.

## The dashboard app (`io-link-dashboard/`)

Zero-install: **Windows PowerShell + a browser only** (no Node, no admin). `start.bat` → `server.ps1` opens a loopback `TcpListener` web server (auto-picks a free port from 8088) that (a) serves `index.html` and (b) proxies the browser's JSON to the AL1350 IoT Core. Keeping the master IP server-side avoids CORS. Config (master IP/port/listen port) is in `config.json`, editable live in the UI.

Files: `server.ps1` (server+proxy), `index.html` (single-file UI, all logic inline), `config.json`, `start.bat` (launcher), `test-connection.ps1` (CLI probe, no browser), `README.txt`.

### AL1350 IoT Core protocol (what the app speaks)

POST JSON to `http://<ip>/`: `{"code":"request","cid":N,"adr":"<address>","data":{...}}` → `{"cid":N,"data":{"value":"<hex>"},"code":200}`.
- Cyclic process data: `adr` = `/iolinkmaster/port[1]/iolinkdevice/pdin/getdata` (etc.).
- Acyclic parameters (ISDU): `adr` = `.../iolreadacyclic` or `.../iolwriteacyclic`, `data` = `{index, subindex, value?}`. `value` is hex.

### Non-obvious things that cost real debugging time

- **`/getdatamulti` returns empty on this firmware.** Read parameters with **individual `getdata`/`iolreadacyclic` calls**, not batched. Do not "optimize" back to getdatamulti.
- **PowerShell 5.1 `Get-Content` misreads UTF-8** (defaults to ANSI). `server.ps1` serves `index.html` via `[IO.File]::ReadAllText(path, UTF8)` — keep it that way or typographic chars (—, ·) turn to mojibake.
- **"Signal Level" (ISDU index 236, sub 1) is signal STRENGTH, not distance.** It *rises* as the target gets closer/more reflective. The `mm` detection range is a separate read-only field (index 232). Don't relabel Signal Level as distance.
- **SP1 (index 70) is the switching THRESHOLD on the signal level, range 1–1000, not millimetres.** Higher SP1 = shorter sensing distance. The device rejects values >1000.
- **PDout (CSC1/CSC2) is not served by this master port** (read returns error 530). The UI shows it as "not available" by design.
- Key ISDU indices used: 236 signal level+quality, 226 temps, 224 operating hours, 225 temp status, 232 detection range (mm), 70 SP1 threshold, 71 logic (0=light-on/NO, 1=dark-on/NC), 192 user tag, 37 detailed status. All decoding follows the OBD1000 IODD (byte offsets from the `<RecordItem bitOffset>` fields).

## Conventions

- README uses GitHub-flavored tables and ASCII box-drawing for wiring — match that style; follow the numbered episode plan rather than inventing structure.
- `index.html` is intentionally a single self-contained file (inline CSS/JS, inline SVG for the @hamedadefuwa YouTube branding) so it can be copied and run anywhere with no assets.
