# OptiHack
My hackintosh journey with the Dell Optiplex 7020 SFF/MT.

<sub>Should also work on 9020 SFF and MT models without additional modifications. For the 9020 USFF you need to create a usb portmap post-install. The 9020 micro needs the same and possibly more modifications, I have no experience with that model. The 7020 was only available in SFF and MT form-factor.</sub>

![Screenshot](https://github.com/zearp/optihack/blob/master/images/mmk.png)

### Intro

This is ~~not~~ almost a complete guide. Some hackintosh experience is a must, I'm going to assume you have a working macOS (real or in a virtual machine) though I will try to include Windows where possible.

For those with some experience the EFI folder itself should be enough to get going. But I suggest you read on anyways, there are quite a few differences with other methods to keep the setup as vanilla as possible. Many questions will be answered and issues resolved if you read all the sections at least once.

I suck at writing documentation but I need to keep track of things I do for myself and keeping track of progress in guide form it can also help others, hopefully. I've learned a lot in the passed week thanks to all the great guides and awesome software developed totally free by the community. I want to give back and share my findings and journey with all of you.

Please only use this for clean installs, or updating an existing OpenCore install. I replaced my Clover at first and the system wasn't as fast as when I tried a clean install to test my EFI folder before using it on other 7020 boxes. The difference was quite noticeable. So only do a clean install if you're coming from Clover and just import your user data/apps once installed. This will ensure maximum performance. Still want to replace Clover? Read [this](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/nvram.html#cleaning-out-the-clover-gunk) and [this](https://github.com/dortania/OpenCore-Desktop-Guide/tree/master/clover-conversion) on how to do it.

> Note: If you've used a version prior to the 15th of April 2020 it is best to start from scratch as a lot has changed.

## Index
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
* [Sleep](#sleep)
* [Power Management](#power-management)
* [dGPU](#dgpu)
* [Undervolting](#undervolting)
* [Keybinding/mapping](#keybindingmapping)
* [Mapping the internal usb header for MT models](#mapping-the-internal-usb-header-for-mt-models)
* [USB portmap](#usb-portmap)
* [SMBIOS](#smbios)
* [RAID0 install and booting APFS](#raid0-install-and-booting-apfs)
* [Fan curve more like a Mac](#fan-curve-more-like-a-mac)
* [SIP](#sip)
* [Security](#security)
* [Toolbox](#toolbox)
* [Issues](#issues)
* [Misc](#misc)
* [Credits](#credits)
* [Notes](#notes)

## BIOS settings
My BIOS settings are simple: load factory defaults and enable legacy rom loading.

## Download and create the installer
We need a macOS installer image. There are several ways of obtaining it. The best way is to use a computer (or virtual machine) with a working macOS and download it in the App Store. Alternative methods;
* [gibMacOS](https://github.com/corpnewt/gibMacOS) - Can also create the installer on Windows.
* [Catalina Patcher](http://dosdude1.com/catalina/) - Can also create the installer but for now only use it for downloading.
Once downloaded we can [create the install media](https://support.apple.com/sl-si/HT201372). If you don't have a working macOS system yet you can still create an installer by running gibMacOS's Makeinstall.bat as administrator on Windows but YMMV.

## Copy EFI folder
Download [EFI Agent](https://github.com/headkaze/EFI-Agent/releases) and use it to easily mount the EFI partition on the installer and copy the EFI folder found in this repository to it. I have no idea how to do this on Windows but a quick search led me [here](https://www.insanelymac.com/forum/topic/311820-guide-mount-and-access-efi-partition-on-windows-10/).

## Editing config.plist
Inside the EFI/OC folder on your installer open config.plist and populate the following fields:
```
PlatformInfo -> Generic -> MLB
PlatformInfo -> Generic -> ROM
PlatformInfo -> Generic -> SystemSerialNumber
PlatformInfo -> Generic -> SystemUUID
```
You can generate the MLB/Serial/UUID with [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS). Use option 3 and enter *iMac14,3* when asked for the type of SMBIOS to create. If you need to change the model in the future you also need to re-generate a new set of serials and UUID.

Put your ethernet mac address in the ROM field without semicolons. Fixing this [post-install](https://dortania.github.io/OpenCore-Desktop-Guide/post-services/iservices.md#fixing-en0) is also an option, but is important so don't skip it. You don't want it to stay at the current *00:11:22:33:44:55*.

For more information on setting up OpenCore please refer to [this](https://desktop.dortania.ml/config.plist/haswell.html) very well written guide that has helped realise this very setup.

> Please use [ProperTree](https://github.com/corpnewt/ProperTree) to edit the OpenCore config.
> Tip: To make ProperTree into a little app, double click on the *buildapp.command* file inside the script folder. The resulting app will be put in the main ProperTree folder. 

## First boot!
Before we can boot into the macOS installer itself there are some things we have to disable and enable that Dell has hidden in the BIOS itself. Why Dell does this is unclear to me, this is a business desktop not a consumer desktop or laptop. There is no need to hide more advanced options. Luckily we can still change them.

Boot from the installer and clear the NVRAM this is important as Clover and OpenCore share that space. It leads to hard to diagnose issues. Clear it each time you've booted with Clover.

Once rebooted and back in the OpenCore picker select modGRUBShell.efi and press enter. You'll end up in a shell where you can execute commands.

> Note: It is always a good idea to verify these offsets yourself by extracting the BIOS, check how to do it with [this](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) guide. The default values can be found in files in the [text](https://github.com/zearp/OptiHack/tree/master/text) folder. The old and new values will also be printed when you change them. These patches have no influence on other operating systems. If anything it will make them better.

## Disable CFG Lock
To disable CFG Lock you can either use a [quirk](https://desktop.dortania.ml/extras/msr-lock.html) in OpenCore or disable it properly. We will disable it. Executing ```setup_var 0xDA2 0x0``` will disable CFG Lock. To revert simply execute the command again but replace 0x0 with 0x1. This also applies to the other changes we need to make here.

## Set DVMT pre-alloc to 64MB
Next up we need to set the DVMT pre-alloc to 64MB, which macOS likes. Execute ```setup_var 0x263 0x2``` to change it. By default it's set to 0x1 which is 32MB. If you're planning to run dual (4k) screens you can set the pre-alloc higher than 64MB. Changing it to 0x3 (96MB) or 0x4 (128MB) could help. I've tested these larger pre-alloc sizes in a non-4k dual screen setup and while they work I did not notice any differences. There are [more sizes](https://github.com/zearp/optihack/blob/master/text/CFGLock_DVMT.md) to set here but 64MB should be fine for pretty much everyone.

> Please note: Changing the pre-alloc size is not really needed but highly recommended, if you don't want to do this you ***must*** apply the DMVT pre-alloc 32MB patch found in Hackintool to the config or else you will get a panic on boot.

## Enable EHCI hand-off
For usb to function as good as possible we need to enable handing off EHCx ports to the XHCI controller. We accomplish that by executing the following commands; ```setup_var 0x2 0x1``` and ```setup_var 0x144 0x1``` the first enables EHCI hand-off itself and the second one sets XHCI in normal enabled mode. It's needed because the default value called *Smart Auto* isn't so smart after all. So we simply enable it. Lastly we enable routing of the EHCx ports to XHCI ones. Execute ```setup_var 0x15A 0x2```. You can find these values [here](https://github.com/zearp/OptiHack/blob/master/text/XHCI_EHCI.md).

We're done. Exit the shell by executing the ```reboot``` command. 

<sub>Credit for DVMT/CFG Lock BIOS research goes to @JimLee1996 and his nice [write up](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) on this subject. Thanks to his work I was able to figure out how to enable EHCI hand-off. More might still come, there's a lot of interesting things that Dell is not exposing in the BIOS. Another big thanks goes to @datasone for providing [the modified Grub shell](https://github.com/datasone/grub-mod-setup_var/).</sub>

> Note: Resetting NVRAM or loading BIOS defaults does ***not*** clear these changes. The motherboard reset jumper may clear them, I have yet to test that. Make *sure* to double check you're entering the right values and nothing can go wrong.

## Installing macOS
You're now ready to install macOS. Boot from the installer again and select the *Install macOS* entry. Once you made it into the installer format the disks how you like them (use APFS for the macOS partition) and proceed installing. OpenCore should automagically select the right boot partition when reboots happen but pay attention when it does and make sure you keep booting from the internal disk until you end up on a working desktop. The name of the option will change from "Install macOS" to whatever name you gave the macOS partition. Any external boot options are clearly labeled in OpenCore.

If you run into any boot issues, check the [troubleshooting sections](https://desktop.dortania.ml/troubleshooting/troubleshooting.html) of the OpenCore vanilla guide. Big chance your problem is listed including a solution.

(It is also a good idea to [sanity check](https://opencore.slowgeek.com) your config file if you made a lot of changes to the config file. Select Haswell from the dropdown and OpenCore version 0.5.7. The santity checker will complain about certain things but those are needed for [FileVault2](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/security.html#filevault). Check the page to know which santiy check warnings you can ignore and which ones need attention. You can also ignore the warning about the *iMac14,3* not being right. Plus there is a bug in the santity checker where it complains about *ShrinkMemoryMap* not being there. It was replaced by *ProtectMemoryRegions* in 0.5.7.)

## Post install
Once macOS is installed, we'll install [EFI Agent](https://github.com/headkaze/EFI-Agent/releases) again and mount the EFI partition of the internal disk and the EFI on your installer. Copy the EFI folder from the installer to the internal disk. 

Yes, we're nearly done now.

If you don't have an ssd you can skip the next step, which is hopefully nobody.

We need to check if TRIM is enabled, it should be as we applied a patch in the config for this. But it is always good to verify and make sure. Open the *System Information* app and under SATA/SATA Express highlight your internal disk on the right and verify it says ```TRIM Support: Yes``` there.

If it says *NO*; close all open apps, open a terminal and execute ```sudo trimforce enable``` enter yes for both questions and once rebooted TRIM should be enabled. Don't forget to set your ethernet mac address correctly. This [guide](https://dortania.github.io/OpenCore-Desktop-Guide/post-services/iservices.md#fixing-en0) will, well, guide you.

We're pretty much done now, I suggest you do read all the following sections though, some may apply to you. Either way, have fun using macOS on your OptiHack!

### Sleep
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

Apple documents the hibernation modes as such;

* hibernatemode = 0 by default on desktops. The system will not back memory up to persistent storage. The system must wake from the contents of memory; the system will lose context on power loss. This is, historically, plain old sleep.
* hibernatemode = 3 by default on portables. The system will store a copy of memory to persistent storage (the disk), and will power memory during sleep. The system will wake from memory, unless a power loss forces it to restore from hibernate image.
* hibernatemode = 25 is only settable via pmset. The system will store a copy of memory to persistent storage (the disk), and will remove power to memory. The system will restore from disk image. If you want "hibernation" - slower sleeps, slower wakes, and better battery life, you should use this setting.

You can experiment with these.

### Power Management
This should be enabled and setup properly. You can run the [Intel Power Gadget](https://software.intel.com/en-us/articles/intel-power-gadget/) to check the temperatures and power usage. There is some CPU specific fine tuning that still can be done, but you're on your own for that journey. Dortania wrote detailed instructions in their [guide](https://dortania.github.io/OpenCore-Desktop-Guide/post-install/pm.html) on this subject. I urge you do follow it and put the finishing touches on your install.

> Note: I noticed without CPUFriend.kext my minimum cpu speed was 700mhz, in Windows it's set to 800mhz. My CPU is an exact match to the iMac 14,3 model so I'm not sure if CPUFriend is needed when you have an exact match. But you can still use it to tweak things. I'm not using it when the cpu matches and existing model. Less kexts feels good too and it doesn't surprise me Apple drives these cpu's at lower frequencies, it keeps the temps and noise down. Until you really start hammering it.

### dGPU
The current config disables any external graphics cards, this is to prevent issues. Once the iGPU is working properly you can start setting up external graphics. Don't forget to remove the ```-wegnoegpu``` and if the dGPU uses HDMI also the ```-igfxnohdmi``` boot flags.

### Undervolting
Currently testing an undervolted setup using [VoltageShift](https://github.com/sicreative/VoltageShift). Not anything too much (-75mv CPU and -25mv GPU). It doesn't really impact performance but does make things run cooler and it uses less energy.

Been running these settings for more than a week, so far so good. If you feel brave you can try it out. If you're going to use the [binary release](https://sitechprog.blogspot.com/2017/06/voltageshift.html) and not compile from source you'll need to fix them as explained [here](https://github.com/sicreative/VoltageShift/issues/34#issuecomment-576119169).

Once this config has proven itself stable I will update this section with a little guide on how to get it going.

### Keybinding/mapping
Merely installing [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements/releases) will make your keyboard work more like a Mac. F4 will open the Launchpad for example. You don't have to stick with those defaults. It is very easy to remap pretty much any key from any keyboard or mouse or other HID device. Be it bluetooth or wired. I'll add a how-to with some examples here in the future.

### Mapping the internal usb header for MT models
The MT models have an internal unused usb header. You will have create a new portmap if you intend to use this port (for bluetooth most likely). I didn't map it because I have SFF boxes only. The internal port is HS13. With that port mapped you'll be at the 15 ports limit that macOS imposes. See the section below on how to make a new usb portmap. For more info about usb portmaps please read [this](https://usb-map.gitbook.io/project/terms-of-endearment) great write-up.

### USB portmap
Due to our EHCI/XHCI uefi edits you can make the portmap without any renaming, USBInjectAll and the FakePCIID kexts. This makes mapping a lot easier and faster, lets start by mounting the EFI partition with [EFI Agent](https://github.com/headkaze/EFI-Agent/releases).

(If you're mapping the internal usb port make sure there is something connected to it before you start.)

1. Open your OpenCore config and set ```Kernel -> Add -> 6 -> USBPorts.kext``` to *disabled* and *enable* ```Kernel -> Quirks -> XhciPortLimit```
2. Reboot
3. Open Hackintool and go to the usb tab, select all ports listed and remove them, then click the refresh button
4. Plug a usb 2 device in every usb port
5. Plug a usb 3 device in every usb port
6. Remove anything not green, you should be left with 14 green ports (15 with internal usb port)
7. Make sure all the HSxx ports are set to usb 2 and SSPx ports are to usb 3 (if you're mapping the internal port (HS13) make sure it's set to internal)
8. Click on the export button and place the resulting USBPorts.kext in the OpenCore kexts folder (overwriting the existing one)
9. Open your OpenCore config and set ```Kernel -> Add -> 6 -> USBPorts.kext``` to *enabled* and *disable* ```Kernel -> Quirks -> XhciPortLimit```
10. Reboot

Verify the ports in Hackintool, go to the usb tab again, select all ports and delete them and click refresh again. It should now look like [this](https://github.com/zearp/OptiHack/blob/master/images/usb-portmap.png?raw=true), 14 or 15 ports showing all with the correct usb 2 or usb 3 labels. And HS13 showing as internal for those who have it.

Please don't use hubs to map the ports, they've produced some bad portmaps in my testing as they can take up multi ports at once. Use simple usb 2 and usb 3 devices to be safe.

> Note: Due to the enabling of EHCI hand-off and others the naming of usb 3 ports changes from SS0x to SSPx. If you're re-using a portmap be sure the ports (and addresses) match up. When in doubt, create a new portmap.

### SMBIOS
Unless you also have an Intel i5 4570S or similar it is recommended to change the ```NVRAM -> PlatformInfo -> Generic -> SystemProductName``` field in the config file. Find one that matches your CPU as close as possible. In my case that was *14,3*. When in doubt use *14,1* with only iGPU, *14,2* when used with dGPU and *15,1* for Haswell Refresh.

If you change this you will have to create a new USBPorts.kext as the kext is linked to product name. While things may appear to work fine after you changed the product name and keep using the kext for 14,3 it can lead to weird usb issues. To create a new portmap refer to the section above this one.

You will also have to generate a new pair of serials and system UUID as done [previously](#editing-configplist).

> Note: If everything is working fine for you then there is *no need* to change the iMac 14,3 default.

### RAID0 install and booting APFS
I've added 2x 250GB SSDs and currently running them in a [RAID0 setup](https://github.com/zearp/optihack/blob/master/images/diskutility.png?raw=true). The speeds have [doubled](https://github.com/zearp/optihack/blob/master/images/blackmagic.png?raw=true) and are close to the max the sata bus can handle. Cloning my existing install to the array was straight forward thanks to [this guys](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) awesome work.

So now, if we want to we can boot from RAID0 in Catalina. I think on Reddit he mentioned FileVault2 works too, but I haven't had any luck with that (yet). But booting from RAID0 works fine. I use one of the two disks to put the OpenCore EFI folder on and in the OpenCore picker it doesn't matter which one of the two macOS entries I pick. The BIOS automatically boots from the disk with the EFI folder. Putting the EFI folder on both disks would get very confusing very fast. Inside macOS the disks are sometimes swapped (disk0 becomes disk1 and disk1 becomes disk0) but that isn't an issue at all.

The article is easy to following along with and best to do a clean install with an installer made with the [Catalina Patcher](http://dosdude1.com/catalina/) as per his guide and afterwards import your old data *but* if you setup the array like he did you can clone your existing install to it. No need for a clean install. Just make sure to run ```sudo update_dyld_shared_cache -root /``` and ```diskutil apfs updatePreboot disk3s5``` after booting into your clone on the RAID array for the first time. And also run those two commands after updating macOS itself. Updates to macOS will claim they failed but they didn't. Just reboot, execute the previous commands and you'll be on your way.

If you have errors relating to security vault or similar when updating the Preboot volumes you can easily fix those by booting into a working macOS recovery partition or installer, open a terminal and run ```resetFileVaultPassword```. 

(This command can also fix the issue where FileVault2 can't be enabled.)

### Fan curve more like a Mac
These machines run pretty cool with the stock cooler and some new thermal paste. Idles around 30c and 35-40c under light loads. Even when running Geekbench 4 I didn't notice the fan ramp up at all. In the BIOS there's a fan curve defined. It regulates when and how fast the fan spins up. By default Dell has configured it like this;

* Normal idle fans, 1st gear till 55c.
* From 55c till 71c it runs in 2nd gear.
* From 71c till 95c it run in 3rd gear.

If it still didn't manage to get things cool again it will start going at the max. Press the little button on the back of the PSU when the machine is powered off but connected to hear how full blast sounds.

Now this is pretty reasonable and the stock fans are not loud. But if you want it to change to how Macs behave we change the values to these;

* Normal idle fans, 1st gear till 71c.
* From 71c till 87c it runs in 2nd gear.
* From 87c till 95c it run in 3rd gear.

And again if it didn't manage to cool things down it will go towards the max until its cooler, if thats fails thermal throttling starts (TCASE) and if that also fails to cool things down the computer shuts itself down. The Intel ark lists the TCASE for most Haswell cpu's around 72c. I've read on a few forums where people tested this and their Haswell cpu's didn't throttle around that temp but around 85-95c. It depends on the processor, BIOS and motherboard too. You can test this in Windows with AIDA64 to find out where your cpu starts to throttle.

What this Mac-like fan curve does in practise is that short bursts of heavy system load -- that could quickly increase the temps causing the fans to spin up -- not to spin the fans up as the temp will drop down once the burst is over. Resulting in a quieter machine. This is what Apple does and why their machines stay so silent up to around 85-90c when the plane takes off and thermal throttling sets in.

On laptops this can really make a big difference where unpacking a big compressed file won't cause the fans to spin up at all where normally they will go on and then off again. Often repeating that cycle. Same happens when you watch watch some YouTube or something. It is perfectly fine to leave the fans at lower speeds when doing some intensive work for a while. When I have to pick between watching some videos in silence with the cpu at 65c vs watching it with the fan going on and off I choose the former. Most machines can keep themselves within safe temps with low fan speeds.

All in all for this machine it is not really needed to adjust these but you *can*, and if you replace the stock fans with something else you might have to. If the fans work with how Dells PWM wants to drive them and thats after you converted their proprietary 5 pin fan connecter into a normal 4 pin one with a $0.99 eBay cable.

To get the above curve you change the following values in the modified Grub shell;

```
setup_var 0x1B8 0x47
setup_var 0x1B9 0x57
```

Refer to [this list](https://github.com/zearp/OptiHack/blob/master/text/FANS.md) to set your own temperatures. Be sure to always double check your settings and don't do anything too extreme or your computer will melt or create a blackhole. 

Thats it! Your silent OptiPlex will now be even more silent.

### SIP
Current SIP setting ready for undervolting; ```csr-active-config 03000000``` in OpenCore config, which does the same as running ```csrutil enable --without kext --without fs``` from recovery/installer. If you don't plan on undervolting you can set the ```csr-active-config``` value to ```00000000```. That is the most secure option. Verify the current SIP settings by running ```csrutil status```.

> Note: If changing the config alone doesn't seem to change the SIP settings, reset NVRAM and if thats not enough try entering setting them manually from recovery or the installer. Just run ```csrutil enable``` to turn it on.

### Security
* One thing you *must* do if not done already is to change the password of the Intel Management BIOS. Reboot the machine and press F12 to show the boot menu and select the Intel Management option. The default password is ```admin``` which is why it should be changed. The new password must have captials and special characters. While you're in there you can also completely disable remote management or configure it to your likes. If AMT/KVM is missing you will need to update that. More on that later. If you're having issues with this check if on the inside of your case is a sticker with a number. Only those with a ```1``` are equiped with fully fledged vPro options.

* If you're not going to undervolt please refer to the SIP section on how to set that back to its more secure default.

I personally suggest to also install an app that keeps track of apps connecting out. There are many options out there. Personally I use [TripMode](https://www.tripmode.ch). It is cheap and works great blocking apps that call home a bit too often or shouldn't be accessing the internet at all. I'm looking at you Apple!

> Moreover, further research by Landon Fuller, a software engineer and CEO of Plausible Labs indicates further trespasses on consumer privacy courtesy of OS X Yosemite, including the revelation that any time a user selects “About this Mac” the operating system contacts Apple with a unique analytics identifier whether or not the Apple user has selected to share analytics data of this kind with Apple. [(source)](https://trendblog.net/apples-new-os-x-yosemite-spying/)

The kind people over at [Objective-See](https://objective-see.com/products.html) even provide a free front-end to the build-in firewall called [LuLu](https://objective-see.com/products/lulu.html). They also have a lot of other very useful apps for the security curious amongst us.

### Toolbox
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
* [Monolingual](https://ingmarstein.github.io/Monolingual/) - Remove unused languages and architectures from apps. Yes I like it tidy!
* [Onyx](https://titanium-software.fr/en/onyx.html) - Always seem to come in handy at some point or another.
* [ProperTree](https://github.com/corpnewt/ProperTree) - OpenCore config editor and very useful for other plist editing too.
* [Transmission](https://transmissionbt.com/) - To download those Linux iso's. The "[nightly](https://build.transmissionbt.com/job/trunk-mac/)" builds have dark mode support.
* [VLC](https://www.videolan.org) - Plays any media Cog can't.

Then there's Homebrew and less known, but useful as you don't need the full Homebrew installed, Rudix.

* [Homebrew](https://www.videolan.org) - The best known and most complete package manager for macOS.
* [Rudix](https://rudix.org) - Less known, a lot less packages but they're all pre-compiled and don't require anything but the package themselves.

### Issues
* Sleep will not work properly with usb hubs, this includes some sata -> usb 3 dongles. Anything that acts as usb-hub will cause the machine to sleep and wake right up. I have no issues with sleep with usbb sticks and disks in normal usb 3 -> sata cases. They stay connected, even encrypted volumes and don't eject when the machine wakes up. Only devices that act as usb will cause issues.

When dealing with sleep issues make sure to test things with no usb devices connected other than keyboard/mouse. Check if legacy rom loading is *enabled* in the BIOS. Disable; Power Nap and wake for ehternet access in ```System Preferences -> Energy Saver```. It is by [design](https://support.apple.com/en-gb/HT201960) macOS wakes your machine up periodically when ```Wake for Ethernet network access``` is enabled.

If you have any issues where the machine wakes up right after falling asleep run ```log show --style syslog | fgrep "[powerd:sleepWake]"``` in a Terminal and find the wake reasons. If it says something about ```EHC1 EHC2/UserActivity Assertion``` or ```HID``` it means it was user input -- or a cat on the keyboard -- anything else with EHCx in it could point to some other usb device. There can also be another reason, find it in the log and try to fix it. It's part of the fun!

If you have any issues where the machine wakes up after falling asleep run ```log show --style syslog | fgrep "[powerd:sleepWake]"``` in a Terminal and find the *WakeReason*. If it says something about EHCx/XHCx then there's a usb hub or disk that acts as hub. If it says something about HID it means it got woken up by mouse or keyboard event. There can also be another reason, find it in the log and try to fix it. It's part of the fun!

When I was testing native hibernation with [HibernationFixup](https://github.com/acidanthera/HibernationFixup) the sleep logs were very helpful. They changed from ```Wake from Normal Sleep``` to ```Wake from Hibernate``` which would imply hibernation is working. Which is good because when set to mode ```25``` it writes the contents of the memory to disk instead of leaving it in there. Which means in case of a power outage you don't lose the contents of the memory. Waking up may become a bit slower though.

* Boot logs, to get (early) boot logs execute ```log show --predicate 'process == "kernel"' --style syslog --source --last boot``` right after a reboot to get them. A good way to find errors regarding kext loading and such.
* Cleaning logs, often it is nice to clean the logs when testing, execute ```sudo log erase --all``` to wipe them.

### Misc
Geekbench 4.
[Intel Power Gadget](https://software.intel.com/en-us/articles/intel-power-gadget/) whilst running Geekbench 4 and Geekbench 4 Compute:

![Load whilst running Geekbench 4](https://github.com/zearp/optihack/blob/master/images/gb.png)

![Load whilst running Geekbench 4 Compute](https://github.com/zearp/optihack/blob/master/images/gbc.png)

My i5-4570S scores an average around ~4100 single core and ~11750 multi core. Compute score around ~15775.

## Credits
* The [acidanthera](https://github.com/acidanthera/) team -- OpenCore(!), WhatEverGreen, Lilu, VirtualSMC, AppleALC, etc, etc. Amazing work.
* [Dortania](https://desktop.dortania.ml) -- Vanilla Desktop Guide, without this I wouldn't have gotten far.
* [headkaze](https://github.com/headkaze) -- Hackintool (an essential) and EFI-Agent is pretty sweet too.
* [corpnewt](https://github.com/corpnewt) -- Many essential tools, guides/documentation, simply great!
* And many, many more I forgot.

A deep bow to all of you!

## Notes
* Please use a DisplayPort to DisplayPort cable whenever possible. DP -> HDMI conversion often leads to issues. If you have to use such a converter or converting cable and run into issues you might benefit from removing the ```-igfxnohdmi``` boot flag and trying the DP -> HDMI and other HDMI related patches in Hackintool which can export/merge the patches into your config.
* The VRAM size is currently set to 2GB in the config, unlike the screenshot suggests. If you want to go to back to 1.5GB just remove the ```framebuffer-unifiedmem``` key from the config.
* I don't know why Dell would lie about the specs if not for up-selling other products but some stuff in their documentation is plain wrong. But the 7020 SFF/MT computer supports 32GB RAM, not 16GB. The on-board sata ports are *all* 6gbit/s. Dell claims one is 3gbit/s max. Bad Dell!

TODO:
* Make graphical picker default once it's more polished by setting *PickerMode* to External. All resources are in place. The upcoming release of OpenCore 0.5.8 will improve the rendering.
* Add disabling of MEBx and also [howto add KVM to MEBx](https://www.win-.com/t5079f39-Dell-is-there-a-chance-to-activate-AMT-for-KVM-remote-control.html). It's cool to have.
* FileVault2 testing, the config is ready for it.
* Test all audio in and outputs. Front audio works and back audio doesn't seem to fully work on this Optiplex 9020 layout.
* Wifi, I haven't received my Broadcom wifi/BT combo card yet.
* Bluetooth, currently using a [$2 BT 4.0 dongle](https://www.ebay.co.uk/itm/1PCS-Mini-USB-Bluetooth-V4-0-3Mbps-20M-Dongle-Dual-Mode-Wireless-Adapter-Device/324106977844) that surprisingly works out of the box. No handoff or other fancy features are supported but audio and mouse/keyboard work fine.
* More sensors.
* List of all my fav tools and apps

CAN'T DO:
* Audio over DisplayPort is only working on one port. The port closest to the PS/2 ports on 7020 SSF machines. This seems to be by design.
* SideCar. Tried the patches to enable it and it works but it's not smooth and iPad display glitches when the image is moving. Good as photo frame only :p
* DRM for stuff like Netflix and Amazon Prime [require a dGPU](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md). Bummer, but not a deal breaker for me personally. I do wonder why on my old MacBook I can play Prime Video in 1080p in Safari on a HD4000. Somehow DRM works fine there.

---

Average system cost around $99, for performance (almost) on par with the i3-9100 based 2018 Mac Mini ;-)

$70 Optiplex 7020 with i5/i7 and 4-16GB RAM and a disk you shouldn't use due to wear.

Don't overpay, there is a lot of supply. Don't use i3 models as the Intel Graphics is not properly supported and will give you issues, if you can get it cheap you can upgrade the CPU though.

$29 for a decent brand new 120-250GB entry level SSD. Hunt for bargains on Amazon and the likes.

> Don't forget to replace the thermal paste!

I don't plan on giving support but I am very open to optimising my config. Please open an issue if you think I messed something up or if something could be better. I'm here to learn and improve.
