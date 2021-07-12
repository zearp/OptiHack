Extracted from the A18 BIOS, which is the same as the A25 BIOS for 9020 models. It is however a fun learning experience to verify these yourself by downloading the A18 or A25 BIOS and extracting it yourself. This [guide](https://github.com/JimLee1996/Hackintosh_OptiPlex_9020) helped me a lot.

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

Stolen mem cheat sheet:
```
00 00 00 01 = 0x01000000 = 16 MB
00 00 00 02 = 0x02000000 = 32 MB
00 00 00 04 = 0x04000000 = 64 MB
00 00 00 06 = 0x06000000 = 96 MB
00 00 00 08 = 0x08000000 = 128 MB
00 00 00 10 = 0x10000000 = 256 MB
00 00 00 18 = 0x18000000 = 384 MB
00 00 00 20 = 0x20000000 = 512 MB
00 00 00 30 = 0x30000000 = 768 MB
00 00 00 40 = 0x40000000 = 1024 MB
00 00 00 60 = 0x60000000 = 1536 MB
00 00 00 80 = 0x80000000 = 2048 MB
```
