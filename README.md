# PSA 1: New guide can be found here: https://zearp.github.io/OptiHack/

## PSA 2: From the 24th of June the default SMBIOS has been changed. This means that when you update you will either have generate new serials and before doing so logout from the iMessage and Facetime apps as well as iCloud itself. Or you can of course change the SMBIOS back to iMac15,1 or iMac14,3, if you do so you'll also need edit the plist inside USBPorts.kext to match the new model. This change is done so we can install Monterey.

![Montedell](/images/Monterey.png?raw=true)

(no longer used, sections below are being migrated to the new guide)

* [RAID0 install and booting APFS](#raid0-install-and-booting-apfs)
* [Security](#security)

## RAID0 install and booting APFS
I've added 2x 250GB SSDs and currently running them in a [RAID0 setup](https://github.com/zearp/optihack/blob/master/images/diskutility.png?raw=true). The speeds have [doubled](https://github.com/zearp/optihack/blob/master/images/blackmagic.png?raw=true) and are close to the max the sata bus can handle. Cloning my existing install to the array was straight forward thanks to [this guys](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) awesome work.

So now, if we want to we can boot from RAID0 in Catalina. I think on Reddit he mentioned FileVault2 works too, but I haven't had any luck with that (yet). But booting from RAID0 works fine. I use one of the two disks to put the OpenCore EFI folder on and in the OpenCore picker it doesn't matter which one of the two macOS entries I pick. The BIOS automatically boots from the disk with the EFI folder. Putting the EFI folder on both disks would get very confusing very fast. Inside macOS the disks are sometimes swapped (disk0 becomes disk1 and disk1 becomes disk0) but that isn't an issue at all.

The article is easy to following along with and best to do a clean install with an installer made with the [Catalina Patcher](http://dosdude1.com/catalina/) as per his guide and afterwards import your old data *but* if you setup the array like he did you can clone your existing install to it. No need for a clean install. Just make sure to run ```sudo update_dyld_shared_cache -root /``` and ```diskutil apfs updatePreboot disk3s5``` after booting into your clone on the RAID array for the first time. And also run those two commands after updating macOS itself. Updates to macOS will claim they failed but they didn't. Just reboot, execute the previous commands and you'll be on your way.

If you have errors relating to security vault or similar when updating the Preboot volumes you can easily fix those by booting into a working macOS recovery partition or installer, open a terminal and run ```resetFileVaultPassword```. 

(This command can also fix the issue where FileVault2 can't be enabled.)

## Security
* One thing you *must* do if not done already is to change the password of the Intel Management BIOS. Reboot the machine and press F12 to show the boot menu and select the Intel Management option. The default password is ```admin``` which is why it should be changed. The new password must have capitals and special characters. While you're in there you can also completely disable remote management or configure it to your liking. If AMT/KVM is missing you will need to update that. If you're having issues with this check if on the inside of your case is a sticker with a number. Only those with a ```1``` are equipped with fully fledged vPro options.

To update MEBx and enable KVM/AMT if it isn't available in your BIOS please read [this](https://github.com/zearp/OptiHack/blob/master/text/BIOS_STUFF.md) page. It also deals with updating [microcodes](https://en.wikipedia.org/wiki/Microcode). Which can enhance security as well.

I personally suggest to also install an app that keeps track of apps connecting out. There are many options out there. Personally I use [TripMode](https://www.tripmode.ch). It is cheap and works great blocking apps that call home a bit too often or shouldn't be accessing the internet at all. I'm looking at you Apple!

> Moreover, further research by Landon Fuller, a software engineer and CEO of Plausible Labs indicates further trespasses on consumer privacy courtesy of OS X Yosemite, including the revelation that any time a user selects “About this Mac” the operating system contacts Apple with a unique analytics identifier whether or not the Apple user has selected to share analytics data of this kind with Apple. [(source)](https://trendblog.net/apples-new-os-x-yosemite-spying/)

The kind people over at [Objective-See](https://objective-see.com/products.html) even provide a free front-end to the build-in firewall called [LuLu](https://objective-see.com/products/lulu.html). They also have a lot of other very useful apps for the security curious amongst us.
