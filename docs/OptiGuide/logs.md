---
sort: 7
---

# Logs

Logs are very important, not only when you run into troubles but also to see if there are things requiring attention. There are several ways to access logs. On of them is the ```Console`` app.

## Console app
This app is a frondend to many system logs and error reports. It allows to search and live moniter and even allows you to see logs on your iPhone or iPad. It is an easy to use app with a nice graphical interface.

## Terminal app
On the command line we have the ```log``` command. It allows you to do pretty much anything and dispay logs in text. It has options to show more/less details and also colour the output (style option).

For example:

```log show --predicate 'process == "kernel"' --style compact --source --last boot``` 

Will show you all kernel messages since and including the last boot. Running this command right after rebooting will give a usable boot log. You can replace the process with something else like ```bluetoothd``` only shows events from the bluetooth deamon. The ```--style``` options configures how and how much is shown, this flag is optional.

Sometimes it can be helpful to clear all the logs as there can be a lot of entries to read if you trying to diagnose issues. Clearing the logs right before doing your testing will make sure you don't have to read too many entries that are not relevant. To wipe all the logs run ```sudo log erase --all``` you can also erase logs partially.

For more inforation about the options and many more options run ```man log``` forthe manual. Pretty much all terminal commands have a little manual page you can access by running ```man name-of-command``. 

One more thing worth to mention is using the ```grep``` command together with the log command. It will alloes you to print only messages that contain a certain keyword. For example if you want to see all log entries containing the word "firmware" you'd run something like: ```log show --predicate 'process == "kernel"' --source --last boot | grep -i firmware```. The ```-i``` option will ignore the case.

## Verbose boot

While this isn't technically a log file it is logging and might get annoying once you've setup your machine. To disable this remove the ```-v``` flag from ```boot-args``` in the OpenCore config. It is on by default so you can see whats going on when installing and makes it easies to spot problems/report issues.

## Debug logging

Not really needed unless need verbose logging of OpenCore itself and kexts. I will expand this section later, for now please refer to the Dortania guide:
https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/debug.html
