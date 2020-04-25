There's a lot of interesting XHCI/EHCI related stuff in the BIOS that can be enabled/tweaked with a modified Grub shell. Here's some snippets.

```
0x53D06 		End One Of {29 02}
0x53D08 		One Of: XHCI Hand-off, VarStoreInfo (VarOffset/VarName): 0x1A, VarStore: 0x11, QuestionId: 0x307, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 49 07 4A 07 07 03 11 00 1A 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x53D2E 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E 41 07 30 00 01 00 00 00 00 00 00 00}
0x53D3C 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E 42 07 00 00 00 00 00 00 00 00 00 00}
0x53D4A 		End One Of {29 02}
```

This default is bad.

```
0x53D4C 		One Of: EHCI Hand-off, VarStoreInfo (VarOffset/VarName): 0x2, VarStore: 0x11, QuestionId: 0x308, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 4B 07 4C 07 08 03 11 00 02 00 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x53D72 			One Of Option: Disabled, Value (8 bit): 0x0 (default) {09 0E 42 07 30 00 00 00 00 00 00 00 00 00}
0x53D80 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E 41 07 00 00 01 00 00 00 00 00 00 00}
0x53D8E 		End One Of {29 02}
```

This default is also bad, should be set to enabled.

```
0x482E2 		One Of: XHCI Mode, VarStoreInfo (VarOffset/VarName): 0x144, VarStore: 0x2, QuestionId: 0x85, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 36 02 37 02 85 00 02 00 44 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48308 			One Of Option: Smart Auto, Value (8 bit): 0x3 (default) {09 0E C1 03 30 00 03 00 00 00 00 00 00 00}
0x48316 			One Of Option: Auto, Value (8 bit): 0x2 {09 0E C0 03 00 00 02 00 00 00 00 00 00 00}
0x48324 			One Of Option: Enabled, Value (8 bit): 0x1 {09 0E C2 03 00 00 01 00 00 00 00 00 00 00}
0x48332 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x48340 			One Of Option: Manual, Value (8 bit): 0x4 {09 0E C4 03 00 00 04 00 00 00 00 00 00 00}
0x4834E 		End One Of {29 02}
```

```
0x48394 		One Of: XHCI Pre-Boot Driver, VarStoreInfo (VarOffset/VarName): 0x158, VarStore: 0x2, QuestionId: 0x87, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 38 02 39 02 87 00 02 00 58 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x483BA 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x483C8 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x483D6 		End One Of {29 02}
0x483D8 		One Of: XHCI Idle L1, VarStoreInfo (VarOffset/VarName): 0x159, VarStore: 0x2, QuestionId: 0x88, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 3A 02 3B 02 88 00 02 00 59 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x483FE 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x4840C 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x4841A 		End One Of {29 02}
```

Another bad default. EHCx ports should all be routed to XHC.

```
0x48460 		One Of: Route USB 2.0 pins to which HC?, VarStoreInfo (VarOffset/VarName): 0x15A, VarStore: 0x2, QuestionId: 0x8A, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 5B 02 5C 02 8A 00 02 00 5A 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48486 			One Of Option: Route Per-Pin, Value (8 bit): 0x0 {09 0E 73 02 00 00 00 00 00 00 00 00 00 00}
0x48494 			One Of Option: Route all Pins to EHCI, Value (8 bit): 0x1 (default) {09 0E 74 02 30 00 01 00 00 00 00 00 00 00}
0x484A2 			One Of Option: Route all Pins to XHCI, Value (8 bit): 0x2 {09 0E 75 02 00 00 02 00 00 00 00 00 00 00}
0x484B0 		End One Of {29 02}
```

Disabling these two removes the need for the EHCx_OFF patch.
```
0x48A40 		One Of: EHCI1, VarStoreInfo (VarOffset/VarName): 0x146, VarStore: 0x2, QuestionId: 0xA0, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 3E 02 40 02 A0 00 02 00 46 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48A66 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x48A74 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x48A82 		End One Of {29 02}
```

```
0x48A84 		One Of: EHCI2, VarStoreInfo (VarOffset/VarName): 0x147, VarStore: 0x2, QuestionId: 0xA1, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 3F 02 40 02 A1 00 02 00 47 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48AAA 			One Of Option: Disabled, Value (8 bit): 0x0 {09 0E C3 03 00 00 00 00 00 00 00 00 00 00}
0x48AB8 			One Of Option: Enabled, Value (8 bit): 0x1 (default) {09 0E C2 03 30 00 01 00 00 00 00 00 00 00}
0x48AC6 		End One Of {29 02}
```
