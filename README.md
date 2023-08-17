# OptiHack
Dell OptiPlex 7020/9020 hackintosh stuff.

![Montedell](/images/Monterey.png?raw=true)

# New guide can be found [here](https://zearp.github.io/OptiHack/).

## August 2023 PSA: Monterey is the last macOS that natively supprots the Haswell platform. While it is possinle to run newer versions for now I would not recommended doing so. 

Monterey will continue to receive updates and security updates for a while and running macOS on a hardware platform it doesn't natively support requires a lot of testing to do it right. Comparing frequencies and voltages with Monterey when testing different SMBIOS is a must and only the start. I currently don't have time or need for it since Monterey is perfectly fine. Also many new macOS features will simply not work because their requite instructions Haswell processors lack. This is already the case with things like SideCar that only work glitchy. I will do some experimentation at some point and see how stable and well it runs. Specially when it comes to the iGPU.

## July 2022 PSA: While Venture is in beta I will not be doing any testing this time. The last time a lot of things kept changing and it took a few weeks before all the needed kexts and OpenCore were working properly with Monterey. I will begin my Ventura testing when the GM is announced or released. This project is not dead yet.

## PSA: From the 24th of June 2021 the default SMBIOS has been changed. This means that when you update you will either have generate new serials and before doing so logout from the iMessage and Facetime apps as well as iCloud itself. Or you can of course change the SMBIOS back to iMac15,1 or iMac14,3, if you do so you'll also need edit the plist inside USBPorts.kext to match the new model. This change is done so we can install Monterey.
