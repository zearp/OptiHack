# Live Toolbox

I'm not sure what to call this but it is possible to make a small ~600MB disk image that can be booted with some custom tools. Essentialy it's a modified base image that the installer uses.

Not all apps will work, but for some it could be what they're looking for. Faster to boot than a complete macOS and with enough functionality to fix things or clone a system.

It is very easy to make one, all you need to get started is a macOS installer downloaded from the App Store.

1. In your Applications folder right click on ```Install macOS Catalina``` and select show contents.
2. Browse to ```Contents -> SharedSupport``` and double click ```BaseSystem.dmg```.
3. Open ```Disk Utility``` and richt click on the ```macOS Base System``` entry and select ```Image from macOS Base System```
4. Change the ```format``` option to say ```read/write``` and save it somewhere.
5. Eject the currently mounted ```macOS Base System``` and double click on the image you created to mount it.
6. Rename the mounted image to something more suiting.

We're now ready to add and remove stuff. It is just a matter of copying the apps and editing a plist so they show up either in the greeter or on the pull down menu.

Open up you freshly renamed image and browse to the ```System -> Installation -> CDIS``` then right click on ```macOS Utilities``` and select show package contents.

Browse to ```Contents -> Resources``` scroll all the way down till you see ```Utilities.plist```. Open it up in a good plist editor.

Here there are 2 main sections; ```Buttons```, which is whats showing on the greeter menu and ```Menu``` which is of course the drop down menu.

Adding apps is a bit like adding kexsts to OpenCore manually. You give it the correct path to the app and path to the executable inside the app.

So for example, say I wanted to add EFI Agent to my Live Toolbox. First I copy the app itself into the Applications folder and then add a new entry for it in the greeter or menu or both. I only want it to be in the menu:
```
BundlePath /Applications/EFI Agent.app
Path /Applications/EFI Agent.app/Contents/MacOS/EFI Agent
TitleKey EFI Agent
```
Rinse and repeat for each app you want to add to it. Not all apps will work or work properly. You'll have to test and play around.

Removing the macOS Install entry for exmaple makes sense to be removed because we're only using the base image. There is no installer data so it will fail if you try.

Once you're happy with your new apps and maybe you've remove some of the default options it is time to create another image.

Again open up ```Disk Utility``` and highlight your renamed image and right click on it saving it to a read/only or compressed image this time.

You now have 2 images, one master in read/write and an output that is read only or compressed. Restoring read/write images is more of a headache than creating a 2nd image used to restore.

Now instert you destination usb stick and format it, don't use APFS but HFS. Make sure it uses GUID partition scheme. Once its formatted right click the name you gave it in the list and select restore.

> Note: You want to select the partition *not* the disk as that will wipe our EFI. For those who've enabled *show all devices* in Disk Utility.

In the restore window click on image and browse to the read only/compressed image you created and let it restore.

Finally we mount the EFI partitions of both our internal and of the new usb stick and copy the internal disks EFO to the usb one.

Now it will be bootable, try it out and see if everything works.

To update/change things around simply mount the read/write version of the image, make the changes and create a new red only/compressed image from it and restore again.

Personally, I find these kind of lightweight bootable stick very useful. Specially as rescue stick with some tools, or simply to boot from to my internal disk if I messed up my EFI folder again.

Good luck!
