---
sort: 4
---

# USB Map
In case you changed the SMBIOS you have to edit the plist file inside of ```USBPorts.kext``` to reflect the new SMBIOS. This is easy with ProperTree. Right click on the kext and select ```Show contents``` to get to the plist file inside. It is located at the end of the file right [here](https://github.com/zearp/OptiHack/blob/master/EFI/OC/Kexts/USBPorts.kext/Contents/Info.plist#L147-L148).

## Remapping
You most likely will not have to create a new map. This is only needed if you use the internal headers and go above the 15 port limit. It may also be needed for those who use the repo on related systems like the 9020m.

Mapping USB using the method below only works on Catalina and earlier. You can make a new map in Windows 10 using [this](https://github.com/USBToolBox/tool) tool if you don't have, and don't want to install, Catalina. The tool can create 2 kexts, one requires a companion kext and one works stand alone. Use the latter as we don't need the fixes the companion kext has. You can toggle this inside the tools settings.

If you're on Catalina or have less than 15 ports to map you can follow these steps to make a new map. If you're on Big Sur or newer don't enable the quirk.

1. Open your OpenCore config and set ```Kernel -> Add -> 5 -> USBPorts.kext``` to *disabled* and *enable* ```Kernel -> Quirks -> XhciPortLimit```.
2. Reboot.
3. Open Hackintool and go to the USB tab, select all ports listed and remove them, then click the refresh button.
4. Plug a USB 2 device in every USB port.
5. Plug a USB 3 device in every USB port.
6. Remove anything not green, you should be left with 14 green ports (15 with internal USB port).
7. Make sure all the HSxx ports are set to USB 2 and SSxx ports are set to USB 3 (if you're mapping the internal port make sure it's set to internal).
8. Click on the export button and place the resulting USBPorts.kext in the OpenCore kexts folder (overwriting the existing one).
9. Open your OpenCore config and set ```Kernel -> Add -> 5 -> USBPorts.kext``` to *enabled* and *disable* ```Kernel -> Quirks -> XhciPortLimit```.
10. Reboot.

Verify the ports in Hackintool, go to the USB tab again, select all ports and delete them and click refresh again. It should now look like [this](https://github.com/zearp/OptiHack/blob/master/images/usb-portmap.png?raw=true), 14 or 15 ports showing all with the correct USB 2 or USB 3 labels. And HS13 showing as internal for those who have it. If you use a Bluetooth dongle make sure the port it connects to is also set to internal.

Please don't use hubs to map the ports, they've produced some bad portmaps in my testing as they can take up multiple ports at once. Use simple (non data carrying) USB 2 and USB 3 devices like dongles/receivers/Wi-Fi/etc to be fast and safe.

If you have more than 15 ports you can disable some ports by deleting them from the list before exporting your map. You could disable 2 ports on the back if you use internal headers.

In some cases when connecting iDevices they will get stuck in a connect/disconnect loop. I'm not 100% sure what caused this but it should be fixed with the default portmap. If you run into problems after making your own let me know by opening an issue. We will hopefully sort it out. Also try different cables, I noticed that some of my older original Lightning cables didn't work properly but others did. This was/is a strange issue relating to the portmap I think.
