# BIOS Stuff
What can we do?
* [Extract current BIOS](#extracting)
* [Update the microcodes, this is the most important modification to make](#modifying)
* [Update RST firmware, this is responsible for SATA/RAID](#rst)
* [Update iGPU VBIOS](#igpulan)
* [Add KVM/AMT to the SPI region, enables vPro stuff like remote desktop even if system is off](#kvmamtspi)
* [Modify Dell boot logo, replace it with a fruity pineapple if you're so inclined](#bios-logo)
* Modify DSDT tables, in theory we could add all our ACPI patches needed for macOS to the BIOS itself
* Add NVMe support to the BIOS, it is possible!
* [Flashing](#flashing)
* [Verify](#verify)
* [Windows 10 Live](#windows-for-those-that-dont-want-it)
* [Recovery](#recovery)
* [Unlocking](#unlocking)

## Things to download
* Windows 10, see below for a guide for those who have left Windows behind long ago
* UBU
* Intel ME Platform Tools 9.1
* Intel firmware files
* Intel BMP
* MMTool

All those we need can be found the first post of [this](https://www.win-raid.com/t154f16-Tool-Guide-News-quot-UEFI-BIOS-Updater-quot-UBU.html) thread. Search for ```SoniX's MEGA link``` in there and open it up.
The things you need to download from the Mega repo are:
* UBU_v1_xxxxx.rar
* Tools -> mmt.rar
* Files_xxxxx -> Intel GOP/RST/VBIOS .7z files
* BMPv2_xxPV_External.zip

We also need Intel ME System Tools 9.1, a download link can be found [here](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html), search for ```9.1 r7```.

Install Intel BMP and unpack the ME System Tools to C:\.

## Extracting

Intel for some reason doesn't make their ME System Tools public, but now that we have a copy we can unpack it and start using some of the tools. First lets check the versions.

Open a new PowerShell as admin and go to the MEInfo\WIN64 folder and run ```.\MEInfoWin64.exe```:

```
PS C:\Intel ME System Tools v9.1 r7\MEInfo\WIN64> .\MEInfoWin64.exe

Intel(R) MEInfo Version: 9.1.45.3000
Copyright(C) 2005 - 2017, Intel Corporation. All rights reserved.

Intel(R) ME code versions:

BIOS Version:                           A18
MEBx Version:                           9.0.0.0029
Gbe Version:                            1.3
VendorID:                               8086
PCH Version:                            4
FW Version:                             9.1.45.3000 H
LMS Version:                            Not Available
MEI Driver Version:                     11.7.0.1032
```

I removed the rest as its not important for this check. Simply make sure your MEBx is at version 9.0.x and the firmware is on 9.1.x. If you're on the latest Dell BIOS these should match up.

We can only upgrade MEBx and the firmware within its major release. This means that we have to stay on 9.0.x for MEBx and 9.1.x for firmware related things. This is no problem and we're not touching those.

Now lets extract the current BIOS, don't use any other tools do this, we can't just extract the .rom file from the Dell BIOS executable.

Navigate to the ```Flash Programming Tool\WIN64``` folder and execute ```.\fptw64.exe -bios -d bios_backup.bin```:

```
PS C:\Intel ME System Tools v9.1 r7\Flash Programming Tool\WIN64> .\fptw64.exe -bios -d bios_backup.bin

Intel (R) Flash Programming Tool. Version:  9.1.10.1000
Copyright (c) 2007 - 2014, Intel Corporation. All rights reserved.

Platform: Intel(R) Q87 Express Chipset
Reading HSFSTS register... Flash Descriptor: Valid

    --- Flash Devices Found ---
    MX25L6405D    ID:0xC22017    Size: 8192KB (65536Kb)
    MX25L3205A    ID:0xC22016    Size: 4096KB (32768Kb)


- Reading Flash [0xC00000] 6144KB of 6144KB - 100% complete.
Writing flash contents to file "bios_backup.bin"...

Memory Dump Complete
FPT Operation Passed
```

We now have a backup of the BIOS and the file we need to apply our modifications to. We can move on to the next section.

## Modifying
Extract UBU somewhere simple. I picked C:\UBU. Now you'll need to find a copy of MMTool. We downloaded a file called mmt.rar, extract it and you'll find a bunch of versions of the MMTool utility. I used v4.50.0.23 and renamed it to ```mmtool_a4.exe``` and placed in the UBU root folder. At this point also copy your extracted BIOS to this folder and rename it to ```bios.bin```.

First we will apply microcode patches. These fix processor related bugs and security issues. It is a must to keep these up to date, don't expect much from Dell at this point.

Still in the UBU root folder right click ```UBU.bat``` and run it as admin. It will find the extracted bios and starts to analyse it and taking it apart. Let it do its thing, when its done press any key to continue and you'll be presented with a menu (the file not found message can be ignored).

Next enter ```5``` to enter the microcode section. It will print a table showing the current versions and if there are any updates for it. On mine it looked like this:

```
╔═════════════════════════════════════════╗
║        MC Extractor v1.42.0 r140        ║
╚═════════════════════════════════════════╝
╔═════════════════════════════════════════════════════════════════╗
║                              Intel                              ║
╟─┬─────┬───────────┬────────┬──────────┬────┬──────┬────────┬────╢
║#│CPUID│Platform ID│Revision│   Date   │Type│ Size │ Offset │Last║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼────────┼────╢
║1│40661│ 32 (1,4,5)│   1B   │2019-02-26│PRD │0x6400│0x3CB150│ No ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼────────┼────╢
║2│40660│ 32 (1,4,5)│FFFF0011│2012-10-12│PRE │0x6400│0x3D1950│Yes ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼────────┼────╢
║3│306C3│ 32 (1,4,5)│   27   │2019-02-26│PRD │0x5C00│0x3D8150│ No ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼────────┼────╢
║4│306C2│ 32 (1,4,5)│FFFF0006│2012-10-17│PRE │0x5800│0x3DE150│Yes ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼────────┼────╢
║5│306C1│ 32 (1,4,5)│FFFF0013│2012-06-14│PRE │0x6000│0x3E3950│ No ║
╚═╧═════╧═══════════╧════════╧══════════╧════╧══════╧════════╧════╝
```

We'll end up in another menu, all we want to enter here is ```F```. It will find and replace anything that can be updated, like this:

> Note: The values and number of updates for your machine could be different, on mine it also cleared out 2 entries. It won't remove anything that could prevent booting up. And you can always flash back your backup, or download the BIOS from Dell and flash the BIOS with that. If you change the CPU you may need to re-run the above but I'm not certain about that.

```
Choice:F
CPUID 306C3 found.
Files\Intel\mcode\1150\cpu306C3_plat32_ver00000028_2019-11-12_PRD_DBD4CFD1.bin
Checksum correct.
CPUID 306C2 found.
Files\Intel\mcode\1150\cpu306C2_plat32_verFFFF0006_2012-10-17_PRE_30531EB4.bin
Checksum correct.
CPUID 306C1 found.
Files\Intel\mcode\1150\cpu306C1_plat32_verFFFF0014_2012-07-25_PRE_E86E3EB1.bin
Checksum correct.
Generate FFS with Microcode

╔═════════════════════════════════════════╗
║        MC Extractor v1.42.0 r140        ║
╚═════════════════════════════════════════╝
╔═══════════════════════════════════════════════════════════════╗
║                             Intel                             ║
╟─┬─────┬───────────┬────────┬──────────┬────┬──────┬──────┬────╢
║#│CPUID│Platform ID│Revision│   Date   │Type│ Size │Offset│Last║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼──────┼────╢
║1│306C3│ 32 (1,4,5)│   28   │2019-11-12│PRD │0x5C00│ 0x18 │Yes ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼──────┼────╢
║2│306C2│ 32 (1,4,5)│FFFF0006│2012-10-17│PRE │0x5800│0x5C18│Yes ║
╟─┼─────┼───────────┼────────┼──────────┼────┼──────┼──────┼────╢
║3│306C1│ 32 (1,4,5)│FFFF0014│2012-07-25│PRE │0x6000│0xB418│Yes ║
╚═╧═════╧═══════════╧════════╧══════════╧════╧══════╧══════╧════╝
        These microcodes will be entered into your BIOS file

R - Start replacement
0 - Cancel
Choice:
```

Now we enter ```R``` to replace the old microcodes with the new ones in the BIOS file.

```
Choice:R
        [Preparing for replacement]
BIOS file backup
        [Replacement]
mCode FFS: File replaced
                       Real    Pointer
    _FIT_ Offset - FFA90740 == FFA90740

                       Real    _FIT_
01  mCode Offset - FFDCB150 != FFDC9610
           Fixed -             FFDCB150
      mCode Size -     5C00
02  mCode Offset - FFDD0D50 != FFDCFE10
           Fixed -             FFDD0D50
      mCode Size -     5800
03  mCode Offset - FFDD6550 != FFDD6610
           Fixed -             FFDD6550
      mCode Size -     6000
Changes _FIT_ saved
Press any key to continue . . .
```

After pressing any key we're back in the menu with the table on top. You will notice the table now shows the updated microcodes. We are now done here. Press ```0``` to return to the main menu.

## RST
Now there are more things we can update here, one could be very useful but not really required; we can update the SATA/RAID (RST) drivers, though unfortunately it doesn't magically add a RAID controller to 7020 boards. If only!

I have tried [a few versions](https://www.win-raid.com/t596f39-Intel-Management-Engine-Drivers-Firmware-amp-System-Tools.html) and didn't notice any differences, but if you do have a RAID controller there could be benefits. For example using a modified version that allows for RAID0 booting and TRIM from the BIOS itself. You can find a lot more detailed information on the Win-Raid forums. Also note that the latest versions don't always mean best performance.

## iGPU/LAN
What I did update were the ethernet firmware and iGPU VBIOS. Remember those Intel GOP/VBIOS/RST files we grabber earlier? We're going to extract the GOP one. Copy the 2 files found in ```\Intel_GOP_VBT_r2\HSW\189``` to ```C:\UBU\Files\Intel\VBIOS```.

UBU should still be open and if you enter ```2``` in the menu now and new menu will appear displaying a current and available section. Verify the available version is newer than your current one and press ```1``` to update those in the BIOS file.

At the time of writing version ```5.5.1034``` was the newest and probably will be forever. Somehow despite the folder the updates were in being called ```189``` the RAW GOP VBT is left at version ```184```. It appears the files only update the GOP driver.

Press any key to return to the main menu and now press ```3``` another current and available menu will appear. Here I could update my ethernet firmware from ```0.0.17``` to ```0.0.27```. PRess ```1``` to update the drivers inside the BIOS.

If you wish you can also try RST drivers, but for now I left those alone until I know a bit more about the impact they may or may not have on performance. I left mine at the default. Only apply updates you want. But at least apply the microcode updates for security sake.

We're now done modifying the BIOS, wew.

Press ```0``` to return to the main menu and then press ```0``` again then press ```1``` to save the BIOS as ```mod_bios.bin```.

Time to move on to the next section or if you don't want to add KVM/AMT or change the BIOS logo skip ahead to [flashing](#flashing).

## KVM/AMT/SPI
Most Dell OptiPlex system have an Intel feature called vPro, this allows for remote management. Even when the computer is turned off! When I went into the MEBx the first to change the password I noticed sometimes KVM/AMT was not an option or could not be enabled. The BIOS was missing some parts. This is not an issue because we can update MEBx so these options become available again.

Being able to login remotely when the machine is turned off and to be able to turn it on, change BIOS settings or install a new OS is pretty cool and if you need manage lots of computers at work much easier on the legs.

We will also need to download the latest MEBx compatible with our machine. You can update from the 9.0.x to 9.1.x so we are stuck with 9.0.x MEBx and a 9.1.x firmware for it. It can sound a bit confusing, but look at it as MEBx being an operating system. The OS is running version 9.0.x and can only be upgraded within that branch. The firmware the OS uses is at 9.1.x and can only be upgraded within that branch. Maybe it is possible to upgrade but it would involve more risks than benefits. Reprogramming chips in specialised tools are not worth the gains.

1. Go to [this](https://www.win-raid.com/t832f39-Intel-Engine-Firmware-Repositories.html) forum thread and look for the ```B. Intel (Converged Security) Management Engine Firmware Repository``` section, download the file thats linked for 9.1.
2. Open the ```\Intel ME System Tools v9.1 r7\Flash Image Tool\WIN32``` folder and double click ```fitc.exe```. Once open drag your extracted ```mod_bios.bin``` file in it. 
3. From the build menu open build settings and disable ```Generate intermediate build files```. Leave the window open and navigate to ```\Intel ME System Tools v9.1 r7\Flash Image Tool\WIN32\mod_bios\Decomp``` in the folder copy the new firmware downloaded (in my case this file was called *9.1.45.3000_5MB_PRD_RGN.bin*) in step 1 to this folder and rename it to ```ME Region.bin```. If such a file already exists, remove it.
4. Go back to Flash Image Tool ( ```fitc.exe```) that should still be open. Press F5 to build a new image, press yes when asked about a boot profile. Navigate to ```\Intel ME System Tools v9.1 r7\Flash Image Tool\WIN32\Build``` and copy ```outimage.bin``` to your desktop and rename it back to ```mod_\bios.bin``` (this is optional but to keep this guide working it has to to be renamed to avoid confusion).

> Tip: With KVM/AMT enabled you can manage the machine with something like [Meshcommander](https://www.meshcommander.com/meshcommander). And some basics from the a web browser. I'll leave that all to you to explore.


## BIOS Logo
Now that we have a final image (mod_bios.bin) all up to date we can change the Dell BIOS logo. This will be easy compared to the other mods.

Download [UEFITool](https://github.com/LongSoft/UEFITool/releases/download/0.28.0/UEFITool_0.28.0_win32.zip) and [paint.net](https://www.getpaint.net/download.html). 

* Open UEFITool and drag your mod_bios.bin BIOS image in there then press ```control + f``` and change to the GUID tab.
* Paste ```EB3001D5-F827-4938-95E2-5C8F644B966F``` in to the GUID search box and double click on the result in the box below.
* In the main window the GUID is now highlighted, expand it until see ```Raw section``` and right click on it.
* Select ```Extract body``` and save it as ```logo.bmp```. Leave UEFITool open for now.
* Open the logo in paint.net and do your thing!
* Once done save the file as a 4bit bitmap, don't use too many colours it will look bad. Save it as ```new-logo.bmp```.
* Exit paint.net and rename the file to ```new-logo.raw```.
* UEFITool is still open and the ```Raw section``` is highlighted again, this time right click and select ```Replace body``` and choose new-logo.raw to replace it with.
* Press ```control + s``` to save the modified BIOS, save it as ```mod_bios.bin``` overwriting the existing one. UEFITool will ask if you want to open the newly saved image. It's not needed.

Some other images you might want to replace:
```
F8C4B76D-4D4B-4CF9-BCDF-384644F385C6 - F12 Boot Options.
FC213366-3BE1-4BE8-B0B0-A4DAAC9E0778 - Energy Star logo. This logo is disabled by default I think, I never seen it.
7225BDBD-F72C-4955-9F5D-E86C143D8026 - Optiplex 9010 Series. Wonder why this in a 9020 BIOS haha.
80EEAEB5-9099-443D-A919-EF12385D141C - Preparing one time boot menu.
ED6DDA63-C41E-4B8D-9CD5-429B0378AE6A - Preparing to enter Setup.
53257F05-9942-44FA-BA0B-B97B712C705F - Preparing MEBx menu.
9273B6D9-F255-482D-83D3-C1AE0DFF0275 - Diagnostic boot selected.
```

## Flashing
This is the "dangerous" part, it's not really though. But you do have to pay close attention if you want to prevent having to recover from a bad flash.

Enabling service mode requires a jumper on the servcie pins on the motherboard. It disables the write protections to the flash regions. This not needed for extracting, only when flashing.

I think it also possible to remove these restrictions in a modified Grub shell but I wouldn't leave this kind of protections disabled if I were you.

Before you can write anything you have to short the service pins on the motherboard. They are clearly labeled. Use a jumper or some breadboard cables.

Turn the machine off and short the service jumper and turn it back on. You'll get a notice about it and have to press F1 to resume booting.

Once back in Windows it is time to flash the modified BIOS file. Copy ```mod_bios.bin``` to the ```\Intel ME System Tools v9.1 r7\Flash Programming Tool\WIN64```.

Navigate to the same folder in a PowerShell running as admin, and execute ```.\fptw64.exe -bios -f mod_bios.bin```. It will start the process right away. Once it's finished execute ``` .\fptw64.exe -greset```. The machine will now reboot and it is recommended to enter the BIOS and load the factor defaults. Make sure you set things up correctly for your hackingtosh config too. Like legacy roms etc. Save and exit the BIOS.

Enjoy your newly modified and updated BIOS. Feels good right?

There is a lot more to update and modify here, but for now we're done here.

> Note: None of these actions will clear the modifications we made in the modified Grub shell. Clearing those can probably only be done with a jumper on the motherboard or with the Intel tools we used earlier or the recovery methods that are there to recover from bad or corrupt updates.

# Verify
Verify that your microcodes are up to date with [InSpectre](https://www.majorgeeks.com/files/details/inspectre.html).

It's also a good idea to verify the current MEBx versions with ```MEInfoWin64.exe```:
```
PS C:\Intel ME System Tools v9.1 r7\MEInfo\WIN64> .\MEInfoWin64.exe

Intel(R) MEInfo Version: 9.1.45.3000
Copyright(C) 2005 - 2017, Intel Corporation. All rights reserved.

Intel(R) Manageability and Security Application code versions:

BIOS Version:                           A18
MEBx Version:                           9.0.0.0029
Gbe Version:                            1.3
VendorID:                               8086
PCH Version:                            4
FW Version:                             9.1.45.3000 H
LMS Version:                            Not Available
MEI Driver Version:                     11.7.0.1032
Wireless Hardware Version:              Not Available
Wireless Driver Version:                Not Available

FW Capabilities:                        0x4DFE5947

    Intel(R) Active Management Technology - PRESENT/ENABLED
    Intel(R) Capability Licensing Service - PRESENT/ENABLED
    Protect Audio Video Path - PRESENT/ENABLED
    Intel(R) Dynamic Application Loader - PRESENT/ENABLED
    Service Advertisement & Discovery - PRESENT/ENABLED

Intel(R) AMT State:                     Enabled
TLS:                                    Enabled
Last ME reset reason:                   Global system reset
Local FWUpdate:                         Enabled
BIOS Config Lock:                       Enabled
```
All looks good, firmware has been updated and after I changed the password from the ```admin``` default to ```uHhvd!sD^8``` the options to enable remote management could be enabled (KVM/AMT). Network by default is unconfigured, you'll need to turn that on too. You can configure the IP manually or using DHCP. I've had mixed resutls with DHCP. Manual setup is best. Pick an IP outside the range your router/DHCP server serves.

## Windows for those that don't want it
So you're like me and not spend any time in Windows and also don't want to install it on your machine. Well you're in luck! There is a way to create a Windows install that will work on pretty much any computer and runs from a usb drive. Don't use anything too slow or you will be in a serious world of lag and pain because the system keeps using 100% of the disk. Use an old ssd for best results.

You'll need:
* [Rufus](https://rufus.ie) - Totally free but can not create Windows To Go installs on ssd's only usb sticks.
* [WinToUSB](https://www.easyuefi.com/wintousb/) - To create the Windows To Go disk, the free version will do.
* Windows 10 media, you can grab a eval version directly from Microsoft using [this](https://tb.rg-adguard.net/public.php) website.

Create the disk with WinToUSB and boot from it, run Windows Update until there are no more updates.

> Tip: To see file extentions and hidde nfiels and such the easy way, search for "developer" i nthe search or start menu and open thsoe settings. Scroll down to the File Explorer section and click apply.

## Recovery
It is possible to recover from a bad flash. I will detail the process here in the future.

## Unlocking
Some BIOS areas can be unlocked which means you don't have to short the service pins to write to those areas. Use with caution.
```
0x47FC7 		One Of: SMI Lock, VarStoreInfo (VarOffset/VarName): 0x74, VarStore: 0x2, QuestionId: 0x7B, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 BA 01 BB 01 7B 00 02 00 74 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x47FED 			Default: DefaultId: 0x0, Value (8 bit): 0x1 {5B 0D 00 00 00 01 00 00 00 00 00 00 00}
0x47FFA 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x48008 			One Of Option: Enabled, Value (8 bit): 0x1 (default MFG) {09 0E C2 03 20 00 01 00 00 00 00 00 00 00}
0x48016 		End One Of {29 02}
```

```
0x48018 		One Of: BIOS Lock, VarStoreInfo (VarOffset/VarName): 0x75, VarStore: 0x2, QuestionId: 0x7C, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 C0 01 C1 01 7C 00 02 00 75 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4803E 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x4804C 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x4805A 		End One Of {29 02}
```

```
0x4805C 		One Of: GPIO Lock, VarStoreInfo (VarOffset/VarName): 0x76, VarStore: 0x2, QuestionId: 0x7D, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 BE 01 BF 01 7D 00 02 00 76 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48082 			Default: DefaultId: 0x0, Value (8 bit): 0x0 {5B 0D 00 00 00 00 00 00 00 00 00 00 00}
0x4808F 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x4809D 			One Of Option: Enabled, Value (8 bit): 0x1 (default MFG) {09 0E C2 03 20 00 01 00 00 00 00 00 00 00}
0x480AB 		End One Of {29 02}
```

```
0x480AD 		One Of: BIOS Interface Lock, VarStoreInfo (VarOffset/VarName): 0x77, VarStore: 0x2, QuestionId: 0x7E, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 BC 01 BD 01 7E 00 02 00 77 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x480D3 			Default: DefaultId: 0x0, Value (8 bit): 0x1 {5B 0D 00 00 00 01 00 00 00 00 00 00 00}
0x480E0 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x480EE 			One Of Option: Enabled, Value (8 bit): 0x1 (default MFG) {09 0E C2 03 20 00 01 00 00 00 00 00 00 00}
0x480FC 		End One Of {29 02}
```

```
0x480FE 		One Of: RTC RAM Lock, VarStoreInfo (VarOffset/VarName): 0x78, VarStore: 0x2, QuestionId: 0x7F, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 C2 01 C3 01 7F 00 02 00 78 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48124 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E C3 03 30 00 00 00 00 00 00 00 00 00}
0x48132 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E C2 03 00 00 01 00 00 00 00 00 00 00}
0x48140 		End One Of {29 02}
```

# Other interesting stuff in the BIOS
https://software.intel.com/en-us/articles/intel-trusted-execution-technology-a-primer/
```
0x47834 		One Of: Intel TXT(LT) Support, VarStoreInfo (VarOffset/VarName): 0x44, VarStore: 0x2, QuestionId: 0x5F, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 ED 00 EE 00 5F 00 02 00 44 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4785A 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E F6 00 30 00 00 00 00 00 00 00 00 00}
0x47868 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E F5 00 00 00 01 00 00 00 00 00 00 00}
0x47876 		End One Of {29 02}
```

Disabled: ACPI thermal management uses EC reported temperature values.
Enabled: ACPI thermal management uses DTS SMM mechanism to obtain CPU temperature values.
```
0x478BC 		One Of: CPU DTS, VarStoreInfo (VarOffset/VarName): 0x45, VarStore: 0x2, QuestionId: 0x61, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 EF 00 F0 00 61 00 02 00 45 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x478E2 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E F6 00 30 00 00 00 00 00 00 00 00 00}
0x478F0 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E F5 00 00 00 01 00 00 00 00 00 00 00}
0x478FE 		End One Of {29 02}
```

WOL.
```
0x47A95 		One Of: Wake on LAN Enable, VarStoreInfo (VarOffset/VarName): 0x67, VarStore: 0x2, QuestionId: 0x68, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 7D 02 7E 02 68 00 02 00 67 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x47ABB 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E C2 03 00 00 01 00 00 00 00 00 00 00}
0x47AC9 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E C3 03 30 00 00 00 00 00 00 00 00 00}
0x47AD7 		End One Of {29 02}
```

PCI hot swapping. Untested by me haha.
```
0x4A202 		One Of: Hot Plug, VarStoreInfo (VarOffset/VarName): 0xE9, VarStore: 0x2, QuestionId: 0xF5, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 D9 02 DA 02 F5 00 02 00 E9 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4A228 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E C3 03 30 00 00 00 00 00 00 00 00 00}
0x4A236 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E C2 03 00 00 01 00 00 00 00 00 00 00}
0x4A244 		End One Of {29 02}
```

RAM timings.
```
0x51634 		One Of: DIMM profile, VarStoreInfo (VarOffset/VarName): 0x28C, VarStore: 0x2, QuestionId: 0x423, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 06 05 07 05 23 04 02 00 8C 02 14 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x5165A 			One Of Option: Default DIMM profile, Value (8 bit): 0x0 (default) {09 0E 08 05 30 00 00 00 00 00 00 00 00 00}
0x51668 			One Of Option: Custom profile, Value (8 bit): 0x1 {09 0E 0B 05 00 00 01 00 00 00 00 00 00 00}
0x51676 			One Of Option: XMP profile 1, Value (8 bit): 0x2 {09 0E 09 05 00 00 02 00 00 00 00 00 00 00}
0x51684 			One Of Option: XMP profile 2, Value (8 bit): 0x3 {09 0E 0A 05 00 00 03 00 00 00 00 00 00 00}
0x51692 		End One Of {29 02}
```

Set voltage (DDR3 = 1.5v / DDR3L = 1.35v)
```
0x51694 		One Of: DDR Selection, VarStoreInfo (VarOffset/VarName): 0x287, VarStore: 0x2, QuestionId: 0x285, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 12 05 13 05 85 02 02 00 87 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x516BA 			One Of Option: DDR3, Value (8 bit): 0x0 (default) {09 0E 14 05 30 00 00 00 00 00 00 00 00 00}
0x516C8 			One Of Option: DDR3L, Value (8 bit): 0x1 {09 0E 15 05 00 00 01 00 00 00 00 00 00 00}
0x516D6 			One Of Option: Auto, Value (8 bit): 0x2 {09 0E C0 03 00 00 02 00 00 00 00 00 00 00}
0x516E4 		End One Of {29 02}
```

Freqencies, one block for each pair of DIMM slots.
```
0x51729 		One Of: Memory Frequency, VarStoreInfo (VarOffset/VarName): 0x284, VarStore: 0x2, QuestionId: 0x287, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 18 05 19 05 87 02 02 00 84 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x5174F 			One Of Option: Auto, Value (8 bit): 0x0 (default) {09 0E C0 03 30 00 00 00 00 00 00 00 00 00}
0x5175D 			One Of Option: 1067, Value (8 bit): 0x3 {09 0E 1A 05 00 00 03 00 00 00 00 00 00 00}
0x5176B 			One Of Option: 1333, Value (8 bit): 0x5 {09 0E 1B 05 00 00 05 00 00 00 00 00 00 00}
0x51779 			One Of Option: 1600, Value (8 bit): 0x7 {09 0E 1C 05 00 00 07 00 00 00 00 00 00 00}
0x51787 			One Of Option: 1867, Value (8 bit): 0x9 {09 0E 1D 05 00 00 09 00 00 00 00 00 00 00}
0x51795 			One Of Option: 2133, Value (8 bit): 0xB {09 0E 1E 05 00 00 0B 00 00 00 00 00 00 00}
0x517A3 			One Of Option: 2400, Value (8 bit): 0xD {09 0E 1F 05 00 00 0D 00 00 00 00 00 00 00}
0x517B1 			One Of Option: 2667, Value (8 bit): 0xF {09 0E 20 05 00 00 0F 00 00 00 00 00 00 00}
0x517BF 		End One Of {29 02}
```

```
0x517C1 		One Of: Memory Frequency, VarStoreInfo (VarOffset/VarName): 0x285, VarStore: 0x2, QuestionId: 0x288, Size: 2, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 18 05 19 05 88 02 02 00 85 02 10 11 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x517E7 			One Of Option: 1067, Value (16 bit): 0x42B {09 0E 1A 05 00 01 2B 04 00 00 00 00 00 00}
0x517F5 			One Of Option: 1333, Value (16 bit): 0x535 (default) {09 0E 1B 05 30 01 35 05 00 00 00 00 00 00}
0x51803 			One Of Option: 1600, Value (16 bit): 0x640 {09 0E 1C 05 00 01 40 06 00 00 00 00 00 00}
0x51811 			One Of Option: 1867, Value (16 bit): 0x74B {09 0E 1D 05 00 01 4B 07 00 00 00 00 00 00}
0x5181F 			One Of Option: 2133, Value (16 bit): 0x855 {09 0E 1E 05 00 01 55 08 00 00 00 00 00 00}
0x5182D 			One Of Option: 2400, Value (16 bit): 0x960 {09 0E 1F 05 00 01 60 09 00 00 00 00 00 00}
0x5183B 			One Of Option: 2667, Value (16 bit): 0xA75 {09 0E 20 05 00 01 75 0A 00 00 00 00 00 00}
0x51849 		End One Of {29 02}
```

I don't think ECC memory works without also fitting the board with a Xeon or something. Server memory is cheap though. Too bad I have no ECC sticks to try.
```
0x5184B 		One Of: ECC Support, VarStoreInfo (VarOffset/VarName): 0x27D, VarStore: 0x2, QuestionId: 0x289, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 32 05 33 05 89 02 02 00 7D 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x51871 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x5187F 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x5188D 		End One Of {29 02}
```

Could it be?
```
0x4C9FE 		One Of: SATA RAID ROM, VarStoreInfo (VarOffset/VarName): 0x174, VarStore: 0x2, QuestionId: 0x183, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 23 02 24 02 83 01 02 00 74 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4CA24 			One Of Option: Legacy ROM, Value (8 bit): 0x0 (default) {09 0E 25 02 30 00 00 00 00 00 00 00 00 00}
0x4CA32 			One Of Option: UEFI Driver, Value (8 bit): 0x1 {09 0E 26 02 00 00 01 00 00 00 00 00 00 00}
0x4CA40 			One Of Option: Both, Value (8 bit): 0x2 {09 0E 27 02 00 00 02 00 00 00 00 00 00 00}
0x4CA4E 		End One Of {29 02}
```

# Misc
https://ami.com/en/products/firmware-tools-and-utilities/bios-uefi-utilities/

https://raw.githubusercontent.com/syscl/ASUS-H67-series/master/BIOS_Utilities/AMIBCP4.55.0070.exe
