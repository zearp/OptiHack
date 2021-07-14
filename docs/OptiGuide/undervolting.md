---
sort: 5
---

# Undervolting
Written for my NUC repo but also applies here.

Undervolting is a great way to to maximise performance, lower power consumption and reduce temperatures. The amount of undervolting you can apply depends on your luck in the [silicon lottery](https://en.wikipedia.org/wiki/Product_binning#Overclocking_and_core_unlocking). You'll have to lower the voltage step by step and test stability with [stress-ng](https://wiki.ubuntu.com/Kernel/Reference/stress-ng), [Prime95](https://www.mersenne.org/download/) or other tools like it.

Please read [this](https://github.com/sicreative/VoltageShift/blob/master/README.md) page for an explanation of all the options and what they do, I'm only focusing on the basics here. Also heed the warning displayed but realise this warning doesn't really apply when undervolting, but this tool can also do overvolting which could indeed be dangerous. The worst thing that can happen when undervolting is data loss due to system freeze. So only do this after [making a backup](https://github.com/zearp/OptiHack/blob/master/text/CLONE_IT.md).

Installation is easy, I've compiled a version that will load from EFI so there's no need to disable SIP or allow loading of unsigned kexts. Simply download [this](https://github.com/zearp/VoltageShift/raw/master/VoltageShift-EFI.zip) and place the kext file inside the kext folder of OpenCore in your EFI and place the ```voltageshift``` binary file in your home directory or somewhere else where it is not in your way. Don't forget to add to the kext to your config file too. Using ProperTree's snapshot function makes it easy to do this quickly. Once this is done reboot and verify the kext is loaded by running ```kextstat | grep VoltageShift``` in a terminal.

Once you confirmed the kext is loaded you can start undervolting. In the terminal go to the folder where you placed the ```voltageshift``` binary and run the following command ```./voltageshift info``` if all is well it will return the current configuration, in my case;

```
zearp@nuc ~ % ./voltageshift info
------------------------------------------------------
   VoltageShift Info Tool
------------------------------------------------------
CPU voltage offset: 0mv
GPU voltage offset: 0mv
CPU Cache voltage offset: 0mv
System Agency offset: 0mv
Analogy I/O: 0mv
OC mailbox cmd failed
Digital I/O: 0mv
CPU BaseFreq: 2300, CPU MaxFreq(1/2/4): 3800/3800/3600 (mhz)  PL1: 35W PL2: 65W 
CPU Freq: 0.8ghz, Voltage: 0.6144v, Power:pkg 3.53w /core 0.80w,Temp: 94 c
```

Take note of your PL1 and PL2 numbers. Close all open apps and start out with only applying some light undervolting to CPU and CPU Cache by running ```./voltageshift offset -25 0 -25``` and you'll see a message like this;

```
zearp@nuc ~ % ./voltageshift offset -25 0 -25                                       
--------------------------------------------------------------------------
VoltageShift offset Tool
--------------------------------------------------------------------------
Before CPU voltageoffset: 0mv
Before GPU voltageoffset: 0mv
Before CPU Cache: 0mv
--------------------------------------------------------------------------
After CPU voltageoffset: -25mv
After GPU voltageoffset: 0mv
After CPU Cache: -25mv
--------------------------------------------------------------------------
```

Now run a stress test for 5-10 minutes and if it doesn't freeze you can try to go lower. Repeat this until the system freezes and then use the last voltage that didn't cause a freeze. In my testing I've found that applying an undervolt of -75 to -125 on the CPU/CPU Cache works fine, but it will differ on every system. If you don't want to spend time finding the perfect numbers you can apply -50 for both, it should be stable and still help a bit. Once you found the perfect offset you can have this apply at boot by running; ```sudo ./voltageshift buildlaunchd -75 0 -75 0 0 0 1 35 65 0 120```.

Please note that the util will exit with an error, this is normal as we modified it to run from EFI. It will execute some commands that fail which causes it to display an error. To verify the launch deamon has been created you can check if it exits:
```
zearp@nuc ~ % file /Library/LaunchDaemons/com.sicreative.VoltageShift.plist
/Library/LaunchDaemons/com.sicreative.VoltageShift.plist: XML document text, ASCII text, with very long lines
```

You will need to change -75/-75 to your magic numbers and change 35/65 to whatever PL1/PL2 values were when running the info command. PL1/PL2 values change depending on BIOS settings. I've changed mine in the BIOS to 35/65 since my cooling solution is better than stock. Lowering it below 28watts may decrease temps but also performance. The tdp of the i5 is 28 watts according to Intel and I think the stock values are 30/50. This setting regulates the amount of power the NUC is allowed to consume when running normally and in turbo mode. Change 120 to whatever interval you wish to have the script check if undervoltage has been applied. Sleep can reset the settings, with it set to 120 minutes you'll be without an undervolt after waking from sleep for a max of 2 hours. Change to your liking or set to 0 to disable. Refer to the [documentation](https://github.com/sicreative/VoltageShift/blob/master/README.md) for an explanation about every single option. For example the ```1``` is to keep turbo enabled. A zero means the offset isn't changed.

If you want your stock cooled NUC to be more silent with a little performance penalty you can disable turbo and set PL1/PL2 both to 28 watts. This will result in a much cooler and quieter machine but with some performance loss. With these setting and a custom fan curve you can get your NUC to be silent pretty much all the time unless you really push it. It can pay off to play around with these to find the perfect balance between noise and performance.

There are a lot more things you can do but as a start just undervolting CPU/CPU Cache is enough. In my testing undervolting GPU didn't make any difference but maybe on yours it does help. Experiment and see what works best for you.

> Tip: Use Intel Power Gadet and/or HWMonitor to check current voltages and temperatures.
