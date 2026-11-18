<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="images/logo-dark.svg">
  <source media="(prefers-color-scheme: light)" srcset="images/logo-light.svg">
  <img alt="OptiHack" src="images/logo-light.svg" width="360">
</picture>

**An OpenCore EFI and guide for running macOS on the Dell OptiPlex 7020 / 9020.**

[![Latest release](https://img.shields.io/github/v/release/zearp/OptiHack?label=EFI&color=2ea44f)](https://github.com/zearp/OptiHack/releases/latest)
[![OpenCore](https://img.shields.io/badge/OpenCore-1.0.9-blue)](https://github.com/acidanthera/OpenCorePkg)
[![macOS](https://img.shields.io/badge/macOS-Catalina%20%E2%86%92%20Monterey-lightgrey?logo=apple)](#macos-versions)
[![Docs](https://img.shields.io/badge/docs-read%20the%20guide-8a63d2)](https://zearp.github.io/OptiHack/)

### 📖 [Read the guide → zearp.github.io/OptiHack](https://zearp.github.io/OptiHack/)
</div>

## What is this?

OptiHack is a ready-to-use [OpenCore](https://github.com/acidanthera/OpenCorePkg) EFI for Dell OptiPlex 7020 and 9020 desktops (Intel Haswell, HD 4600 graphics), plus a step-by-step guide that walks you from an empty USB stick to a working, iCloud-ready macOS install.

It follows the [Dortania](https://dortania.github.io/OpenCore-Install-Guide/) vanilla approach: a minimal set of kexts, a custom USB map and audio layout for this machine, and no unnecessary patches. Made for fun and my own edutainment, shared in case it helps you too.

## Project status

> [!NOTE]
> **Maintenance mode.** macOS Monterey is the last version that natively supports Haswell, and this EFI runs it very stably. The repo still gets occasional updates for OpenCore and kexts (most recently November 2026), but newer macOS versions are not supported or tested.

Newer macOS versions can be forced onto Haswell with [OpenCore Legacy Patcher](https://github.com/dortania/OpenCore-Legacy-Patcher), but I don't recommend it while Monterey still gets security updates. Doing it right takes a lot of testing (comparing frequencies, voltages and iGPU behaviour across SMBIOS models), and many newer features depend on CPU instructions Haswell doesn't have anyway.

<details>
<summary>Past announcements</summary>

- **February 2024:** Monterey is the final native macOS for Haswell and its security updates are unlikely to break the EFI, so the repo moved to maintenance mode. It may still get the occasional surprise update.
- **August 2023:** Monterey confirmed as the last macOS with native Haswell support. OCLP is possible but not recommended while Monterey is supported.
- **July 2022:** No testing during the Ventura beta; testing would only start once a final release was out.
- **June 2021:** Default SMBIOS changed to `Macmini7,1` to allow installing Monterey. See [Updating from an older EFI](#updating-from-an-older-efi).

</details>

## Quick start

1. **Download** the latest EFI from [Releases](https://github.com/zearp/OptiHack/releases/latest).
2. **Follow the [installation guide](https://zearp.github.io/OptiHack/OptiGuide/installation.html)** to make a USB installer, add your serials and pick your options.
3. **Finish with the post-install steps** in the guide: serials, USB map, iCloud.

> [!IMPORTANT]
> The guide assumes macOS will be the only OS and that the target disk can be wiped. Disconnect any Windows or Linux disks during installation, then reconnect them afterwards and pick the OS from the BIOS boot menu (F12).

## What works

| | Feature | Notes |
|---|---|---|
| ✅ | **Intel HD 4600 graphics** | Full acceleration via WhateverGreen. DisplayPort to DisplayPort is the most reliable connection. |
| ✅ | **Audio** | AppleALC with a custom layout (`17`) made for the 7020/9020. Layout `15` auto-switches to headphones. |
| ✅ | **Ethernet** | Intel I217-LM via IntelMausi. |
| ✅ | **USB** | Custom port map with USB 3 speeds on the supported ports. |
| ✅ | **Sleep and wake** | Works; USB hubs and some adapters can cause instant wake. |
| ✅ | **Power management and sensors** | Native CPU power management; temperatures and fans via VirtualSMC and SMCDellSensors. |
| ✅ | **iCloud, iMessage, FaceTime** | Works once you generate your own serials (covered in the guide). |
| ✅ | **FileVault, Time Machine, bootable clones** | All supported. |

## What doesn't (or needs work)

| | Feature | Notes |
|---|---|---|
| ⚠️ | **Wi-Fi and Bluetooth** | No built-in support. Needs a [macOS-compatible card](https://dortania.github.io/Wireless-Buyers-Guide/), usually Broadcom, or a USB dongle. |
| ⚠️ | **Dedicated GPUs** | Disabled by default. Compatible cards can be enabled; see the [dGPU page](https://zearp.github.io/OptiHack/OptiGuide/dgpu.html). |
| ⚠️ | **Audio over DisplayPort/HDMI** | Off by default; enabling it can break screen hot-plugging. |
| ⚠️ | **4K at 60 Hz** | Reliable up to Catalina; hit-or-miss on Big Sur and Monterey. |
| ⚠️ | **Dual screens over DP → HDMI** | Two converted outputs at once don't work; mix in a native DP connection. |
| ❌ | **Sidecar** | Glitchy; likely limited by Haswell itself. |
| ⚠️ | **DRM streaming** (e.g. Apple TV+, Netflix in Safari) | Needs extra boot flags; depends on macOS version and GPU. Best on Catalina. See [DRM](https://zearp.github.io/OptiHack/OptiGuide/dgpu.html#drm). |
| ❌ | **macOS Ventura and later** | Not supported (see [Project status](#project-status)). |

More fixes and workarounds are in [Troubleshooting](https://zearp.github.io/OptiHack/OptiGuide/troubleshooting.html).

## macOS versions

Which SMBIOS you choose decides the newest macOS you can install, and which upgrade prompts you'll see:

| SMBIOS | Newest macOS | |
|---|---|---|
| `Macmini7,1` | Monterey | Default |
| `iMac15,1` | Big Sur | No Monterey upgrade prompts |
| `iMac14,3` | Catalina | No Big Sur upgrade prompts |

Functionally they're the same. Changing SMBIOS also means editing the USB map; see [SMBIOS](https://zearp.github.io/OptiHack/OptiGuide/smbios.html).

## Updating from an older EFI

Copy your serials (MLB, ROM, etc.) somewhere safe, swap in the new `EFI` folder and paste them back. The [updating page](https://zearp.github.io/OptiHack/OptiGuide/updating.html) has the details.

> [!WARNING]
> **Coming from an EFI older than June 2021?** The default SMBIOS changed from `iMac15,1` to `Macmini7,1`. Either sign out of iMessage, FaceTime and iCloud and generate new serials for `Macmini7,1`, or set the SMBIOS back to your old model and edit the plist inside `USBPorts.kext` to match.

## What's in this repo

| Path | Contents |
|---|---|
| [`EFI/`](EFI) | The OpenCore EFI folder (also available as a zip on [Releases](https://github.com/zearp/OptiHack/releases)). |
| [`docs/`](docs) | Source of the [guide website](https://zearp.github.io/OptiHack/), built with VitePress. |
| [`text/`](text) | Extra notes (BIOS, CFG Lock, fans, audio codecs, ACPI) and Dell/Intel reference manuals. |
| [`images/`](images) | Screenshots and diagrams used in the guide. |

## Credits

Built on the work of the [Acidanthera](https://github.com/acidanthera) team (OpenCore, Lilu, WhateverGreen, AppleALC, VirtualSMC), [Dortania](https://dortania.github.io/), [headkaze](https://github.com/headkaze) (Hackintool, EFI Agent), [corpnewt](https://github.com/corpnewt) (ProperTree, GenSMBIOS) and many others. See the [full credits](https://zearp.github.io/OptiHack/OptiGuide/credits.html).
