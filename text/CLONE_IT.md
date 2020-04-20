# Cloning

First off all, this is not a backup solution but also it is a backup solution. A rule of thumb when it comes to backups is that doesn't exist in 3 different places one of which in another location is not really backed up.

But, for our purposes -- hackingtoshing -- it is pretty much essential to have a clone of your working system. Not only does it allow you to use it's EFI to boot to your internal disk in case the EFI got messed on there, but in a case of drive failure you can boot into your clone and resume work as if nothing happens and/or clone it to a new drive.

There are several ways to clone your system, while not free the most used options are:
* [Carbon Copy Cloner](https://bombich.com) - More fancy, should be realiable but I don't like it. Too bloated for me.
* [SuperDuper!](https://www.shirt-pocket.com/SuperDuper/SuperDuperDescription.html) - Minimalistic, stable and reliable.

As a minimalist I am a fan of the latter. It is also the only of the two that has a fully functional free version whereas Carbon Copy Cloner only has a 30 day trial.

You can also use something like [Clonezilla](https://clonezilla.org) and others like it. I will be sticking with SuperDuper! for this little guide.

The free version of SuperDuper! is only limited when it comes to updating existing clones and some advanced options. So updating a clone is goign to take just as long as creating it. This shouldn't be an issue if you keep your data on another partition or disk.

First we'll format your backup medium. Superduper! will erase it agian by default but I'm not sure if it will create a missing EFI partition. So to be safe I format it manually before a fresh clone. I suggest using a ssd in a usb 3 case or a (very) fast usb 3 stick. Anything too slow will be frustrating to use once you booted into it.

Format it APFS with a GUID partition layout. Open SuperDuper! and in the main window on the left select your macOS disk and on the right select your destination disk. Click copy now, enter password, etc and you're on your way.

![Screenshot](https://github.com/zearp/OptiHack/blob/master/images/superduper.png)
Once this is done mount the EFI partitions of your your internal and destination disk and copy the EFI folder from the internal disk to the destination so it can boot.

> Note: Do test if your backup works. Don't assume it will work.

Thats all!
