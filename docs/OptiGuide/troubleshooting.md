---
sort: 8
---

# Troubleshooting
Some general troubleshooting and fixes for known issues.

## Resetting UEFI/BIOS completely
You have to remove the CMOS battery, remove the ```PSWD``` jumper then short the ```RTCRST``` jumper with it. Also remove the power chord and then hold the power button for 10-20 seconds (this drains all left over electricity so called ```flea power```). Now reconnect the power chord and wait for 30 seconds so the settings can be cleared. Now power up the machine. Everything should now be reset to stock values. Turn the machine off again and put the CMOS battery back in and set the jumpers back to how they were before. Now turn the machine back on and load BIOS defaults again for good measure. Don't forget to re-do the [UEFI edits](#disable-cfg-lock).

> Note: This is a mix of CMOS and jumper reset methods for maximum effect as just following the desktop guide on the Dell site didn't clear everything in my testing. Read more about it [here](https://www.dell.com/support/article/de-ch/sln284985/how-to-perform-a-bios-or-cmos-reset-and-or-clear-the-nvram-on-your-dell-system).

## Sleep issues
Sleep may not work properly with usb hubs or other usb devices connected this includes some sata <-> usb 3 dongles. Anything that acts as usb-hub could cause the machine to sleep and wake right up. I have no issues with sleep with usb sticks and disks in normal usb 3 -> sata cases. They stay connected, even encrypted volumes and don't eject when the machine wakes up. Try what works and what doesn't, YMMV.

When dealing with sleep issues make sure to test things with no usb devices connected other than keyboard/mouse. Check if legacy rom loading is *enabled* in the BIOS. Disable; Power Nap and wake for ethernet access in ```System Preferences -> Energy Saver```. It is by [design](https://support.apple.com/en-gb/HT201960) macOS wakes your machine up periodically when ```Wake for Ethernet network access``` is enabled. If you still get wake-ups that could be related to WOL (Wake on LAN) try disabling WOL in the BIOS itself as well.

If you have any issues where the machine wakes up right after falling asleep run ```log show --style syslog | fgrep "[powerd:sleepWake]"``` in a Terminal and find the wake reasons. If it says something about ```EHC1 EHC2/UserActivity Assertion``` or ```HID``` it means it was user input -- or a cat on the keyboard -- anything else with EHCx in it could point to some other usb device. There can also be another reason, find it in the log and try to fix it. It's part of the fun!

If your logs show something like ```DarkWake from Normal Sleep [CDNPB] : due to RTC/Maintenance``` it means Power Nap is enabled. These are scheduled wake-ups to make a backup or check mail. Disable Power Nap to get rid of them.

When I was testing native hibernation with [HibernationFixup](https://github.com/acidanthera/HibernationFixup) the sleep logs were very helpful. They changed from ```Wake from Normal Sleep``` to ```Wake from Hibernate``` which would imply hibernation is working. Which is good because when set to mode ```25``` it writes the contents of the memory to disk instead of leaving it in there. Which means in case of a power outage you don't lose the contents of the memory. Waking up may become a bit slower though.

To see what's preventing sleep run ```pmset -g assertions```.

## Can't wake system with bluetooth device
Waking the machine up with a bluetooth device likely only works with bluetooth usb dongles and pci-e ones that receive power over usb not just data. When the machien sleeps power is cut to lots of parts of the system, including the part that powers bluetooth/wifi combo cards. Dedicated usb dongles however will work fine for waking up the machine. These remain powered and bluetooth HID devices can wake the machine up.

## Wifi issues
This only applies to native supported hardware. Mainly Broadcom combo cards.

In many cases wireless speed and wireless channels might be lacking. This is due to the region setting. Even with the correct region set I couldn't find my own access point on some installs. The 5ghz channel I used was simply not seen. The fix is to set the region to ```#a``` which unlocks both 80Mhz channel width (needed for high speed wifi) and also all channels.

Applying this fix is easy but does require adding an additional kext.

## Screen stuff
There are some gotchas with DisplayPorts to keep in mind. They don't like hot-plugging in general. Hopefully that is all sorted but if you change the audio over DP/HDMI flags then hot-pluggig may result in crashes.

Conversion can also be tricky and dependand on a few factors. As a rule of thumb you always use DP -> DP connections if possible. That is the most stable setup and should work perfectly. When converting the DP signal to hdmi things can become tricky. I've had several peopel report that they solved issues with a different conversion cable/dongle. I can confirm this and I even have a cable that works fine with certain screens but doesn't work with others.

When installing it is best to use a DP -> DP connected screen and if not possible connect only 1 screen during the installation. It might be needed to only use the top or bottom connector. Most peopel shouldn't run into any issues. I only have a few screens to test with so there are always cases where it doesn't work properly and just requires some tinkering to get it right. macOS is just very picky about this so it may require some experimentation to get it sorted.

Another thing I found is that it seems impossible to use dual screens if they both use DP -> HDMI conversion. If one of the two screens is connected using the DP next to the VGA port a screen connected by DP -> HDMI conversion will work. I've not been able to test dual screen using DP. It should be better there and it could alos work fine depending on your screens/cables/dongles.

Screen stays off after wake? This is a known issue that cna happen on certain monitor/cable/machine combinations. Enabling ```force-online``` in the frame buffer section usally fixes that. To enable replace all the zero's with ```01000000``` for the ```force-online``` entry.

Then there is 4k, on paper each port can handle 4k @ 60hz. And it can do that without issues on Catalina and earlier by setting ```enable-hdmi20``` to ```01000000``` in the config file at ```DeviceProperties -> Add -> PciRoot(0x0)/Pci(0x2,0x0)```. On Big Sur and newer that option no longer works and the option that replaces it -- which is enabled -- seems not to work on all configurations. I don't have any 4k screens myself and can only test with headless-dummies. Which is far from ideal and uses conversion which is even less ideal. It should be possible to get it going but may require some testing and experimentation.

## OpenCore default entry
Sometimes OpenCore may want to keep on booting an entry by defauly you don't want it to use. To fix it select the entry yo uwant to be the default and instead of pressing enter you press control + enter to set it as the new default.

## Sidecar
Sidecar is glitchy, if you have a working fix please let me know. It could be impossilbe to fix as it might depend on bt h/w used + smbios and even cpu capabilities.

## Multiboot
Multibooting will be fine if you give each OS its own disk and use the BIOS boot menu (F12) to select your OS.

Booting any OS from the OpenCore menu will apply OpenCore settings/quirks and maybe some ACPI patches. This is generally not what you want.

If you must share disks for whatever reason, use Bootcamp to install Windows and then use OpenCore to boot into it.

Multiboot can give issues when operating systems share the same disks, or if an operating system is booted from the OpenCore menu instead of the BIOS boot menu

## Can't format disk in the installer
I've had this happen a few times. First click the little eject icons next to the disk thats fails to format, unmounting those partitons. Try again. If it still doesn't want to format exit the ```Disk Utility``` and open a ```Terminal``` instance from the ```Tools``` menu on top. Assuming you only have 1 disk and it can be wiped execute the following command: ```gpt destroy /dev/disk0``` then exit the terminal and try to format it again.
