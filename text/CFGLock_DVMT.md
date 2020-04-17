Extracted from the A18 BIOS, which is the same as the A25 BIOS for 9020 models. It is however a fun learning experience to verify these yourself by downloading the A18 or A25 BIOS and extracting it yourself. This [guide](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) helped me a lot.

The 9020 BIOS also has raid functionaility in it. ~~An add-on I would like to try and port to 7020.~~ Tried some flashing with [UBU](https://www.win-raid.com/t154f16-Tool-Guide-News-quot-UEFI-BIOS-Updater-quot-UBU.html) and learned a lot but nont daring to do much until I learn how to recover from a bad flash hah!

CFG Lock:

```
0x473C4 		One Of: CFG lock, VarStoreInfo (VarOffset/VarName): 0xDA2, VarStore: 0x2, QuestionId: 0x51, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 39 01 3A 01 51 00 02 00 A2 0D 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x473EA 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E F6 00 00 00 00 00 00 00 00 00 00 00}
0x473F8 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E F5 00 30 00 01 00 00 00 00 00 00 00}
0x47406 		End One Of {29 02}
```

DVMT pre-alloc sizes for iGPU:

```
0x4F2DB                 One Of: DVMT Pre-Allocated, VarStoreInfo (VarOffset/VarName): 0x263, VarStore: 0x2, QuestionId: 0x218, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A$
0x4F301                         One Of Option: 32M, Value (8 bit): 0x1 (default) {09 0E 3D 04 30 00 01 00 00 00 00 00 00 00}
0x4F30F                         One Of Option: 64M, Value (8 bit): 0x2 {09 0E 3E 04 00 00 02 00 00 00 00 00 00 00}
0x4F31D                         One Of Option: 96M, Value (8 bit): 0x3 {09 0E 3F 04 00 00 03 00 00 00 00 00 00 00}
0x4F32B                         One Of Option: 128M, Value (8 bit): 0x4 {09 0E 40 04 00 00 04 00 00 00 00 00 00 00}
0x4F339                         One Of Option: 160M, Value (8 bit): 0x5 {09 0E 41 04 00 00 05 00 00 00 00 00 00 00}
0x4F347                         One Of Option: 192M, Value (8 bit): 0x6 {09 0E 42 04 00 00 06 00 00 00 00 00 00 00}
0x4F355                         One Of Option: 224M, Value (8 bit): 0x7 {09 0E 43 04 00 00 07 00 00 00 00 00 00 00}
0x4F363                         One Of Option: 256M, Value (8 bit): 0x8 {09 0E 44 04 00 00 08 00 00 00 00 00 00 00}
0x4F371                         One Of Option: 288M, Value (8 bit): 0x9 {09 0E 45 04 00 00 09 00 00 00 00 00 00 00}
0x4F37F                         One Of Option: 320M, Value (8 bit): 0xA {09 0E 46 04 00 00 0A 00 00 00 00 00 00 00}
0x4F38D                         One Of Option: 352M, Value (8 bit): 0xB {09 0E 47 04 00 00 0B 00 00 00 00 00 00 00}
0x4F39B                         One Of Option: 384M, Value (8 bit): 0xC {09 0E 48 04 00 00 0C 00 00 00 00 00 00 00}
0x4F3A9                         One Of Option: 416M, Value (8 bit): 0xD {09 0E 49 04 00 00 0D 00 00 00 00 00 00 00}
0x4F3B7                         One Of Option: 448M, Value (8 bit): 0xE {09 0E 4A 04 00 00 0E 00 00 00 00 00 00 00}
0x4F3C5                         One Of Option: 480M, Value (8 bit): 0xF {09 0E 4B 04 00 00 0F 00 00 00 00 00 00 00}
0x4F3D3                         One Of Option: 512M, Value (8 bit): 0x10 {09 0E 4C 04 00 00 10 00 00 00 00 00 00 00}
0x4F3E1                         One Of Option: 1024M, Value (8 bit): 0x11 {09 0E 4D 04 00 00 11 00 00 00 00 00 00 00}
0x4F3EF                 End One Of {29 02}
```

Other iGPU related stuff of interest:

```
0x4F443 		One Of: Gfx Low Power Mode, VarStoreInfo (VarOffset/VarName): 0x209, VarStore: 0x2, QuestionId: 0x21A, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 AB 04 AC 04 1A 02 02 00 09 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4F469 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x4F477 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x4F485 		End One Of {29 02}
```

```
0x4F289 		One Of: Aperture Size, VarStoreInfo (VarOffset/VarName): 0x20D, VarStore: 0x2, QuestionId: 0x217, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 C2 04 C3 04 17 02 02 00 0D 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4F2AF 			One Of Option: 128MB, Value (8 bit): 0x1 {09 0E C4 04 00 00 01 00 00 00 00 00 00 00}
0x4F2BD 			One Of Option: 256MB, Value (8 bit): 0x2 (default) {09 0E C5 04 30 00 02 00 00 00 00 00 00 00}
0x4F2CB 			One Of Option: 512MB, Value (8 bit): 0x3 {09 0E C6 04 00 00 03 00 00 00 00 00 00 00}
0x4F2D9 		End One Of {29 02}
```

**Warning!** The next one might disable the iGPU when set to disabled, without a dGPU you would need to reset these values to the default and in my testing I found that resetting the bios or NVRAM does *not* reset them back to defaults. The reset/clear jumper on the motherboard might but I have not tested that. Best not to mess with this one haha. I put it here for documentation only.

```
0x4F1F3 		One Of: Internal Graphics, VarStoreInfo (VarOffset/VarName): 0x278, VarStore: 0x2, QuestionId: 0x215, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 CB 03 CC 03 15 02 02 00 78 02 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4F219 			One Of Option: Auto, Value (8 bit): 0x2 (default) {09 0E C0 03 30 00 02 00 00 00 00 00 00 00}
0x4F227 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x4F235 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E C2 03 00 00 01 00 00 00 00 00 00 00}
0x4F243 		End One Of {29 02}
```
