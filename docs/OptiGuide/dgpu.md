---
sort: 6
---

# dGPU
In order to get your dGPU to work a few steps must be followed and a few caveats must be observed. By default the config disables any dGPU as many are simply not compatible and would cause pancis and crashes.

The first step is to make sure your card is supported. Please refer to [this](https://dortania.github.io/GPU-Buyers-Guide/) great write-up coverering that subject. If your card is not compatible you can leave things as they are, remove the card or disable the card via [ACPI](https://dortania.github.io/Getting-Started-With-ACPI/Desktops/desktop-disable.html). The latter two will save some power. If your card is compatible proceed with the following steps:

1. Remove or disable (all zeros) the ```disable-external-gpu``` option in the config
2. If your dGPU has HDMI ports also remove or disable the ```disable-hdmi-patches``` option
3. If you are going to use a screen on both iGPU and dGPU you can reboot and see if it works
4. If you are only going to usethe dGPU to connect a screen or screens put the iGPU in compute mode by setting the ```platform-id``` field to ```04001204```
5. Verify compute mode on system tab in Hackintool; ```Metal Headless``` should be ```yes``` and ```VDA Decoder``` should show as ```Fully Supported```

## DRM
If you need DRM you need to add some bootflags, which ones depend on your macOS version and dGPU brand, refer to [this](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.Chart.md) chart for more information. Currently Catalina is best supported when it comes to DRM. Any newer will require some tweaking as explained in the chart. Of course there is also a page on DRM by Dortania [here](https://dortania.github.io/OpenCore-Post-Install/universal/drm.html) with even more information.


## Caveats
Sometimes it is needed to toggle the dGPU/external display options in the BIOS. I haven't tested this myself but some people needed to set it to ```Auto``` or disable it to get their setup to work. This may depend on bradn and how many screens you use, if you use iGPU+dGPU or just dGPU etc. Some experimentation might be needed before things works as you need them to.
