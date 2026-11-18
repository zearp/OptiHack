---
sort: 8
---

# Troubleshooting
Some general troubleshooting and fixes for known issues.

## Resetting UEFI/BIOS completely
You have to remove the CMOS battery, remove the ```PSWD``` jumper then short the ```RTCRST``` jumper with it. Also remove the power cord and then hold the power button for 10-20 seconds (this drains all left over electricity so called ```flea power```). Now reconnect the power cord and wait for 30 seconds so the settings can be cleared. Now power up the machine. Everything should now be reset to stock values. Turn the machine off again and put the CMOS battery back in and set the jumpers back to how they were before. Now turn the machine back on and load BIOS defaults again for good measure. Don't forget to re-do the [UEFI edits](./installation#uefi-edits).

::: info Note
This is a mix of CMOS and jumper reset methods for maximum effect as just following the desktop guide on the Dell site didn't clear everything in my testing. Read more about it [here](https://www.dell.com/support/article/de-ch/sln284985/how-to-perform-a-bios-or-cmos-reset-and-or-clear-the-nvram-on-your-dell-system).
:::

## Sleep issues
Sleep may not work properly with USB hubs or other USB devices connected; this includes some SATA <-> USB 3 dongles. Anything that acts as USB-hub could cause the machine to sleep and wake right up. I have no issues with sleep with USB sticks and disks in normal USB 3 -> SATA cases. They stay connected, even encrypted volumes and don't eject when the machine wakes up. Try what works and what doesn't, YMMV.

When dealing with sleep issues make sure to test things with no USB devices connected other than keyboard/mouse. Check if legacy rom loading is *enabled* in the BIOS. Disable Power Nap and wake for ethernet access in ```System Preferences -> Energy Saver```. It is by [design](https://support.apple.com/guide/mac-help/share-your-mac-resources-when-its-in-sleep-mh27905/mac) macOS wakes your machine up periodically when ```Wake for Ethernet network access``` is enabled. If you still get wake-ups that could be related to WOL (Wake on LAN) try disabling WOL in the BIOS itself as well.

If you have any issues where the machine wakes up right after falling asleep run ```log show --style syslog | fgrep "[powerd:sleepWake]"``` in a Terminal and find the wake reasons. If it says something about ```EHC1 EHC2/UserActivity Assertion``` or ```HID``` it means it was user input -- or a cat on the keyboard -- anything else with EHCx in it could point to some other USB device. There can also be another reason, find it in the log and try to fix it. It's part of the fun!

If your logs show something like ```DarkWake from Normal Sleep [CDNPB] : due to RTC/Maintenance``` it means Power Nap is enabled. These are scheduled wake-ups to make a backup or check mail. Disable Power Nap to get rid of them.

When I was testing native hibernation with [HibernationFixup](https://github.com/acidanthera/HibernationFixup) the sleep logs were very helpful. They changed from ```Wake from Normal Sleep``` to ```Wake from Hibernate``` which would imply hibernation is working. Which is good because when set to mode ```25``` it writes the contents of the memory to disk instead of leaving it in there. Which means in case of a power outage you don't lose the contents of the memory. Waking up may become a bit slower though.

To see what's preventing sleep run ```pmset -g assertions```.

## Can't wake system with Bluetooth device
Waking the machine up with a Bluetooth device likely only works with Bluetooth USB dongles and PCIe ones that receive power over USB not just data. When the machine sleeps power is cut to lots of parts of the system, including the part that powers Bluetooth/Wi-Fi combo cards. Dedicated USB dongles however will work fine for waking up the machine. These remain powered and Bluetooth HID devices can wake the machine up.

## Wi-Fi issues
This only applies to native supported hardware. Mainly Broadcom combo cards.

In many cases wireless speed and wireless channels might be lacking. This is due to the region setting. Even with the correct region set I couldn't find my own access point on some installs. The 5 GHz channel I used was simply not seen. The fix is to set the region to ```#a``` which unlocks both 80 MHz channel width (needed for high speed Wi-Fi) and also all channels.

Applying this fix is easy but does require adding an additional kext: add [AirportBrcmFixup](https://github.com/acidanthera/AirportBrcmFixup) to your EFI and config, then add ```brcmfx-country=#a``` to ```boot-args```.

## Screen stuff
There are some gotchas with DisplayPorts to keep in mind. They don't like hot-plugging in general. Hopefully that is all sorted but if you change the audio over DP/HDMI flags then hot-plugging may result in crashes.

Conversion can also be tricky and dependent on a few factors. As a rule of thumb you always use DP -> DP connections if possible. That is the most stable setup and should work perfectly. When converting the DP signal to HDMI things can become tricky. I've had several people report that they solved issues with a different conversion cable/dongle. I can confirm this and I even have a cable that works fine with certain screens but doesn't work with others.

When installing it is best to use a DP -> DP connected screen and if not possible connect only 1 screen during the installation. It might be needed to only use the top or bottom connector. Most people shouldn't run into any issues. I only have a few screens to test with so there are always cases where it doesn't work properly and just requires some tinkering to get it right. macOS is just very picky about this so it may require some experimentation to get it sorted.

Another thing I found is that it seems impossible to use dual screens if they both use DP -> HDMI conversion. If one of the two screens is connected using the DP next to the VGA port a screen connected by DP -> HDMI conversion will work. I've not been able to test dual screen using DP. It should be better there and it could also work fine depending on your screens/cables/dongles.

Screen stays off after wake? This is a known issue that can happen on certain monitor/cable/machine combinations. Enabling ```force-online``` in the framebuffer section usually fixes that. To enable replace all the zeros with ```01000000``` for the ```force-online``` entry.

Then there is 4K, on paper each port can handle 4K @ 60 Hz. And it can do that without issues on Catalina and earlier by setting ```enable-hdmi20``` to ```01000000``` in the config file at ```DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x2,0x0)```. On Big Sur and newer that option no longer works and the option that replaces it -- which is enabled -- seems not to work on all configurations. I don't have any 4K screens myself and can only test with headless-dummies. Which is far from ideal and uses conversion which is even less ideal. It should be possible to get it going but may require some testing and experimentation.

## OpenCore default entry
Sometimes OpenCore may want to keep on booting an entry by default that you don't want it to use. To fix it select the entry you want to be the default and instead of pressing enter you press control + enter to set it as the new default.

## Sidecar
Sidecar is glitchy, if you have a working fix please let me know. It could be impossible to fix as it might depend on Bluetooth hardware used + smbios and even CPU capabilities.

## Multiboot
Multibooting will be fine if you give each OS its own disk and use the BIOS boot menu (F12) to select your OS.

Booting any OS from the OpenCore menu will apply OpenCore settings/quirks and maybe some ACPI patches. This is generally not what you want.

If you must share disks for whatever reason, use Boot Camp to install Windows and then use OpenCore to boot into it.

Multiboot can give issues when operating systems share the same disks, or if an operating system is booted from the OpenCore menu instead of the BIOS boot menu.

## Can't format disk in the installer
I've had this happen a few times. First click the little eject icons next to the disk that fails to format, unmounting those partitions. Try again. If it still doesn't want to format exit the ```Disk Utility``` and open a ```Terminal``` instance from the ```Tools``` menu on top. Assuming you only have 1 disk and it can be wiped execute the following command: ```gpt destroy /dev/disk0``` then exit the terminal and try to format it again.

## Error logging in to iCloud after changing SMBIOS
After updating SMBIOS serials (e.g., from iMac15,1 -> Macmini7,1) you may get the following error when trying to log back into iCloud: ```iCloud account is already signed in to iCloud. To use this Apple ID as your primary iCloud account, delete it from Internet Accounts and sign in again.```

To fix:
1. Open Terminal
2. Type ```defaults delete MobileMeAccounts```
3. Press enter
4. Log into iCloud thru Internet Accounts in settings. The already signed in message should be gone once you sign in.

## Keybinding/mapping
Sometimes keys won't work as expected, you can remap some keys inside macOS in a few places, in ```System Preferences -> Keyboard``` you can click on the ```Modifier Keys...``` button to change some and there is more on the ```Shortcuts``` tab. If that isn't enough try one of the following:

[Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements/releases) -- just installing it will make your keyboard work more like a Mac. For example F4 will open the Launchpad. You don't have to stick with those defaults. It is very easy to remap pretty much any key from any keyboard or mouse or other HID device. Be it Bluetooth or wired. You can even create profiles per device if you want.

It comes with a handy event viewer util that can easily help you remap pretty much anything to anything else. I mainly use it to remap keys on Bluetooth keyboards to do things like opening Launchpad and sorting out their led/capslock.
 
If that isn't enough you can create a full custom keymap with [Ukelele](http://software.sil.org/ukelele/).

## Can't enable FileVault
This can happen rarely and might be impossible to fix without a clean install but sometimes it can be fixed by booting into recovery and run ```resetFileVaultPassword``` in the terminal and change (or use the same) password.

## Errors regarding snapshots/permissions when creating clones/backups
The answer is the same as for FileVault.
