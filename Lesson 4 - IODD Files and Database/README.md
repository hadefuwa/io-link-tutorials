# Lesson 4 — IODD Files and the IODD Database




Plan

- Visit the IODD website
- Find the three devices I have on there
- Download the IODD devices for them
- Show the folders that come with the download
- Open the XML files
- Break down the XML file — it's really just 5 parts:
  - ID card — who made it + what it is (same Vendor/Device ID as the master's web page)
  - Pictures — it just links to image files (that's why it's a folder)
  - The bytes — the process-data map (bit 0 = the switching signal)
  - Settings list — every parameter, by index number
  - The dictionary — the human-readable names ("Signal Level", etc.)

C:\Users\Adefu\OneDrive\Documents\io-link tutorials\docs\OBD1000-R100-2EP-IO-V31

- Break down the XML file — it's really just 5 parts:
  - ID card — <DeviceIdentity>
  - Pictures - <DeviceVariant>
  - The bytes — <DatatypeCollection>
  - Settings list — <VariableCollection>
  - The dictionary — <ExternalTextCollection>


1. ID card — <DeviceIdentity>
Says who made the device and what it is — the same IDs the master reads off it.


<DeviceIdentity vendorId="1"              <!-- who made it: 1 = Pepperl+Fuchs -->
                vendorName="Pepperl+Fuchs"
                deviceId="1114369">       <!-- what it is: 1114369 = 0x110101 -->
  <VendorLogo name="Pepperl-Fuchs-logo.png"/>  <!-- brand logo image file -->
  <DeviceName textId="T_DeviceName"/>          <!-- product name (looked up in the dictionary) -->
</DeviceIdentity>
2. Pictures — <DeviceVariant>
Names the image files (photo + icon) that ship with the XML for each version of the product.


<DeviceVariant productId="267075-100037"              <!-- one specific part number -->
  deviceSymbol="Pepperl-Fuchs-R100_cable-pic.png"     <!-- the device photo -->
  deviceIcon="Pepperl-Fuchs-R100-icon.png">           <!-- the small icon -->
  <Name textId="TN_ProductName_267075-100037"/>       <!-- variant name (in the dictionary) -->
</DeviceVariant>
3. The bytes — <ProcessDataCollection>
Says the input is a single bit, and that bit is a boolean telling you the switching state.


<ProcessDataIn id="PI_PDI8_1B" bitLength="1">   <!-- the input is just 1 bit -->
  <RecordItem subindex="1" bitOffset="0">        <!-- at bit position 0 -->
    <DatatypeRef datatypeId="D_Bool_State"/>     <!-- and it's a boolean (true/false) -->
    <Name textId="TN_pdPDI_SSC"/>                <!-- meaning: the "Switching Signal" -->
  </RecordItem>
</ProcessDataIn>
4. Settings list — <VariableCollection>
Every parameter, each with an index (its address), a data type, and whether you can write to it.


<Variable id="V_SSC_SpSingle"
          index="70"                      <!-- the address you read/write (ISDU index 70) -->
          accessRights="rw"               <!-- rw = you can read AND write it -->
          defaultValue="1000">            <!-- factory default value -->
  <DatatypeRef datatypeId="D_SpSingle"/>  <!-- its type: a 16-bit integer, range 1-1000 -->
  <Name textId="TN_vSSC_SpSingle"/>       <!-- its name (looked up in the dictionary) -->
</Variable>
5. The dictionary — <ExternalTextCollection>
Turns every internal text ID into a human-readable label, per language.


<ExternalTextCollection>
  <PrimaryLanguage xml:lang="en">                                    <!-- English labels -->
    <Text id="TN_vSSC_SpSingle" value="Switching Signal Setpoint"/>  <!-- name for index 70 -->
    <Text id="TN_pdPDI_SSC"     value="Switching Signal"/>           <!-- name for the 1-bit input -->
  </PrimaryLanguage>
</ExternalTextCollection>


























___________________



## Title options
- "IODD Files Explained — the Secret Datasheet Inside Every IO-Link Sensor"
- "IO-Link Practical Course #4: IODD Files & the IODD Finder Database"
- "What Is an IODD File? (And Where to Download Them)"

## Hook
*Last video the master gave us cryptic IDs and raw hex. This is the file that turns that
gibberish into plain English.*

## The one-sentence idea
An **IODD** is the machine-readable datasheet for an IO-Link device — it's how software
knows what a sensor's raw bytes actually *mean* — and there's a free global database of them.

## Why this lesson, right now
- **Answers Lesson 3's cliffhanger:** the web page showed `Vendor ID`, `Device ID` and hex —
  the IODD is what decodes it.
- **Explains Lesson 2's "magic":** it's *how* moneo showed friendly parameter names.
- **Sets up Lessons 5–6:** when we read data over HTTP / from a PLC we get raw bytes, and the
  IODD tells us which byte is temperature and which bit is the switch.

---

## Segment outline

**1 — The problem (callback to Ep. 3).** On the web server we saw Vendor `0001`, Device
`110101`, and process data as hex like `01`. So… how does *anything* know that `01` means
"object detected", or that some number is "temperature in °C"? Nothing on the device is
human-readable. That's the gap the IODD fills.

**2 — What is an IODD?** *IO Device Description.* An XML file, written by the device
manufacturer, that describes everything about the device in a way software can read:
- **Identity** — vendor ID, device ID, product name
- **Process data layout** — which bits/bytes are what
- **Parameters** — every setting, by index / subindex, with its data type and range
- **Text labels** — the human names ("Signal Level", "Switching Signal"), often multi-language
- **Images** — device icons/photos

**3 — The IODD database (IODD Finder).** The IO-Link Community runs a free online database:
**ioddfinder.io-link.com**. Search by manufacturer / product / device ID, download the IODD
(a zip: the XML + images). On camera: read the OBD1000's IDs off the master → find its IODD.

**4 — Crack one open.** Open the actual OBD1000 IODD (we already have it — see Resources).
Walk the structure at a high level so it clicks (don't drown them in XML):
- `DeviceIdentity` → `vendorId=1` (Pepperl+Fuchs), `deviceId=1114369` = `0x110101`
- `ProcessDataIn` → the **1-bit "Switching Signal"** (that's our object-detected bit)
- `Variable index="70"` → the switching set-point · `index="236"` → **"Signal Level"**
- `<Text>` section → this is where names like **"Signal Level"** actually come from
- image files → the device icons

**5 — How tools actually use it (ties the whole course together).**
- moneo (Ep. 2) *loaded this file* → that's why you saw names, not index numbers.
- The web page / IoT Core (Ep. 3) hands you **raw hex** → the IODD gives the byte offsets to decode it.
- So the IODD is the **bridge**: raw IO-Link bytes ⇄ meaningful engineering values.

**6 — Practical recipe + tease.** For *any* IO-Link device: read its Vendor/Device ID off the
master → grab its IODD from the finder → load it into your tool → everything's readable. Next
up: now that we can *decode* the data, we start *pulling it out* ourselves — over HTTP, then
from a PLC.

---

## ⭐ Best demos
1. **Before/after in moneo:** a device with **no IODD** (raw index numbers) vs the same device
   **with the IODD loaded** (friendly names). This is the money shot — it *shows* what an IODD does.
2. **Live download:** read Vendor/Device ID on the web server → search **IODD Finder** → download → open the zip.
3. **Open the XML** in a browser/editor and point at `DeviceIdentity`, the process-data bit, one `Variable`, and the `Text` labels.

## Gear / props
- ifm AL1350 + the connected devices
- PC + browser (for IODD Finder), a text/XML viewer
- moneo (for the before/after demo)

## Resources (already on disk)
- **The OBD1000 IODD + images:** `../docs/OBD1000-R100-2EP-IO-V31/`
  (`Pepperl-Fuchs_OBD1000_R10x-20180815-IODD1.1.xml`)
- **IODD Finder:** https://ioddfinder.io-link.com
- Raw recordings → `recording/`, graphics → `assets/`, downloaded IODDs → `resources/`

## Fact-check before recording
- Confirm the current **IODD Finder** URL/flow on camera (the community site occasionally re-skins).
- Have IODDs handy for the *other* two devices (TP9237, PD30) if you want to show multi-vendor look-ups.

## YouTube description (draft — finalise after recording)
> **IO-Link Practical Course #4 – IODD Files Explained (+ the IODD Database)**
>
> An IO-Link sensor sends raw bytes — so how does your software turn that into "object detected"
> or "temperature: 41°C"? The answer is the IODD: a machine-readable datasheet the manufacturer
> ships for every device. In this video I explain what an IODD is, crack one open, and show you
> the free IODD Finder database where you download them.
>
> 🔧 In this video: what an IODD is · the IODD Finder database · inside a real IODD file (identity,
> process data, parameters, text labels) · how moneo and the master use it to decode raw data.
>
> 👋 https://www.youtube.com/@hamedadefuwa
>
> #IOLink #IODD #IndustrialAutomation #Sensors #ifm
