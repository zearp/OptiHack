---
sort: 2
---

## Updating the EFI
Updating is easy, copy your MLB/ROM/etc values into a text file and unless you made any other changes rename your EFI folder to EFI.old then download and copy the latest release from repo and copy it to your EFI partition. Edit the config file and change the serials and such and that should be be all.

If you changed SMBIOS you also need to copy your USBPorts.kext or edit the plist inside again so the models match to your SMBIOS. Reboot and in case anything goes wrong you can boot up a backup or Linux live distro, mount the EFI partition and delete the EFI folder and rename EFI.old to EFI and reboot again.

> Note: Make sure you move over any changes you made, if they include kexts and such use the snapshot commands in ProperTree to add them back in the new config.

