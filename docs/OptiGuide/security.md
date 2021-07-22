---
sort: 13
---
# Security

## FileVault
macOS comes with full disk encryption support, the config has been setup to allow for this to be enabled out of the box. Enabling full disk encryption is something I would do any device that supports it and has personal data on it. It also makes the boot process a lot prettier and streamlines imho.

## Intel remote management/vPro
One thing you *must* do if not done already is to change the password of the Intel Management BIOS. This kind of remote management even works when the system is turned off but connected to power.

Reboot the machine and press F12 to show the boot menu and select the Intel Management option. The default password is ```admin``` which is why it should be changed. The new password must have capitals and special characters. While you're in there you can also completely disable remote management or configure it to your liking. If AMT/KVM is missing you will need to update that. If you're having issues with this check if on the inside of your case is a sticker with a number. Only those with a ```1``` are equipped with fully fledged vPro options.

To update MEBx and enable KVM/AMT if it isn't available in your BIOS please read [this](https://github.com/zearp/OptiHack/blob/master/text/BIOS_STUFF.md) page. It also deals with updating [microcodes](https://en.wikipedia.org/wiki/Microcode). Which can enhance security as well.

## Apps calling home
I would suggest to install an app that keeps track of outgoing connections. There are many options out there. Personally I use [TripMode](https://www.tripmode.ch). It is cheap and works great blocking apps that call home a bit too often or shouldn't be accessing the internet at all. I'm looking at you Apple!

> Moreover, further research by Landon Fuller, a software engineer and CEO of Plausible Labs indicates further trespasses on consumer privacy courtesy of OS X Yosemite, including the revelation that any time a user selects “About this Mac” the operating system contacts Apple with a unique analytics identifier whether or not the Apple user has selected to share analytics data of this kind with Apple. [(source)](https://trendblog.net/apples-new-os-x-yosemite-spying/)

The kind people over at [Objective-See](https://objective-see.com/products.html) even provide a free front-end to the build-in firewall called [LuLu](https://objective-see.com/products/lulu.html). They also have a lot of other very useful apps for the privacy and security curious amongst us.
