---
sort: 1
---

# Installation
Before we can install macOS we need to make our installer. There are two options here.

1. Recovery based installer; can be make on Windows/Linux and macOS
2. Full off-line installer; requires a working macOS install

I'm not going to cover the first option because I personally have not used it. Guides to make a recovery based installer on [Windows](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/winblows-install.html) and [Linux](https://dortania.github.io/OpenCore-Install-Guide/installer-guide/linux-install.html).

The main difference between the installers is that one will require a working internet connection and needs to download about 12GB of data. Since my internet connection sucks and I often do clean installs I prefer having a full installer. Both with work with the repo's EFI.

If you don't have a working macOS and also have no access to a real Mac to make the installer I suggest setting up a VM/KVM using one of the many one-click solutions. You can have a working Catalina up and running within an hour. It might not be super fast but for the purpose of making an installer it works great.

## Making the installer
Now you have access to a working macOS we're going to download the macOS installer. You can use the App Store for it but you can also use a tool that doesn't require you to sign in with your Apple ID. I like to use [GibMacOS](https://github.com/corpnewt/gibMacOS) but there are other tools out there too. Once you got the macOS installer installed you should have a new application called ```Install macOS Monterey``` or whatever version you downloaded. We can now make the installer with the following steps:

Insert a usb stick and open the ```Disk Utility``` app. In the top menu go to ```view``` and select ```Show All Devices```. Now select your usb stick in the left sidebar. Select the device not any partitions it may have. Click the erase button and format it as ```Mac OS Extended (Journaled)``` with a ```GUID``` scheme.

Open the ```Terminal``` app and type ```cd``` follow by a space and then drag the macOS installer app into the terminal window and press enter.

Next run the following command: ```sudo ./Contents/Resources/createinstallmedia --volume /Volumes/Untitled --nointeraction``` -- it will now create the installer

While thats doing its thing lets download the following:

- [Latest EFI](https://github.com/zearp/OptiHack/releases)
- [EFI Agent](https://github.com/headkaze/EFI-Agent/releases)
- [ProperTree](https://github.com/corpnewt/ProperTree/archive/refs/heads/master.zip)
- [GenSMBIOS](https://github.com/corpnewt/GenSMBIOS/archive/refs/heads/master.zip)

Once the ```createinstallmedia``` script is done you can exit the terminal by typing ```exit```. We're now ready to copy the EFI to the installer.

To do so, simply start EFI Agent and use the menu to mount the EFI partition on the usb installer. A new disk called EFI will appear on the desktop. If not check your ```Finder``` settings and check if hard disks and external disks are enabled to show on the desktop. By default macOS will hide hard disks.

Unzip the EFI you downloaded from the repo, drag the EFI folder thats inside the zip file to the EFI icon. This will copy the EFI folder to the installer. Keyboard warriors can highlight the downloaded EFI folder and press control + c and then open the EFI folder on the installer and press control + v.

With the EFI folder copied to the installers EFI partition we are now ready for the next step; setting up the config file.

## Making choices
The easy part is now done and it's time for a slightly less easy part.

Before we can start editing we have to make some choices, don't worry you can always change these and adjust them to your needs.

The first choice is software. This will determine the SMBIOS you will need to use. We have 3 choices here, they influence Apple updates and other things we won't get into now.

1. ```iMac14,3``` -- Supports up to Catalina, no update nags for Big Sur and beyond
2. ```iMac15,1``` -- Supports up to Big Sur, no update nags for Monterey and beyond
3. ```Macmini7,1``` -- Supports up to Monterey, might get update nags for what comes after it (unlikely)

An important thing to remember is that when you change SMBIOS you must also change some other things, please refer to the dedicated SMBIOS section for more information.

Depending on your needs you will know which SMBIOS suits you. We can now generate some serials.

> Note: Monterey is currently in beta and will be buggy and might break, it also requires ```SecureBootModel``` to be set to ```Disabled```.

### Generate serials
For this we will need to unpack the ```master.zip``` for GenSMBIOS that we downloaded earlier, Safari may have already unpacked it. Inside its folder you will find a few scrips. Windows users can use the ```.bat``` script (right click and run as admin) we will use the ```.command``` scripts.

Double click ```GenSMBIOS.command``` and accept any warnings, if you can't allow it right click on it and select ```Open```. It may even be needed to do that twice. Apple is watching out for us but these scripts are harmless.

You will be presented with a menu, we need to enter ```3``` and press enter then enter ```Macmini7,1``` (or the SMBIOS of your choosing). This serial will only be used for the installer. We will setup a "proper" serial set post install. Leave this window open for now, we will copy/paste from it later.

### Editing config.plist
We can now edit the config file itself.

Unpack (if needed) the ```master.zip``` file we got for ProperTree earlier. Inside are ```.bat``` and ```.command``` scripts. The same as before applies here, we will double click ```ProperTree.command``` to start the config file editor. Once it's open select ```File``` in the top bar menu and open ```config.plist``` thats inside the ```EFI/OC``` folder on the installers EFI partition we mounted earlier. With the config file now open you will see a lot of entries. They are divided into sections (ACPI/Booter/DeviceProperties/etc).

Scroll down until you reach the ```PlatformInfo``` section. This is where we will paste in the serials that are waiting in the ```GenSMBIOS``` window that should still be open. Edit the following fields:
```
PlatformInfo -> Generic -> MLB
PlatformInfo -> Generic -> SystemProductName
PlatformInfo -> Generic -> SystemSerialNumber
PlatformInfo -> Generic -> SystemUUID
```
They are left empty in the config so they are easy to spot. If you already know the mac address of your ethernet connection you can fill that in too, it goes in ```PlatformInfo -> Generic -> ROM```. If you don't know that is ok, we will fix that post install.

### Choices continued
The next two choices are both audio related. First of the audio layout. This changes how the in/outputs behave and depending on your preference you may want to change form the default layout. You can find the layout in the config ```DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x1B,0x0) -> layout-id```. The default of ```17``` will give you access to all ports but you have to select them manually in ```System Preferences```. If you don't care about the back ports you can use layout id ```15``` which has auto sending for headphones and uses the internal speaker by default. Other compatible layouts are ```13``` and ```16```. I haven't tried those, there may not be any difference compared to ```15```. Layout id ```17``` was custom made for the 7020/9020.

Secondly if you want to use audio over DisplayPort or HDMI you must change some flags to enable it. This can break hot-plugging of screens and cause a panic or crash when you do. It can also cause problems for dual screens. For more about that please check the ```Troubleshooting``` section.

To enable change the last block of digits with all zero's for both ```framebuffer-conX-alldata``` entries found at ```DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x2,0x0)```.

They are left empty in the config so they are easy to spot. If you already know the mac address of your ethernet connection you can fill that in too, it goes in ```PlatformInfo -> Generic -> ROM```. If you don't know that is ok, we will fix that post install.

### Wrapping up
Now close ```ProperTree``` and save the config file when it asks to. Finally drag Efi Agent to the installer itself, not the EFI partition. The installer itself should then show 2 apps when opened, the installer app and EFI Agent. This saves us from having to download it again post install, also copy the GenSMBIOS and ProperTree folder if you plan on using iCloud or an Apple ID.

With that done the installer is now ready to be used.

## First steps
Before we can boot into the installer itself we have some other things to do.

### BIOS
Make sure you BIOS is up to date (update if needed) and enter the BIOS on your Optiplex.

My BIOS settings are simple: load factory defaults and set ```General -> Boot Sequence -> Boot List Option``` to UEFI. Those with a 9020 model will need to change RAID to AHCI mode after loading defaults. Double check if loading of legacy roms is enabled. Sleep won't work properly without it.

### Clear NVRAM
Now that the BIOS is sorted boot from the installer and in the OpenCore menu (picker) select clear NVRAM from the options. This will reboot the machine, smash F12 to get to the BIOS boot menu and select the installer again.

### UEFI Edits
This time we select ```modGRUBShell.efi``` from the list and press enter. You will end up in a grub shell thats been modified to allow us to set UEFI variables. We will set some options Dell has hidden in the BIOS. If you're into unlocking the BIOS you could do that and make the options appear in the real BIOS. This is far too time consuming so we'll do it the "easy" way. We will need to change some settings that benefit not just macOS.

#### Disable CFG Lock
To disable CFG Lock you can either use a [quirk](https://dortania.github.io/OpenCore-Post-Install/misc/msr-lock.html) in OpenCore or disable it properly. We will disable it. Entering ```setup_var 0xDA2 0x0``` will disable CFG Lock. To revert simply execute the command again but replace 0x0 with 0x1. This also applies to the other changes we need to make here. In the files with values I link to you can also find the default setting of each in case you want to revert to stock.

#### Set DVMT pre-alloc to 64MB
Next up we need to set the DVMT pre-alloc to 64MB, which macOS likes. Enter ```setup_var 0x263 0x2``` to change it. By default it's set to 0x1 which is 32MB. There are [more sizes](https://github.com/zearp/optihack/blob/master/text/CFGLock_DVMT.md) to set here; if you change it to anything else than 64MB you will need to change the ```framebuffer-stolenmem``` in the config.plist file as it needs to match. For example changing it to 92MB you'll have to set ```framebuffer-stolenmem``` to ```00000006```. I've tested larger pre-alloc sizes in a non-4k dual screen setup and while they work I did not notice any differences. Setting it to 64MB should be fine for pretty much everyone though.

#### USB Fixes
For usb to function as good as possible we need to enable handing off EHCx ports to the XHCI controller. We accomplish that by entering the following commands; ```setup_var 0x2 0x1``` and ```setup_var 0x144 0x1``` the first enables EHCI hand-off itself and the second one sets XHCI in normal enabled mode. It's needed because the default value called *Smart Auto* isn't so smart after all. So we simply enable it.

Lastly we enable routing of the EHCx ports to XHCI ones and disable EHCx all together. Only legacy OS would need it. Enter ```setup_var 0x15A 0x2``` to enable the routing then enter ```setup_var 0x146 0x0``` and ```setup_var 0x147 0x0``` to disable the EHCx ports. You can find these values [here](https://github.com/zearp/OptiHack/blob/master/text/XHCI_EHCI.md).

We're done. Exit the shell by running the ```reboot``` command, smash F12 again and once again boot from the installer but this time select the ```Install macOS Monterey``` option, or whatever applies. Al lot of text will scroll by and after a while you should end up in a graphical interface with a minimal menu.

## Install macOS
Now that you've made it into the installer itself we're ready to install macOS.

From the menu select ```Disk Utility``` and once again in ```View``` select show all devices. This time select your internal disk (not any of its partitions) and click the erase button. The format should be ```APFS``` and the scheme ```GUID```. If nothing happens when you try to format it you may have to nuke the gpt on the disk. Check the ```Troubleshooting``` section when you run into this.

With a freshly formatted disk you can close the ```Disk Utility``` app which should put you back into the main menu. You can guess what to do from there. Select install, select destination and wait for it to do its thing. You can open the log window and set it to show all messages if you're curious as to what is going on. There will be plenty of errors and warnings but unlikely to be harmful, and in case something does go wrong you will instantly know why.

Once it's done copying itself to the internal disk -- which is what it was doing -- it will automatically reboot. We don't have to smash F12 anymore as the installer is the only bootable device.

When you see the OpenCore picker again check if it has selected the correct entry. The correct entry should be your internal disk. Either named how you formatted it or sometimes ```Mackintosh HD``` or something similar. Can't really miss it and usually OpenCore auto-selects the entry.

From here on out we want to make sure this happens every time the installer reboots. Depending on which macOS version you install there can be quite some reboots.

Keep an eye on the picker menu after each reboot until you end up on the welcome screen. Just reboot if you end up in the installer menu again. If you've set the audio layout to ```15``` you may hear some voices coming out of the internal speaker if you let it sit idle. Don't let it startle you.

Important to note is that Big Sur and newer seal the filesystem during install. This can take a long time. If you see any ```CS_RUNTIME``` messages on screen and think installed stalled/crashed, it is most likely sealing the file system. Don't reboot, give it some time.

When you made it into the welcome screen follow the steps and setup your user account then once you're on the desktop continue with the post install section.

## Post install
Now that macOS is installed and you made it to your brand new desktop it is time to finalise things. First copy Efi Agent from the installer to the desktop or into your ```Applications```. Start it like before and mouth the EFI partition of both the installer and your internal disk. They will have different icons. If you don't see them appear check the ```Finder``` setting again like before.

Open the EFI folder on your internal disk and remove any folders present. There should be an Apple folder but doesn't always have to be there. Then drag the EFI folder from the installer to the EFI partition of the internal disk and unmount the EFI partition of the installer. Leave the internal EFI partition mounted as we may need to make some more config edits.

Reboot and see if you can boot from the internal disk. If not boot with the installer again and check the EFI partition of the internal disk and see if it matches that of the installer.

> Note: After installation macOS might be slow and laggy, this is due to macOS running all kinds of post install things, including making an index of all the files. Spotlight. You can disable this to improve performance a bit if you're not gonna use it.

### Sorting out sleep
While macOS is busy we can put the final touches on the install. Open up the ```Terminal``` app and run the following commands to sort out sleep:

```
sudo pmset standby 0
sudo pmset autopoweroff 0 
sudo pmset proximitywake 0
sudo pmset powernap 0 
sudo pmset tcpkeepalive 0
sudo pmset womp 0
sudo pmset hibernatemode 0
```

The first two and last need to be 0 the rest can be left on if you want.

- Proximity wake can wake your machine when an iDevice is near
- Power Nap will wake up the system from time to time to check mail, make Time Machine backups, etc, etc
- Disabling TCP keep alive has resolved periodic wake events after setting up iCloud, just disabling Find My wasn't enough.
- Womp is wake on lan, which is disabled in the BIOS as it (going by other people's experience) might cause issues. I never use WOL, if you do use WOL please try enabling it in the BIOS and leave this setting on, the issues might have been due to bugs that haven been solved by now. Let me know if it works or not.
- Hibernate is likely not to work properly. I did some experimenting with it but it's not really worth perusing. See ```Troubleshooting``` section for some more info on it.

### Sorting out the serials
If you're not using iCloud or an Apple ID on your build you can skip this. Anyone else can open the GenSMBIOS folder from the installer to the desktop or open it directly on the installer.

Also open up your config.plist file inside ```OC/EFI``` on the still mounted internal EFI partition. Scroll down to where you put the serials earlier.

Double click on on your serial (SystemSerialNumber) and press control + c then open up [this](https://checkcoverage.apple.com) website in Safari. Paste your serial in and fill out the captcha and examine the resulting page.

The results can vary, we're looking for a result that says: ```We're sorry, but this serial number isn't valid. Please check your information and try again.```

If your current serial returns that message you won't have to do anything except for fixing the ethernet mac address, see below.

If you get any other message returned you will need to generate new serials like we did before with ```GenSMBIOS```. Follow the same steps as before but this time add a number after the SMBIOS so it generates more than one for you to try.

Once you get the required return message you can move to the final step.

### Fix mac address
We can take two routes here, use your real mac address or make one up with an Apple vendor bit. I've not had any issues using my real mac address and iCloud but if you do using a made up Apple mac address might help.

There are many ways of getting the real mac address, the easiest way to run ```ifconfig en0 | grep ether``` in a terminal instance and copy the address that looks like 11:aa:22:bb:cc and paste it without the semicolons into the ROM section in the config file at ```PlatformInfo -> Generic```.

For the second route I suggest reading the [Dortania write-up](https://dortania.github.io/OpenCore-Post-Install/universal/iservices.html) about it. I've not needed this myself so I would only suggest following it if you have issues with iCloud/Apple ID.

## The End
That's it. If all is well you can now reboot your machine and boot without the need of the installer. Have fun setting up your machine and installing apps. I do suggest making a bootable backup including your EFI to an external disk or fast usb stick. An easy how-to can be found in the sidebar.
