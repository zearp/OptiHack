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

```
0x484B2 		One Of: USB 2.0 PIN #0, VarStoreInfo (VarOffset/VarName): 0x15B, VarStore: 0x2, QuestionId: 0x8B, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 5F 02 BF 03 8B 00 02 00 5B 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x484D8 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x484E6 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x484F4 		End One Of {29 02}
0x484F6 		One Of: USB 2.0 PIN #1, VarStoreInfo (VarOffset/VarName): 0x15C, VarStore: 0x2, QuestionId: 0x8C, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 60 02 BF 03 8C 00 02 00 5C 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4851C 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4852A 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48538 		End One Of {29 02}
0x4853A 		One Of: USB 2.0 PIN #2, VarStoreInfo (VarOffset/VarName): 0x15D, VarStore: 0x2, QuestionId: 0x8D, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 61 02 BF 03 8D 00 02 00 5D 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48560 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4856E 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x4857C 		End One Of {29 02}
0x4857E 		One Of: USB 2.0 PIN #3, VarStoreInfo (VarOffset/VarName): 0x15E, VarStore: 0x2, QuestionId: 0x8E, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 62 02 BF 03 8E 00 02 00 5E 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x485A4 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x485B2 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x485C0 		End One Of {29 02}
0x485C2 		One Of: USB 2.0 PIN #4, VarStoreInfo (VarOffset/VarName): 0x15F, VarStore: 0x2, QuestionId: 0x8F, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 63 02 BF 03 8F 00 02 00 5F 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x485E8 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x485F6 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48604 		End One Of {29 02}
0x48606 		One Of: USB 2.0 PIN #5, VarStoreInfo (VarOffset/VarName): 0x160, VarStore: 0x2, QuestionId: 0x90, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 64 02 BF 03 90 00 02 00 60 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4862C 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4863A 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48648 		End One Of {29 02}
0x4864A 		One Of: USB 2.0 PIN #6, VarStoreInfo (VarOffset/VarName): 0x161, VarStore: 0x2, QuestionId: 0x91, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 65 02 BF 03 91 00 02 00 61 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48670 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4867E 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x4868C 		End One Of {29 02}
0x4868E 		One Of: USB 2.0 PIN #7, VarStoreInfo (VarOffset/VarName): 0x162, VarStore: 0x2, QuestionId: 0x92, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 66 02 BF 03 92 00 02 00 62 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x486B4 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x486C2 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x486D0 		End One Of {29 02}
0x486D2 		One Of: USB 2.0 PIN #8, VarStoreInfo (VarOffset/VarName): 0x163, VarStore: 0x2, QuestionId: 0x93, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 67 02 BF 03 93 00 02 00 63 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x486F8 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x48706 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48714 		End One Of {29 02}
0x48716 		One Of: USB 2.0 PIN #9, VarStoreInfo (VarOffset/VarName): 0x164, VarStore: 0x2, QuestionId: 0x94, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 68 02 BF 03 94 00 02 00 64 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4873C 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4874A 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48758 		End One Of {29 02}
0x4875A 		One Of: USB 2.0 PIN #10, VarStoreInfo (VarOffset/VarName): 0x165, VarStore: 0x2, QuestionId: 0x95, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 69 02 BF 03 95 00 02 00 65 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48780 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4878E 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x4879C 		End One Of {29 02}
0x4879E 		One Of: USB 2.0 PIN #11, VarStoreInfo (VarOffset/VarName): 0x166, VarStore: 0x2, QuestionId: 0x96, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 6A 02 BF 03 96 00 02 00 66 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x487C4 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x487D2 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x487E0 		End One Of {29 02}
0x487E2 		One Of: USB 2.0 PIN #12, VarStoreInfo (VarOffset/VarName): 0x167, VarStore: 0x2, QuestionId: 0x97, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 6B 02 BF 03 97 00 02 00 67 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x48808 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x48816 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48824 		End One Of {29 02}
0x48826 		One Of: USB 2.0 PIN #13, VarStoreInfo (VarOffset/VarName): 0x168, VarStore: 0x2, QuestionId: 0x98, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 6C 02 BF 03 98 00 02 00 68 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4884C 			One Of Option: Route to EHCI, Value (8 bit): 0x0 (default) {09 0E 76 02 30 00 00 00 00 00 00 00 00 00}
0x4885A 			One Of Option: Route to XHCI, Value (8 bit): 0x1 {09 0E 77 02 00 00 01 00 00 00 00 00 00 00}
0x48868 		End One Of {29 02}
````
