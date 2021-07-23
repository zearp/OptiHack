---
sort: 14
---
# RAID
The last macOS version that fully supports installing and booting from RAID arrays is High Sierra.

If thats too old you can still get it to work but it will require some effort and sometimes things can break. Make sure you have backups.

The following only applies to Catalina. Changes in Big Sur and newer will cause updates to fail or worse. I haven't experimented with RAID on those for that reason alone. The filesystem is fully sealed in those versions and may break and/or require a different setup method. FileVault does not work realiable in my experience but some reported it can be made to work.

> Credit: All thanks to [this guys](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) awesome work!

## Existing install

To boot from RAID we first need to boot from our backup and setup the RAID array. I'm assuming the only 2 disks in the system are for the RAID array, they will be erased!

Once booted from your backup on an external ssd/usb stick open a terminal and run the following commands:

```
diskutil unmountDisk disk0
diskutil unmountDisk disk1

gpt destroy /dev/disk0
gpt destroy /dev/disk1

diskutil appleRAID create stripe Storage JHFS+ disk0 disk1

diskutil unmountDisk disk2
gpt create disk2
gpt add -t hfs disk2
```

Now you can exit the terminal and start ```Disk Utility``` in there format the new array to APFS. With the array setup we then clone our backup to the new RAID array.

Once that is done mount 1 EFI partition of one of the disks in the array and copy your EFI folder to it. Only do this to one of the disks, else it will get confusing very fast when you want to update or select a boot disk.

You should now be able to boot from the array. The first time you boot in there, and every time you installed macOS updated run the following commands: ```sudo update_dyld_shared_cache -root /``` and ```diskutil apfs updatePreboot disk3s5```.

If you see any errors relating to security vault or similar when updating the Preboot volume you can fix those by booting into macOS recovery or an installer, open a terminal and run ```resetFileVaultPassword```. 

## Clean install
You will need to create your installed with [Catalina Patcher](http://dosdude1.com/catalina/) and follow along with [the guide](https://lesniakrafal.com/install-mac-os-catalina-raid-0/) made by the person who made this method possible.
