# IODD XML breakdown — filming cheat-sheet

File: `docs/OBD1000-R100-2EP-IO-V31/Pepperl-Fuchs_OBD1000_R10x-20180815-IODD1.1.xml` (1,250 lines)

**Frame it as 5 plain-English parts, not "XML".** Open the file in a **web browser** (Chrome/Edge)
so it shows as a collapsible tree; collapse all, then reveal each part as you talk. Zoom in for 1080p.

---

## Part 1 — The ID card  ·  `<DeviceIdentity>` (line 18)
> "Every IODD starts by saying who made the device and what it is."
- `vendorId="1"` = Pepperl+Fuchs · `deviceId="1114369"`
- **⭐ Cross-reference:** these are the SAME numbers the master's web page showed last episode
  (Vendor `0001`, Device `110101`). Put them side by side on screen.

## Part 2 — The pictures  ·  `VendorLogo` / `deviceSymbol` / `deviceIcon` (lines 21–76)
> "Notice it doesn't contain any images — it just names them."
- `VendorLogo name="Pepperl-Fuchs-logo.png"`, plus a `deviceSymbol`/`deviceIcon` per variant.
- **Demo:** open the download folder beside it → there are those exact PNGs. *That's why an IODD
  is a folder/zip, not a single file.*

## Part 3 — The live-data map ("the bytes")  ·  `<ProcessDataCollection>` (line 589)
> "This is the bit that decodes the raw hex from the master."
- `ProcessDataIn` = **1 bit**, and **bit 0 = "Switching Signal"** (our object-detected bit).
- `ProcessDataOut` = 2 bits (CSC1 / CSC2).
- **⭐ Demo:** flip to the master reading `pdin = 01` → this is how `01` becomes "object detected".

## Part 4 — The settings list  ·  `<VariableCollection>` (line 180)
> "Every parameter the device has — each with an index number."
- e.g. `Variable index="70"` = switching set-point · `index="236"` = signal level.
- Each has: an **index**, a **data type**, **read/write** rights, and a **name** (a `textId`).
- `<DatatypeCollection>` (line 91) above it just defines reusable types the variables point to
  (e.g. "a set-point is a 16-bit integer, range 1–1000").

## Part 5 — The dictionary  ·  `<ExternalTextCollection>` (line 1016)
> "And THIS is where the human names live."
- `<PrimaryLanguage xml:lang="en">` full of `<Text id="…" value="…"/>` pairs.
- "Signal Level", "Switching Signal Setpoint", etc. Multi-language support lives here too.
- **⭐ The killer move:** copy a `textId` from a Variable (Part 4) → find that same id here →
  that's how "index 70" becomes a friendly label. Decoding, proven on screen.

---

## Skip / mention briefly
- `<DocumentInfo>` (line 3) + `<ProfileHeader>` (line 4) — boilerplate ("this is an IODD 1.1 file").
- `<EventCollection>` (line 647) — diagnostic events/warnings the device can raise.
- `<UserInterface>` (line 678) — how a tool should lay the parameters out in menus (units, scaling).
- `<Stamp>` (line 1249) — a checksum + which IODD-Checker validated the file.

## The one-line takeaway for viewers
> Identity + a byte-map + a list of settings + a dictionary of names — stitch them together and
> raw IO-Link bytes turn into "object detected" and "Signal Level". That's all an IODD is.

## How to display it on camera
- **Browser tree view** (recommended): open the `.xml` in Chrome/Edge → collapsible, colour-coded.
- **VS Code:** Fold All = `Ctrl+K Ctrl+0`; expand section by section; use the Outline panel.
- **Notepad++** + XML Tools plugin also works.
- Zoom/increase font so it's readable at 1080p; pre-collapse to the top level before you start.
