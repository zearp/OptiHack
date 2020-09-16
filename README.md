# OptiHack
My hackintosh journey with the Dell Optiplex 7020 SFF/MT.

<sub>Should also work on 9020 SFF and MT models without additional modifications other than changing RAID to AHCI in the BIOS. You will most likely need to create a usb portmap post-install on most models though. Luckily doing so is [pretty fast and easy](#usb-portmap). The 9020m [seems to need](https://github.com/ismethr/9020mHack/) an AppleALC layout-id of 27 and SMBIOS iMac 14,1.</sub>

![Screenshot](/images/Big%20Sur%20Beta.jpg?raw=true)

### Intro

This is ~~not~~ almost a complete guide. Some hackintosh experience is a must, I'm going to assume you have a working macOS (real or in a virtual machine) though I will try to include Windows where possible. This guide has been tested with macOS Catalina and Big Sur but should work older version too. For the time being please stick with Catalina as Big Sur is still in beta testing. Your build will be much more stable and reliable.

For those with some experience the EFI folder itself should be enough to get going. But I suggest you read on anyways, there are quite a few differences with other methods to keep the setup as vanilla as possible. Many questions will be answered and issues resolved if you read all the sections at least once.

I suck at writing documentation but I need to keep track of things I do for myself and keeping track of progress in guide form it can also help others, hopefully. I've learned a lot in the passed week thanks to all the great guides and awesome software developed totally free by the community. I want to give back and share my findings and journey with all of you.

Please only use this for clean installs, or updating an existing OpenCore install. I replaced my Clover at first and the system wasn't as fast as when I tried a clean install to test my EFI folder before using it on other 7020 boxes. The difference was quite noticeable. So only do a clean install if you're coming from Clover and just import your user data/apps once installed. This will ensure maximum performance. Still want to replace Clover? Read [this](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/nvram.html#cleaning-out-the-clover-gunk) and [this](https://github.com/dortania/OpenCore-Desktop-Guide/tree/master/clover-conversion) on how to do it.

> Note: If you've used a version prior to the 1st of August 2020 it is best to double check your settings and/or start your EFI from scratch as a lot has changed.

## Index
* Installation:
  * [BIOS settings](#bios-settings)
  * [Download and create the installer](#download-and-create-the-installer)
  * [Copy EFI folder](#copy-efi-folder)
  * [Editing config.plist](#editing-configplist)
  * [First boot!](#first-boot)
  * [Disable CFG Lock](#disable-cfg-lock)
  * [Set DVMT pre-alloc to 64MB](#set-dvmt-pre-alloc-to-64mb)
  * [Enable EHCI hand-off](#enable-ehci-hand-off)
  * [Installing macOS](#installing-macos)
  * [Post install](#post-install)
* Sleep
  * [Sleep](#sleep)
  * [Power Management](#power-management)
* USB
  * [Mapping the internal usb header for MT models](#mapping-the-internal-usb-header-for-mt-models)
  * [USB portmap](#usb-portmap)
* Others
  * [dGPU](#dgpu)
  * [SMBIOS](#smbios)
  * [Keybinding/mapping](#keybindingmapping)
  * [RAID0 install and booting APFS](#raid0-install-and-booting-apfs)
  * [Fan curve more like a Mac](#fan-curve-more-like-a-mac)
  * [Undervolting](#undervolting)
  * [SIP](#sip)
  * [Security](#security)
  * [Issues](#issues)
    * [Resetting UEFI changes](#resetting-uefi-changes)
    * [Sleep](#sleep-1)
    * [Logs](#logs)
    * [macOS + Windows on 1 disk](#windows--macos-sharing-a-disk)
    * [Misc](#misc)
  * [Toolbox](#toolbox)
  * [Notes](#notes)
* [Credits](#credits)

## BIOS settings
My BIOS settings are simple: load factory defaults. Those with a 9020 model will need to change RAID to AHCI mode after loading defaults. Double check if loading of legacy roms is enabled. Sleep won't work properly without it.

## Download and create the installer
We need a macOS installer image. There are several ways of obtaining it. The best way is to use a computer (or virtual machine) with a working macOS and download it in the App Store. Alternative methods;
* [gibMacOS](https://github.com/corpnewt/gibMacOS) - Can also create the installer on Windows.
* [Catalina Patcher](http://dosdude1.com/catalina/) - Can also create the installer but for now only use it for downloading.
Once downloaded we can [create the install media](https://support.apple.com/sl-si/HT201372). If you don't have a working macOS system yet you can still create an installer by running gibMacOS's Makeinstall.bat as administrator on Windows but YMMV.

## Copy EFI folder
Download [EFI Agent](https://github.com/headkaze/EFI-Agent/releases) and use it to easily mount the EFI partition on the installer and copy the EFI folder found in this repository to it. I have no idea how to do this on Windows but a quick search led me [here](https://www.insanelymac.com/forum/topic/311820-guide-mount-and-access-efi-partition-on-windows-10/).

## Editing config.plist
Inside the EFI/OC folder on your installer open config.plist and edit/populate the following fields:
```
PlatformInfo -> Generic -> MLB
PlatformInfo -> Generic -> ROM
PlatformInfo -> Generic -> SystemSerialNumber
PlatformInfo -> Generic -> SystemUUID
```
You can generate the MLB/Serial/UUID serials with [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS). Use option 3 and enter *iMac15,1* when asked for the type of SMBIOS to create. If you need to change the model in the future you also need to re-generate a new set of serials, UUID and usb portmap.

Put your ethernet mac address in the ```ROM``` field without semicolons. Fixing this [post-install](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#fixing-en0) is also an option, but is important so don't skip it. You don't want it to stay at the current *00:11:22:33:44:55*.

For more information on setting up OpenCore please refer to [this](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html) very well written guide that has helped realise this very setup.

**NOTE**: Certain models have different grfx base clocks. In my testing 14,3 and 15,1 have a 200mhz base clock and 14,4 and some others have a 750mhz base clock. According to the Intel spec this should be 350mhz. I didn't notice any performance difference between the base clock speeds. Personally I prefer them lower as it reduces heat and energy usage.

> Please use [ProperTree](https://github.com/corpnewt/ProperTree) to edit the OpenCore config.
> Tip: To make ProperTree into a little app, double click on the *buildapp.command* file inside the script folder. The resulting app will be put in the main ProperTree folder. 

## First boot!
Before we can boot into the macOS installer itself there are some things we have to disable and enable that Dell has hidden in the BIOS itself. Why Dell does this is unclear to me, this is a business desktop not a consumer desktop or laptop. There is no need to hide more advanced options. Luckily we can still change them.

Boot from the installer and clear the NVRAM this is important as Clover and OpenCore share that space. It leads to hard to diagnose issues. Clear it each time you've booted with Clover.

Once rebooted and back in the OpenCore picker select modGRUBShell.efi and press enter. You'll end up in a shell where you can execute commands.

> Note: It is always a good idea to verify these offsets yourself by extracting your current BIOS, check how to do it with [this](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) guide. The default values can be found in files in the [text](https://github.com/zearp/OptiHack/tree/master/text) folder. The old and new values will also be printed when you change them. These patches have no influence on other operating systems. If anything it will make them better.

## Disable CFG Lock
To disable CFG Lock you can either use a [quirk](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html) in OpenCore or disable it properly. We will disable it. Entering ```setup_var 0xDA2 0x0``` will disable CFG Lock. To revert simply execute the command again but replace 0x0 with 0x1. This also applies to the other changes we need to make here. In the files with values I link to you can also find the default setting of each in case you want to revert to stock.

## Set DVMT pre-alloc to 64MB
Next up we need to set the DVMT pre-alloc to 64MB, which macOS likes. Enter ```setup_var 0x263 0x2``` to change it. By default it's set to 0x1 which is 32MB. There are [more sizes](https://github.com/zearp/optihack/blob/master/text/CFGLock_DVMT.md) to set here; if you change it to anything else than 64MB you will need to change the ```framebuffer-stolenmem``` in the config.plist file as it needs to match. For example changing it to 92MB you'll have to set ```framebuffer-stolenmem``` to ```00000006```. I've tested larger pre-alloc sizes in a non-4k dual screen setup and while they work I did not notice any differences. Setting it to 64MB should be fine for pretty much everyone though.

> Please note: Changing the pre-alloc size is not really needed but highly recommended, if you don't want to do this you ***must*** apply the DMVT pre-alloc 32MB patch found in Hackintool to the config or else you will get a panic on boot. It may also mean using dual screen or high resolutions won't work.

## Enable EHCI hand-off
For usb to function as good as possible we need to enable handing off EHCx ports to the XHCI controller. We accomplish that by entering the following commands; ```setup_var 0x2 0x1``` and ```setup_var 0x144 0x1``` the first enables EHCI hand-off itself and the second one sets XHCI in normal enabled mode. It's needed because the default value called *Smart Auto* isn't so smart after all. So we simply enable it.

Lastly we enable routing of the EHCx ports to XHCI ones and disable EHCx all together. Only legacy OS would need it. Enter ```setup_var 0x15A 0x2``` to enable the routing then enter ```setup_var 0x146 0x0``` and ```setup_var 0x147 0x0``` to disable the EHCx ports. You can find these values [here](https://github.com/zearp/OptiHack/blob/master/text/XHCI_EHCI.md).

We're done. Exit the shell by running the ```reboot``` command. 

<sub>Credit for DVMT/CFG Lock BIOS research goes to @JimLee1996 and his nice [write up](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) on this subject. Thanks to his work I was able to figure out how to enable EHCI hand-off. More might still come, there's a lot of interesting things that Dell is not exposing in the BIOS. Another big thanks goes to @datasone for providing [the modified Grub shell](https://github.com/datasone/grub-mod-setup_var/).</sub>

> Note: Resetting NVRAM or loading BIOS defaults does ***not*** clear these changes. Make *sure* to double check you're entering the right values and nothing can go wrong. To clear all the settings follow [these](#resetting-uefi-changes) steps.

## Installing macOS
You're now ready to install macOS. Boot from the installer again and select the *Install macOS* entry. Once you made it into the installer format the disks how you like them (use APFS for the macOS partition) and proceed installing. OpenCore should automagically select the right boot partition when reboots happen but pay attention when it does and make sure you keep booting from the internal disk until you end up on a working desktop. The name of the option will change from "Install macOS" to whatever name you gave the macOS partition. Any external boot options are clearly labeled in OpenCore. Sometimes the installer can seem to have stalled (no updates in verbose boot). This happened a lot in the Big Sur installers. Sometimes up to 5 minutes. But it would always boot into the installer. Once installed this delay went away.

1. Boot from installer, select ```Install macOS Catalina (external)``` and once in the installer use the ```Disk Utility``` to format the internal disk. Make sure it's formatted as APFS with a GUID partition scheme. Go back to install menu and start the install process. Select the internal disk as destination and wait till it is done. It is copying the full install image to the internal disk and then verify it. The time it takes depends on the read speed of your installer and the write speed of the destination. After this the installer will reboot.
2. Back in the OpenCore menu, boot from ```Install macOS Catalina (external)``` again and after a while the screen will change and show a progress bar. Now the actual install is happening. Sit back and relax. Once done the machine will reboot again.
3. Back again in the OpenCore menu your internal disk should now be selected automatically. It will be named whatever you named your internal disk. Press enter to boot into your macOS and move on to the next section.

> Note: If it gets stuck saying ```Less than a minute remaining...``` don't worry, on real Macs this also happens and can take quite some time. Apple has always had issues calculating the remaining time for reason, the same happens when installing updates.

If you run into any boot issues, check the [troubleshooting sections](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html) of the OpenCore vanilla guide. Big chance your problem is listed including a solution.

(It is also a good idea to [sanity check](https://opencore.slowgeek.com) your config file if you made a lot of changes to the config file. Select Haswell from the dropdown and OpenCore version 0.5.7. The sanity checker will complain about certain things but those are needed for [FileVault2](https://dortania.github.io/OpenCore-Post-Install/universal/security.html#filevault). Check the page to know which sanity check warnings you can ignore and which ones need attention.)

## Post install
Once macOS is installed and made it trough the post-install setup screens we'll install [EFI Agent](https://github.com/headkaze/EFI-Agent/releases) again and mount the EFI partition of the internal disk and the EFI on your installer. Copy the EFI folder from the installer to the internal disk. 

Yes, we're nearly done now.

If you don't have an ssd you can skip the next step, which is hopefully nobody.

We need to check if TRIM is enabled, open the *System Information* app and under SATA/SATA Express highlight your internal disk on the right and verify it says ```TRIM Support: Yes``` there.

If it says *NO*; close all open apps, open a terminal and execute ```sudo trimforce enable``` enter yes for both questions and once rebooted TRIM should be enabled. Repeat the previous steps to make sure it's enabled now.

Also don't forget to set your ethernet mac address correctly. This [guide](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html#fixing-en0) will, well, guide you.

We're pretty much done now, I suggest you do read all the following sections though, some may apply to you. Either way, have fun using macOS on your OptiHack!

> Tip: Make a [clone](https://github.com/zearp/OptiHack/blob/master/text/CLONE_IT.md) once you're happy with your setup and everything works as it should. It doesn't take much time and I'd say it's essential to have one.

## Sleep
Sleep is working as it should. It will fall asleep automatically after a while. Waking up the machine can be done with a bluetooth or usb keyboard/mouse. Apple has removed the slider to control this but it does go to sleep on its own. Manual sleep also works, it takes about 30 seconds. Hibernation is disabled by default on desktops. For good measure lets disable stand-by and auto power off.

```
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
```
If you don't plan on enabling hibernation you can delete the ```sleepimage``` to regain some space. Delete the file and create a folder so macOS can't generate the ```sleepimage``` file again.

```
sudo rm /var/vm/sleepimage
sudo mkdir /var/vm/sleepimage
```

Power Nap is enabled and doesn't cause any issues with sleep. Not sure if it actually works though (doing Time Machine backups while sleeping, etc). Don't want Power Nap? Disable it while you're here; ```sudo pmset -a powernap 0```

Verify the settings with ```pmset -g```.

## Power Management
This should be enabled and setup properly. You can run the [Intel Power Gadget](https://software.intel.com/en-us/articles/intel-power-gadget/) to check the temperatures and power usage. There is some CPU specific fine tuning that still can be done, but you're on your own for that journey. Dortania wrote detailed instructions in their [guide](https://dortania.github.io/OpenCore-Post-Install/universal/pm.html) on this subject. I urge you do follow it and put the finishing touches on your install.

> Note: I noticed without CPUFriend.kext my minimum cpu speed was 700mhz, in Windows it's set to 800mhz. My CPU is an exact match to the iMac 14,3 model (Catalina) and I'm not sure if CPUFriend is needed for anyone. But you can still use it to tweak things if you wish. It doesn't surprise me Apple drives these cpu's at lower frequencies for both the cpu and gpu parts, it keeps the temps and noise down. Until you really start hammering it.

## Mapping the internal usb header for MT models
The MT models have an internal unused usb header. You will have create a new portmap if you intend to use this port (for bluetooth most likely). I didn't map it because I have SFF boxes only. The internal port is HS13. With that port mapped you'll be at the 15 ports limit that macOS imposes. See the section below on how to make a new usb portmap. For more info about usb portmaps please read [this](https://usb-map.gitbook.io/project/terms-of-endearment) great write-up.

## USB portmap
Due to our EHCI/XHCI uefi edits you can make the portmap without any renaming, USBInjectAll and the FakePCIID kexts. This makes mapping a lot easier and faster, lets start by mounting the EFI partition with [EFI Agent](https://github.com/headkaze/EFI-Agent/releases).

(If you're mapping the internal usb port make sure there is something connected to it before you start.)

1. Open your OpenCore config and set ```Kernel -> Add -> 6 -> USBPorts.kext``` to *disabled* and *enable* ```Kernel -> Quirks -> XhciPortLimit```.
2. Reboot.
3. Open Hackintool and go to the usb tab, select all ports listed and remove them, then click the refresh button.
4. Plug a usb 2 device in every usb port.
5. Plug a usb 3 device in every usb port.
6. Remove anything not green, you should be left with 14 green ports (15 with internal usb port).
7. Make sure all the HSxx ports are set to usb 2 and SSPx ports are to usb 3 (if you're mapping the internal port make sure it's set to internal).
8. Click on the export button and place the resulting USBPorts.kext in the OpenCore kexts folder (overwriting the existing one).
9. Open your OpenCore config and set ```Kernel -> Add -> 6 -> USBPorts.kext``` to *enabled* and *disable* ```Kernel -> Quirks -> XhciPortLimit```.
10. Reboot.

Verify the ports in Hackintool, go to the usb tab again, select all ports and delete them and click refresh again. It should now look like [this](https://github.com/zearp/OptiHack/blob/master/images/usb-portmap.png?raw=true), 14 or 15 ports showing all with the correct usb 2 or usb 3 labels. And HS13 showing as internal for those who have it.

> Tip: If you plan on using hubs consider tweaking/removing some ports. For example you can set the usb 3 ports to only do usb 3 by removing the HS03/HS04/HS11/HS12 entries. This will free up 4 ports. You can also remove ports you're not planning to use on [the machine](https://github.com/zearp/OptiHack/blob/master/images/usb-ports.png?raw=true) itself. If you go above the 15 ports usb devices *will* disappear. Which is not what you want when you have some disks connected.

Please don't use hubs to map the ports, they've produced some bad portmaps in my testing as they can take up multi ports at once. Use simple (non data carrying) usb 2 and usb 3 devices like dongles/receivers/wifi/etc to be fast and safe.

> Note: Due to the enabling of EHCI hand-off and others the naming of usb 3 ports changes from SS0x to SSPx. If you're re-using a portmap from a previous EFI be sure the ports (and addresses) match up. When in doubt, create a new portmap.

## dGPU
The current config disables any external graphics cards, this is to prevent issues. Once the iGPU is working properly you can start setting up external graphics. Don't forget to remove the ```disable-external-gpu``` and if the dGPU uses HDMI instead of DisplayPort also remove the ```disable-hdmi-patches``` bits from the iGPU device properties (```PciRoot(0x0)/Pci(0x2,0x0)```) in the config.

If you don't plan on using the iGPU at all (i.e. no display connected) you can delete the whole ```PciRoot(0x0)/Pci(0x2,0x0)``` section and WhateverGreen should automatically configure it as computing device. It can do video encoding/decoding and such. You will also need to change the BIOS and make the dGPU the primary video card for encoding/decoding to work.

## SMBIOS
For Catalina its best to use a model that matches your processor as closely as possible. But with big Sur this is no longer an option. You have to use 15,1 or 14,4 the latter resulting in much higher base clock (750mhz) for the HD4600.

But if you change the model you will have to create a new USBPorts.kext as the kext is linked to product name. You could get away with editing jsut the plist file inside the kext. But if usb starts acting up it's best to create a new map. You will also have to generate a new pair of serials and system UUID as done [previously](#editing-configplist) if you change the model.

> Note: If everything is working fine for you then there is *no need* to change the iMac 15,1 default.

## Keybinding/mapping
Merely installing [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements/releases) will make your keyboard work more like a Mac. F4 will open the Launchpad for example. You don't have to stick with those defaults. It is very easy to remap pretty much any key from any keyboard or mouse or other HID device. Be it bluetooth or wired. I'll add a how-to with some examples here in the future. For creating a full custom keymap check out [Ukelele](http://software.sil.org/ukelele/).

## RAID0 install and booting APFS
I've added 2x 250GB SSDs and currently running them in a [RAID0 setup](https://github.com/zearp/optihack/blob/master/images/diskutility.png?raw=true). The speeds have [doubled](https://github.com/zearp/optihack/blob/master/images/blackmagic.png?raw=true) and are close to the max the sata bus can handle. Cloning my existing install to the array was straight forward thanks to [this guys](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) awesome work.

So now, if we want to we can boot from RAID0 in Catalina. I think on Reddit he mentioned FileVault2 works too, but I haven't had any luck with that (yet). But booting from RAID0 works fine. I use one of the two disks to put the OpenCore EFI folder on and in the OpenCore picker it doesn't matter which one of the two macOS entries I pick. The BIOS automatically boots from the disk with the EFI folder. Putting the EFI folder on both disks would get very confusing very fast. Inside macOS the disks are sometimes swapped (disk0 becomes disk1 and disk1 becomes disk0) but that isn't an issue at all.

The article is easy to following along with and best to do a clean install with an installer made with the [Catalina Patcher](http://dosdude1.com/catalina/) as per his guide and afterwards import your old data *but* if you setup the array like he did you can clone your existing install to it. No need for a clean install. Just make sure to run ```sudo update_dyld_shared_cache -root /``` and ```diskutil apfs updatePreboot disk3s5``` after booting into your clone on the RAID array for the first time. And also run those two commands after updating macOS itself. Updates to macOS will claim they failed but they didn't. Just reboot, execute the previous commands and you'll be on your way.

If you have errors relating to security vault or similar when updating the Preboot volumes you can easily fix those by booting into a working macOS recovery partition or installer, open a terminal and run ```resetFileVaultPassword```. 

(This command can also fix the issue where FileVault2 can't be enabled.)

## Undervolting
Been testing an undervolted setup using [VoltageShift](https://github.com/sicreative/VoltageShift) for quite some time. Not anything too much (-75mv CPU and -50mv GPU). It doesn't really impact performance but does make things run cooler and it uses less energy.

You can build it from source or easier, download the precompiled binary [here](https://sitechprog.blogspot.com/2017/06/voltageshift.html) and we apply a little fix explained [here](https://github.com/sicreative/VoltageShift/issues/34#issuecomment-576119169).

***Make a backup of your system before doing anything, crashes will happen when trying to find the optimal values.***

* Make sure you allow loading of unsigned kexts, either with the ```kext-dev-mode=1``` boot flag or by changing the SIPS/csr config. I suggest adding the bootflag.
* Create a new folder called VoltageShift or something like that, I suggest making in your home directory.
* Put your compiled or downloaded ```VoltageShift.kext``` and the ```voltageshift``` binary in that folder.
* Open a Terminal and go to the folder; cd ~/VoltageShift
* Set correct permission of the kext by running; ```sudo chown -R root:wheel VoltageShift.kext```
* Test if it works by running; ```sudo ./voltageshift info```, if it works you'll see something like this:
```
   VoltageShift Info Tool
------------------------------------------------------
WRMSR 150 with value 0x8000001000000000
RDMSR 150 returns value 0xf6a00000
CPU voltage offset: -75mv
WRMSR 150 with value 0x8000011000000000
RDMSR 150 returns value 0x100f9c00000
GPU voltage offset: -50mv
WRMSR 150 with value 0x8000021000000000
RDMSR 150 returns value 0x200f6a00000
CPU Cache voltage offset: -75mv
WRMSR 150 with value 0x8000031000000000
RDMSR 150 returns value 0x30000000000
System Agency offset: 0mv
WRMSR 150 with value 0x8000041000000000
RDMSR 150 returns value 0x40000000000
Analogy I/O: 0mv
WRMSR 150 with value 0x8000051000000000
RDMSR 150 returns value 0x50000000000
Digital I/O: 0mv
CPU BaseFreq: 2900, CPU MaxFreq(1/2/4): 3600/3500/3200 (mhz)  PL1: 65W PL2: 81W 
CPU Freq: 3.2ghz, Voltage: 0.8932v, Power:pkg 16.09w /core 8.31w,Temp: 36 c
```
In my output you can see an undervoltage is already applied. To try out undervolting the CPU and iGPU you can run; ```sudo ./voltageshift offset -50 -25 -50```. This will apply a small amount only. You can then run some stress tests and see if the system crashes or not. The values are CPU / GPU / CPU cache. There are more values but don't touch those unless you know what you're doing.

Once you found the perfect values you can make them apply on start-up automatically by running; ```sudo ./voltageshift buildlaunchd -50 -25 -50 0 0 0 1 65 81 120```. The last 3 values are P1 and P2 values that will be listed when you ran the ```info``` command earlier. Just use the defaults unless you need to change those. The final value is the time it checks/re-applies the settings. Waking up from sleep can sometimes reset them so we're checking every 2 hours. Which would lave a maximum of 2 hours without the settings applied after waking up. Feel free to tweak and for more information about the options please read [this](https://github.com/sicreative/VoltageShift/blob/master/README.md). To remove the launch deamon simply run; ```sudo ./voltageshift removelaunchd```

If you run a system that is passively cooled or low-rpm fans you might benefit from disabling turbo and reducing the P1/P2 values a bit. This will decrease performance a bit but also prevent things from heating up too fast. Combine this with custom multiplier/clocks with CPUFriend and you can run a pretty cool system without much fan noise.

> Note: If you downloaded the precompiled binary you need to remove code signing or else it won't run. You do this with [stripcodesig](https://github.com/tvi/stripcodesig). Either download it or build it and remove the code signature from the ```voltageshift``` binary.

## Fan curve more like a Mac
These machines run pretty cool with the stock cooler and some new thermal paste. Idles around 30c and 35-40c under light loads. Even when running Geekbench 4 I didn't notice the fan ramp up at all. In the BIOS there's a fan curve defined. It regulates when and how fast the fan spins up. By default Dell has configured it like this;

* Normal idle fans, 1st gear till 55c.
* From 55c till 71c it runs in 2nd gear.
* From 71c till 95c it run in 3rd gear.

If it still didn't manage to get things cool again it will start going at the max. Press the little button on the back of the PSU when the machine is powered off but connected to hear how full blast sounds.

Now this is pretty reasonable and the stock fans are not loud. But if you want it to change to how Macs behave we change the values to these;

* Normal idle fans, 1st gear till 71c.
* From 71c till 87c it runs in 2nd gear.
* From 87c till 95c it run in 3rd gear.

(With fan control software it doesn't seem possible to trigger the "3rd gear" the [BIOS](https://github.com/zearp/OptiHack/blob/master/text/FANS.md) describes, maybe I misunderstand or it only happens when it nearly catches fire...)

And again if it didn't manage to cool things down it will go towards the max until its cooler, if thats fails thermal throttling starts (TCASE) and if that also fails to cool things down the computer shuts itself down. The Intel ark lists the TCASE for most Haswell cpu's around 72c. I've read on a few forums where people tested this and their Haswell cpu's didn't throttle around that temp but around 85-95c. It depends on the processor, BIOS and motherboard too. You can test this in Windows with AIDA64 to find out where your cpu starts to throttle.

What this Mac-like fan curve does in practise is that short bursts of heavy system load -- that could quickly increase the temps causing the fans to spin up -- not to spin the fans up as the temp will drop down once the burst is over. Resulting in a quieter machine. This is what Apple does and why their machines stay so silent up to around 85-90c when the plane takes off and thermal throttling sets in.

On laptops this can really make a big difference where unpacking a big compressed file won't cause the fans to spin up at all where normally they will go on and then off again. Often repeating that cycle. Same happens when you watch some YouTube or something. It is perfectly fine to leave the fans at lower speeds when doing some intensive work for a while. When I have to pick between watching some videos in silence with the cpu at 65c vs watching it with the fan going on and off I choose the former. Most machines can keep themselves within safe temps with low fan speeds.

All in all for this machine it is not really needed to adjust these but you *can*, and if you replace the stock fans with something else you might have to. If the fans work with how Dells PWM wants to drive them and thats after you converted their proprietary 5 pin fan connecter into a normal 4 pin one with a $0.99 eBay cable.

To get the above curve you change the following values in the modified Grub shell;

```
setup_var 0x1B8 0x47
setup_var 0x1B9 0x57
```

Refer to [this list](https://github.com/zearp/OptiHack/blob/master/text/FANS.md) to set your own temperatures. Be sure to always double check your settings and don't do anything too extreme or your computer will melt or create a blackhole. 

Thats it! Your silent OptiPlex will now be even more silent.

> Note: We've only changed when the fans turn on not how fast they spin. Fans speed modifications are more tricky as they depend on the capabilities of the fan you're driving and as far as the stock fans go they can't really spin much slower with the default settings. Only the system fan can be tuned a bit slower but its not audible.

## SIP
Current SIP setting ready for undervolting; ```csr-active-config 03000000``` in OpenCore config, which does the same as running ```csrutil enable --without kext --without fs``` from recovery/installer. If you don't plan on undervolting you can set the ```csr-active-config``` value to ```00000000```. That is the most secure option. Verify the current SIP settings by running ```csrutil status```.

> Note: If changing the config alone doesn't seem to change the SIP settings, reset NVRAM and if thats not enough try entering setting them manually from recovery or the installer. Just run ```csrutil enable``` to turn it on.

## Security
* One thing you *must* do if not done already is to change the password of the Intel Management BIOS. Reboot the machine and press F12 to show the boot menu and select the Intel Management option. The default password is ```admin``` which is why it should be changed. The new password must have capitals and special characters. While you're in there you can also completely disable remote management or configure it to your liking. If AMT/KVM is missing you will need to update that. If you're having issues with this check if on the inside of your case is a sticker with a number. Only those with a ```1``` are equipped with fully fledged vPro options.

To update MEBx and enable KVM/AMT if it isn't available in your BIOS please read [this](https://github.com/zearp/OptiHack/blob/master/text/BIOS_STUFF.md) page. It also deals with updating [microcodes](https://en.wikipedia.org/wiki/Microcode). Which can enhance security as well.

* If you're not going to undervolt please refer to the SIP section on how to set that back to its more secure default.

I personally suggest to also install an app that keeps track of apps connecting out. There are many options out there. Personally I use [TripMode](https://www.tripmode.ch). It is cheap and works great blocking apps that call home a bit too often or shouldn't be accessing the internet at all. I'm looking at you Apple!

> Moreover, further research by Landon Fuller, a software engineer and CEO of Plausible Labs indicates further trespasses on consumer privacy courtesy of OS X Yosemite, including the revelation that any time a user selects “About this Mac” the operating system contacts Apple with a unique analytics identifier whether or not the Apple user has selected to share analytics data of this kind with Apple. [(source)](https://trendblog.net/apples-new-os-x-yosemite-spying/)

The kind people over at [Objective-See](https://objective-see.com/products.html) even provide a free front-end to the build-in firewall called [LuLu](https://objective-see.com/products/lulu.html). They also have a lot of other very useful apps for the security curious amongst us.

**FileVault2**:
This works out of the box. You can enable it in the System Preferences app. If you're having any issues please double check the settings using [this](https://dortania.github.io/OpenCore-Post-Install/universal/security.html) guide.

## Issues
### Resetting UEFI changes
You have to remove the CMOS battery, short the ```RTCRST``` jumper and remove the ```PSWD``` jumper. Also remove the power chord and then hold the power button for 10-20 seconds (this drains all left over electricity so called ```flea power```). Now reconnect the power chord and wait for 30 seconds so the settings can be cleared. Now power up the machine. Everything should now be reset to stock values. Turn the machine off again and put the CMOS battery back in and set the jumpers back to how they were before. Now turn the machine back on and load BIOS defaults for good measure.

> Note: This is a mix of CMOS and jumper reset methods for maximum effect as just following the desktop guide on the Dell site didn't clear everything in my testing. Read more about it [here](https://www.dell.com/support/article/de-ch/sln284985/how-to-perform-a-bios-or-cmos-reset-and-or-clear-the-nvram-on-your-dell-system).

### Sleep
Sleep will not work properly with usb hubs, this includes some sata -> usb 3 dongles. Anything that acts as usb-hub will cause the machine to sleep and wake right up. I have no issues with sleep with usbb sticks and disks in normal usb 3 -> sata cases. They stay connected, even encrypted volumes and don't eject when the machine wakes up. Only devices that act as usb will cause issues.

When dealing with sleep issues make sure to test things with no usb devices connected other than keyboard/mouse. Check if legacy rom loading is *enabled* in the BIOS. Disable; Power Nap and wake for ethernet access in ```System Preferences -> Energy Saver```. It is by [design](https://support.apple.com/en-gb/HT201960) macOS wakes your machine up periodically when ```Wake for Ethernet network access``` is enabled. If you still get wake-ups that could be related to WOL (Wake on LAN) try disabling WOL in the BIOS itself as well.

If you have any issues where the machine wakes up right after falling asleep run ```log show --style syslog | fgrep "[powerd:sleepWake]"``` in a Terminal and find the wake reasons. If it says something about ```EHC1 EHC2/UserActivity Assertion``` or ```HID``` it means it was user input -- or a cat on the keyboard -- anything else with EHCx in it could point to some other usb device. There can also be another reason, find it in the log and try to fix it. It's part of the fun!

If your logs show something like ```DarkWake from Normal Sleep [CDNPB] : due to RTC/Maintenance``` it means Power Nap is enabled. These are scheduled wake-ups to make a backup or check mail. Disable Power Nap to get rid of them.

When I was testing native hibernation with [HibernationFixup](https://github.com/acidanthera/HibernationFixup) the sleep logs were very helpful. They changed from ```Wake from Normal Sleep``` to ```Wake from Hibernate``` which would imply hibernation is working. Which is good because when set to mode ```25``` it writes the contents of the memory to disk instead of leaving it in there. Which means in case of a power outage you don't lose the contents of the memory. Waking up may become a bit slower though.

The ```pmset``` settings after install are:
```
 standby              1
 Sleep On Power Button 1
 womp                 1
 hibernatefile        /var/vm/sleepimage
 powernap             1
 networkoversleep     0
 disksleep            10
 standbydelayhigh     86400
 sleep                25
 autopoweroffdelay    28800
 hibernatemode        0
 autopoweroff         1
 ttyskeepawake        1
 displaysleep         25
 highstandbythreshold 50
 standbydelaylow      86400

```
### Logs
* Boot logs, to get (early) boot logs execute ```log show --predicate 'process == "kernel"' --style syslog --source --last boot``` right after a reboot to get them. A good way to find errors regarding kext loading and such.
* Cleaning logs, often it is nice to clean the logs when testing, execute ```sudo log erase --all``` to wipe them.
* Debug logs and options are disabled where possible, this speeds up booting and helps performance. Debug logging and versions of software with debug symbols shouldn't be used in production. If you have issues booting OpenCore please re-enable debug logging as outlined [here](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/debug.html). This won't impact normal logging like boot logs or system logs. If anything it makes them more readable as it won't have an overload of information.

### Windows + macOS sharing a disk
Windows Updates can mess up your EFI partition by overwriting ```BOOTx64.efi```, this will only be a problem if you share 1 disk/EFI with both Windows and macOS. Ideally install each OS on its own disk, unless no other option. To prevent Windows Update form messing up your EFI you have to download the latest OpenCore release and copy the Bootstrap folder found in EFI/OC to your EFI/OC folder. Then change ```Misc -> Security -> BootProtect``` from None to Bootstrap. This should protect OpenCore in the event Windows Updates decides to remove files on your EFI partition. 

### Misc.
* OpenCore doesn't remember the last booted volume? Press ```control + enter``` to set a new default. Wiping NVRAM can also help cure this.
* The AppleALC id of 17 gives you access to all audio ports with manual selection, this should be best for most people. Layout id 13, 15 or 16 are alternates if 17 isn't right for you.

## Toolbox
These are the apps I use and have used in my journey so far. Some more essential than the others but all must have's on my installs.
* [AppCleaner](https://freemacsoft.net/appcleaner/) - Easy way to remove apps including all their crud. Be sure to enable the *SmartDelete* function.
* [Cog](https://github.com/kode54/Cog) - A lovely minimalist music player that has been around for a very long time.
* [CotEditor](https://github.com/coteditor/CotEditor) - Fast and free editor with lots of features, dark mode and syntax highlighting.
* [EFI Agent](https://github.com/headkaze/EFI-Agent/) - Using the command line to mount EFI folders is very 2019.
* [Hackintool](https://github.com/headkaze/Hackintool) - My EDC.
* [Hex Fiend](https://ridiculousfish.com/hexfiend/) - We all need a hex editor in our life. This is made by someone named Ridiculous Fish. How can you say no to that? On top of that its very fast, capable and totally free.
* [HWMonitor](https://bitbucket.org/RehabMan/os-x-fakesmc-kozlek/downloads/) - Hidden inside the FakeSMC zip file we find an old dog with tricks you still want to see from time to time.
* [Intel Power Gadget](https://software.intel.com/en-us/articles/intel-power-gadget/) - More accurate cpu/gpu/pwr stats (see screenshots below).
* [IOJones](https://github.com/acidanthera/IOJones) - Because IORegistryExplorer doesn't have dark mode.
* [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements) - Make remapping keys and buttons a breeze.
* [MaciASL](https://github.com/acidanthera/MaciASL) - Dark mode enabled MaciASL? Yes please!
* [Meld](https://github.com/yousseb/meld) - Compare (and merge) everything! Sweet little diff tool.
* [Monolingual](https://ingmarstein.github.io/Monolingual/) - Remove unused languages and architectures from apps. Yes I like it tidy!
* [Onyx](https://titanium-software.fr/en/onyx.html) - Always seem to come in handy at some point or another.
* [ProperTree](https://github.com/corpnewt/ProperTree) - OpenCore config editor and very useful for other plist editing too.
* [Transmission](https://transmissionbt.com/) - To download those Linux iso's. The "[nightly](https://build.transmissionbt.com/job/trunk-mac/)" builds have dark mode support.
* [VLC](https://www.videolan.org) - Plays any media Cog can't.

Then there's Homebrew and less known, but useful as you don't need the full Homebrew installed, Rudix. Not to forget MacPorts, which has some packages not found on the previous two.

* [Homebrew](https://www.videolan.org) - The best known and most complete package manager for macOS.
* [Rudix](https://rudix.org) - Less known, a lot less packages but they're all pre-compiled and don't require anything but the package themselves.
* [MacPorts](https://www.macports.org) - Mostly packages needed to build stuff from source like cctools.

## Notes
* Please use a DisplayPort to DisplayPort cable whenever possible. DP -> HDMI conversion often leads to issues. If you have to use such a converter or converting cable and run into issues you might benefit from removing ```disable-external-gpu``` and ```disable-hdmi-patches``` entries in the iGPU device info in the config.
* For 4k to work properly you may need to use the DisplayPort port closest to the VGA connector. Thanks to [mgrimace](https://github.com/zearp/OptiHack/pull/11#issuecomment-667554875).
* The VRAM size is currently set to 2GB in the config, unlike the screenshot suggests. If you want to go to back to 1.5GB just remove the ```framebuffer-unifiedmem``` key from the config.
* I don't know why Dell would lie about the specs if not for up-selling other products but some stuff in their documentation is plain wrong. But the 7020 SFF/MT computer supports 32GB RAM, not 16GB. The on-board sata ports are *all* 6gbit/s. Dell claims one is 3gbit/s max. Bad Dell!

CAN'T DO:
* SideCar. Tried the patches to enable it and it works but it's not smooth and iPad display glitches when the image is moving. Good as photo frame only :p
* DRM for stuff like Netflix and Amazon Prime [require a dGPU](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md). Bummer, but not a deal breaker for me personally. I do wonder why on my old MacBook I can play Prime Video in 1080p in Safari on a HD4000. Somehow DRM works fine there.

## Credits
* The [Acidanthera](https://github.com/acidanthera/) team -- OpenCore(!), WhatEverGreen, Lilu, VirtualSMC, AppleALC, etc, etc. Amazing work.
* [Dortania](https://dortania.github.io/OpenCore-Install-Guide/config.plist/haswell.html) -- Vanilla Desktop Guide, without this I wouldn't have gotten far.
* [headkaze](https://github.com/headkaze) -- Hackintool (an essential) and EFI-Agent is pretty sweet too.
* [corpnewt](https://github.com/corpnewt) -- Many essential tools, guides/documentation, simply great!
* And many, many more I forgot.

A deep bow to all of you!
