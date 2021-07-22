---
sort: 12
---

# Fans
These machines run pretty cool with the stock cooler and some new thermal paste. Idles around 30c and 35-40c under light loads. Even when running Geekbench 4 I didn't notice the fan ramp up at all. In the BIOS there's a fan curve defined. It regulates when and how fast the fan spins up. By default Dell has configured it like this;

* Normal idle fans, 1st gear till 55c
* From 55c till 71c it runs in 2nd gear
* From 71c till 95c it run at full blast

Now this is pretty reasonable and the stock fans are not loud. But if you want it to change to how Macs behave we change the values to these;

* Normal idle fans, 1st gear till 71c
* From 71c till 87c it runs in 2nd gear
* From 87c till 95c it run at full blast

Triggering full blast mode manually wasn't possible for me using Windows fan control software. But it can ramp up the fans quite a lot.

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

> Note: We've only changed the tempo trigger points for the fans not how fast they spin. Fans speed modifications are more tricky as they depend on the capabilities of the fan you're driving and as far as the stock fans go they can't really spin much slower with the default settings. Only the system fan can be tuned a bit slower but its not audible.
