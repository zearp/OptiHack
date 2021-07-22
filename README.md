## PSA 1: New guide can be found here: https://zearp.github.io/OptiHack/ -- it is still a WIP but the important bits are done.

## PSA 2: From the 24th of June the default SMBIOS has been changed. This means that when you update you will either have generate new serials and before doing so logout from the iMessage and Facetime apps as well as iCloud itself. Or you can of course change the SMBIOS back to iMac15,1 or iMac14,3, if you do so you'll also need edit the plist inside USBPorts.kext to match the new model. Please read the [SMBIOS](#smbios) section for more info. This change is done so we can install Monterey.

[Montedell](/images/Monterey.png?raw=true)

## Index
(no longer used, sections below are being migrated to the new guide)

* [Graphical boot](#graphical-boot)
* [Keybinding/mapping](#keybindingmapping)
* [RAID0 install and booting APFS](#raid0-install-and-booting-apfs)
* [Fan curve more like a Mac](#fan-curve-more-like-a-mac)
* [SIP](#sip)
* [Security](#security)

## Graphical boot
1. Download needed drivers and resources and copy them
2. Edit the config; disable verbose boot, enable boot chime, enable graphical picker, hide picker unless hotkey is held
3. Reboot and test

First we need to download [this](https://github.com/acidanthera/OcBinaryData/archive/master.zip) and also download the [latest OpenCore release](https://github.com/acidanthera/OpenCorePkg/releases). Extract the *Resources* folder from the *master.zip* file and place it in EFI/OC. From the OpenCore release archive we need to copy *AudioDxe.efi* and *OpenCanopy.efi* from EFI/OC/Drivers to our EFI/OC/Drivers.

Secondly we need to edit the config, the last two entries need to be added.
```
Misc -> Boot -> HideAuxiliary -> True
Misc -> Boot -> PickerMode -> External
Misc -> Boot -> ShowPicker -> False
Misc -> Boot -> TakeoffDelay -> 1000
UEFI -> Audio -> AudioSupport -> True
UEFI -> Audio -> PlayChime -> True
UEFI -> Audio -> VolumeAmplifier -> 100
UEFI -> Drivers -> AudioDxe.efi
UEFI -> Drivers -> OpenCanopy.efi
```
Lastly remove the *-v* boot flag found at ```NVRAM -> Add -> 7C436110-AB2A-4BBB-A880-FE41995C9F82 -> boot-args```. That should be it. Reboot and test!

Notes:
- To save some space you can remove everything from the audio resources folder except *OCEFIAudio_VoiceOver_Boot.wav*, which provides the chime sound. All the other audio files are only needed if you use voice-over.
- Set ShowPicker to True if you always want to see the picker
- Hold down OPT or ESC while booting to show the picker menu (pressing escape will also refresh the drives so it might flash if you spam the escape key)
- Other Mac key combo's should also work but haven't tested them, opt+control+p+r should reset NVRAM, command+v should boot in verbose mode, etc
- TakeoffDelay sets the time in microseconds before actual boot begins, for my keyboard a setting of 1000 worked well. Setting this to a higher number might be needed if you can't get the picker to show
- The boot chime will play over the internal speaker, to change this set ```UEFI -> Audio -> AudioOut``` to reflect the output you wish to use. It's not possible to play the chime over DP/HDMI. But it is possible to select another output if the internal speaker is not your cup of tea. I've not yet checked which outputs are available. When I do I will update this section. Until then please refer to [this](https://dortania.github.io/OpenCore-Post-Install/cosmetic/gui.html#setting-up-boot-chime-with-audiodxe) guide to sort out the outputs.

## Keybinding/mapping
Merely installing [Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements/releases) will make your keyboard work more like a Mac. F4 will open the Launchpad for example. You don't have to stick with those defaults. It is very easy to remap pretty much any key from any keyboard or mouse or other HID device. Be it bluetooth or wired. You can create profiles per device if you want. For creating a full custom keymap check out [Ukelele](http://software.sil.org/ukelele/).

## RAID0 install and booting APFS
I've added 2x 250GB SSDs and currently running them in a [RAID0 setup](https://github.com/zearp/optihack/blob/master/images/diskutility.png?raw=true). The speeds have [doubled](https://github.com/zearp/optihack/blob/master/images/blackmagic.png?raw=true) and are close to the max the sata bus can handle. Cloning my existing install to the array was straight forward thanks to [this guys](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) awesome work.

So now, if we want to we can boot from RAID0 in Catalina. I think on Reddit he mentioned FileVault2 works too, but I haven't had any luck with that (yet). But booting from RAID0 works fine. I use one of the two disks to put the OpenCore EFI folder on and in the OpenCore picker it doesn't matter which one of the two macOS entries I pick. The BIOS automatically boots from the disk with the EFI folder. Putting the EFI folder on both disks would get very confusing very fast. Inside macOS the disks are sometimes swapped (disk0 becomes disk1 and disk1 becomes disk0) but that isn't an issue at all.

The article is easy to following along with and best to do a clean install with an installer made with the [Catalina Patcher](http://dosdude1.com/catalina/) as per his guide and afterwards import your old data *but* if you setup the array like he did you can clone your existing install to it. No need for a clean install. Just make sure to run ```sudo update_dyld_shared_cache -root /``` and ```diskutil apfs updatePreboot disk3s5``` after booting into your clone on the RAID array for the first time. And also run those two commands after updating macOS itself. Updates to macOS will claim they failed but they didn't. Just reboot, execute the previous commands and you'll be on your way.

If you have errors relating to security vault or similar when updating the Preboot volumes you can easily fix those by booting into a working macOS recovery partition or installer, open a terminal and run ```resetFileVaultPassword```. 

(This command can also fix the issue where FileVault2 can't be enabled.)

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

## Security
* One thing you *must* do if not done already is to change the password of the Intel Management BIOS. Reboot the machine and press F12 to show the boot menu and select the Intel Management option. The default password is ```admin``` which is why it should be changed. The new password must have capitals and special characters. While you're in there you can also completely disable remote management or configure it to your liking. If AMT/KVM is missing you will need to update that. If you're having issues with this check if on the inside of your case is a sticker with a number. Only those with a ```1``` are equipped with fully fledged vPro options.

To update MEBx and enable KVM/AMT if it isn't available in your BIOS please read [this](https://github.com/zearp/OptiHack/blob/master/text/BIOS_STUFF.md) page. It also deals with updating [microcodes](https://en.wikipedia.org/wiki/Microcode). Which can enhance security as well.

* If you're not going to undervolt please refer to the SIP section on how to set that back to its more secure default.

I personally suggest to also install an app that keeps track of apps connecting out. There are many options out there. Personally I use [TripMode](https://www.tripmode.ch). It is cheap and works great blocking apps that call home a bit too often or shouldn't be accessing the internet at all. I'm looking at you Apple!

> Moreover, further research by Landon Fuller, a software engineer and CEO of Plausible Labs indicates further trespasses on consumer privacy courtesy of OS X Yosemite, including the revelation that any time a user selects “About this Mac” the operating system contacts Apple with a unique analytics identifier whether or not the Apple user has selected to share analytics data of this kind with Apple. [(source)](https://trendblog.net/apples-new-os-x-yosemite-spying/)

The kind people over at [Objective-See](https://objective-see.com/products.html) even provide a free front-end to the build-in firewall called [LuLu](https://objective-see.com/products/lulu.html). They also have a lot of other very useful apps for the security curious amongst us.

**FileVault2**:
This works out of the box. You can enable it in the System Preferences app. If you're having any issues please double check the settings using [this](https://dortania.github.io/OpenCore-Post-Install/universal/security.html) guide.

### Windows + macOS sharing a disk
Windows updates can mess up your EFI partition by overwriting ```BOOTx64.efi```, this will only be a problem if you share 1 disk/EFI with both Windows and macOS. Ideally install each OS on its own disk, unless no other option. To prevent Windows Update from messing up your EFI you have to download the latest OpenCore release and copy the Bootstrap folder found in EFI/OC to your EFI/OC folder. Then change ```Misc -> Security -> BootProtect``` from None to Bootstrap. This should protect OpenCore in the event a Windows update decides to mess with files on your EFI partition. 
