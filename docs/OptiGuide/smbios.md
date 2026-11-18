---
sort: 3
---

# SMBIOS
For our platform (Haswell) there are a few choices. The best one is the one that suits your needs the best. Don't use an SMBIOS of a Mac that isn't on Haswell as it may lead to problems in many areas including power management.

- Macmini7,1 - Allows up to Monterey, iGPU runs at 750 MHz
- iMac15,1 - Allows up to Big Sur, iGPU runs at 200 MHz
- iMac14,3 - Allows up to Catalina, iGPU runs at 200 MHz

Functionality wise there is no difference, everything works. The higher iGPU base clock doesn't seem to impact temps or power draw. The Intel spec has the HD 4600 at 350 MHz base clock, I don't know why Apple has them higher on certain SMBIOS and lower on others. It might be possible to change this. There is also no performance impact, as once the iGPU receives some actual work it maxes out the clock speed very fast. The difference will be with update nags from Apple.

On any macOS version prior to Catalina there was a command you could run to stop receiving nags to upgrade to a new major release. This was removed in Catalina. We can use the SMBIOS to stop the update nags. For example if you don't plan on upgrading from Catalina use 14,3 and you will never receive upgrade nags to update to Big Sur. Apple usually provides security updates for the current version and the two previous versions. Catalina, Big Sur and Monterey have all reached the end of that window, so none of these SMBIOS choices gets you security updates anymore.

::: info Note
If you change SMBIOS you will need to edit the plist inside the USB portmap. See the [USB Map](./usbmap) section for more info and instructions.
:::
