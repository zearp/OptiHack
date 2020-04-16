It looks like it's possible to adjust the fan curves. Not that the fans ever go loud or even ramp up to a level that annoys me, it is good to know it might be possible to adjust these things.

```
0x4C1FC 		One Of: Critical Trip Point, VarStoreInfo (VarOffset/VarName): 0x1BD, VarStore: 0x2, QuestionId: 0x168, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 14 03 15 03 68 01 02 00 BD 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C222 			One Of Option: POR, Value (8 bit): 0x69 (default) {09 0E 25 03 30 00 69 00 00 00 00 00 00 00}
0x4C230 			One Of Option: 15 C, Value (8 bit): 0xF {09 0E 16 03 00 00 0F 00 00 00 00 00 00 00}
0x4C23E 			One Of Option: 23 C, Value (8 bit): 0x17 {09 0E 17 03 00 00 17 00 00 00 00 00 00 00}
0x4C24C 			One Of Option: 31 C, Value (8 bit): 0x1F {09 0E 18 03 00 00 1F 00 00 00 00 00 00 00}
0x4C25A 			One Of Option: 39 C, Value (8 bit): 0x27 {09 0E 19 03 00 00 27 00 00 00 00 00 00 00}
0x4C268 			One Of Option: 47 C, Value (8 bit): 0x2F {09 0E 1A 03 00 00 2F 00 00 00 00 00 00 00}
0x4C276 			One Of Option: 55 C, Value (8 bit): 0x37 {09 0E 1B 03 00 00 37 00 00 00 00 00 00 00}
0x4C284 			One Of Option: 63 C, Value (8 bit): 0x3F {09 0E 1C 03 00 00 3F 00 00 00 00 00 00 00}
0x4C292 			One Of Option: 71 C, Value (8 bit): 0x47 {09 0E 1D 03 00 00 47 00 00 00 00 00 00 00}
0x4C2A0 			One Of Option: 79 C, Value (8 bit): 0x4F {09 0E 1E 03 00 00 4F 00 00 00 00 00 00 00}
0x4C2AE 			One Of Option: 87 C, Value (8 bit): 0x57 {09 0E 1F 03 00 00 57 00 00 00 00 00 00 00}
0x4C2BC 			One Of Option: 95 C, Value (8 bit): 0x5F {09 0E 20 03 00 00 5F 00 00 00 00 00 00 00}
0x4C2CA 			One Of Option: 103 C, Value (8 bit): 0x67 {09 0E 21 03 00 00 67 00 00 00 00 00 00 00}
0x4C2D8 			One Of Option: 111 C, Value (8 bit): 0x6F {09 0E 22 03 00 00 6F 00 00 00 00 00 00 00}
0x4C2E6 			One Of Option: 119 C, Value (8 bit): 0x77 {09 0E 23 03 00 00 77 00 00 00 00 00 00 00}
0x4C2F4 			One Of Option: 127 C, Value (8 bit): 0x7F {09 0E 24 03 00 00 7F 00 00 00 00 00 00 00}
0x4C302 		End One Of {29 02}
```

```
0x4C304 		One Of: Active Trip Point 0, VarStoreInfo (VarOffset/VarName): 0x1B9, VarStore: 0x2, QuestionId: 0x169, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 10 03 11 03 69 01 02 00 B9 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C32A 			One Of Option: Disabled, Value (8 bit): 0x7F {09 0E C3 03 00 00 7F 00 00 00 00 00 00 00}
0x4C338 			One Of Option: 15 C, Value (8 bit): 0xF {09 0E 16 03 00 00 0F 00 00 00 00 00 00 00}
0x4C346 			One Of Option: 23 C, Value (8 bit): 0x17 {09 0E 17 03 00 00 17 00 00 00 00 00 00 00}
0x4C354 			One Of Option: 31 C, Value (8 bit): 0x1F {09 0E 18 03 00 00 1F 00 00 00 00 00 00 00}
0x4C362 			One Of Option: 39 C, Value (8 bit): 0x27 {09 0E 19 03 00 00 27 00 00 00 00 00 00 00}
0x4C370 			One Of Option: 47 C, Value (8 bit): 0x2F {09 0E 1A 03 00 00 2F 00 00 00 00 00 00 00}
0x4C37E 			One Of Option: 55 C, Value (8 bit): 0x37 {09 0E 1B 03 00 00 37 00 00 00 00 00 00 00}
0x4C38C 			One Of Option: 63 C, Value (8 bit): 0x3F {09 0E 1C 03 00 00 3F 00 00 00 00 00 00 00}
0x4C39A 			One Of Option: 71 C, Value (8 bit): 0x47 (default) {09 0E 1D 03 30 00 47 00 00 00 00 00 00 00}
0x4C3A8 			One Of Option: 79 C, Value (8 bit): 0x4F {09 0E 1E 03 00 00 4F 00 00 00 00 00 00 00}
0x4C3B6 			One Of Option: 87 C, Value (8 bit): 0x57 {09 0E 1F 03 00 00 57 00 00 00 00 00 00 00}
0x4C3C4 			One Of Option: 95 C, Value (8 bit): 0x5F {09 0E 20 03 00 00 5F 00 00 00 00 00 00 00}
0x4C3D2 			One Of Option: 103 C, Value (8 bit): 0x67 {09 0E 21 03 00 00 67 00 00 00 00 00 00 00}
0x4C3E0 			One Of Option: 111 C, Value (8 bit): 0x6F {09 0E 22 03 00 00 6F 00 00 00 00 00 00 00}
0x4C3EE 			One Of Option: 119 C, Value (8 bit): 0x77 {09 0E 23 03 00 00 77 00 00 00 00 00 00 00}
0x4C3FC 		End One Of {29 02}
```

```
0x4C3FE 		Numeric: Active Trip Point 0 Fan Speed, VarStoreInfo (VarOffset/VarName): 0x1BA, VarStore: 0x2, QuestionId: 0x16A, Size: 1, Min: 0x0, Max 0x64, Step: 0x1 {07 A6 26 03 27 03 6A 01 02 00 BA 01 00 10 00 64 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C424 			Default: DefaultId: 0x0, Value (8 bit): 0x64 {5B 0D 00 00 00 64 00 00 00 00 00 00 00}
0x4C431 			One Of Option: Active Trip Point 0 Fan Speed, Value (8 bit): 0x64 (default MFG) {09 0E 26 03 20 00 64 00 00 00 00 00 00 00}
0x4C43F 		End {29 02}
```

```
0x4C441 		One Of: Active Trip Point 1, VarStoreInfo (VarOffset/VarName): 0x1B8, VarStore: 0x2, QuestionId: 0x16B, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 0E 03 0F 03 6B 01 02 00 B8 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C467 			One Of Option: Disabled, Value (8 bit): 0x7F {09 0E C3 03 00 00 7F 00 00 00 00 00 00 00}
0x4C475 			One Of Option: 15 C, Value (8 bit): 0xF {09 0E 16 03 00 00 0F 00 00 00 00 00 00 00}
0x4C483 			One Of Option: 23 C, Value (8 bit): 0x17 {09 0E 17 03 00 00 17 00 00 00 00 00 00 00}
0x4C491 			One Of Option: 31 C, Value (8 bit): 0x1F {09 0E 18 03 00 00 1F 00 00 00 00 00 00 00}
0x4C49F 			One Of Option: 39 C, Value (8 bit): 0x27 {09 0E 19 03 00 00 27 00 00 00 00 00 00 00}
0x4C4AD 			One Of Option: 47 C, Value (8 bit): 0x2F {09 0E 1A 03 00 00 2F 00 00 00 00 00 00 00}
0x4C4BB 			One Of Option: 55 C, Value (8 bit): 0x37 (default) {09 0E 1B 03 30 00 37 00 00 00 00 00 00 00}
0x4C4C9 			One Of Option: 63 C, Value (8 bit): 0x3F {09 0E 1C 03 00 00 3F 00 00 00 00 00 00 00}
0x4C4D7 			One Of Option: 71 C, Value (8 bit): 0x47 {09 0E 1D 03 00 00 47 00 00 00 00 00 00 00}
0x4C4E5 			One Of Option: 79 C, Value (8 bit): 0x4F {09 0E 1E 03 00 00 4F 00 00 00 00 00 00 00}
0x4C4F3 			One Of Option: 87 C, Value (8 bit): 0x57 {09 0E 1F 03 00 00 57 00 00 00 00 00 00 00}
0x4C501 			One Of Option: 95 C, Value (8 bit): 0x5F {09 0E 20 03 00 00 5F 00 00 00 00 00 00 00}
0x4C50F 			One Of Option: 103 C, Value (8 bit): 0x67 {09 0E 21 03 00 00 67 00 00 00 00 00 00 00}
0x4C51D 			One Of Option: 111 C, Value (8 bit): 0x6F {09 0E 22 03 00 00 6F 00 00 00 00 00 00 00}
0x4C52B 			One Of Option: 119 C, Value (8 bit): 0x77 {09 0E 23 03 00 00 77 00 00 00 00 00 00 00}
0x4C539 		End One Of {29 02}
```

```
0x4C53B 		Numeric: Active Trip Point 1 Fan Speed, VarStoreInfo (VarOffset/VarName): 0x1BB, VarStore: 0x2, QuestionId: 0x16C, Size: 1, Min: 0x0, Max 0x64, Step: 0x1 {07 A6 28 03 29 03 6C 01 02 00 BB 01 00 10 00 64 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C561 			Default: DefaultId: 0x0, Value (8 bit): 0x4B {5B 0D 00 00 00 4B 00 00 00 00 00 00 00}
0x4C56E 			One Of Option: Active Trip Point 1 Fan Speed, Value (8 bit): 0x4B (default MFG) {09 0E 28 03 20 00 4B 00 00 00 00 00 00 00}
0x4C57C 		End {29 02}
```

```
0x4C57E 		One Of: Passive Trip Point, VarStoreInfo (VarOffset/VarName): 0x1BC, VarStore: 0x2, QuestionId: 0x16D, Size: 1, Min: 0x0, Max 0x0, Step: 0x0 {05 A6 12 03 13 03 6D 01 02 00 BC 01 10 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00}
0x4C5A4 			One Of Option: Disabled, Value (8 bit): 0x7F {09 0E C3 03 00 00 7F 00 00 00 00 00 00 00}
0x4C5B2 			One Of Option: 15 C, Value (8 bit): 0xF {09 0E 16 03 00 00 0F 00 00 00 00 00 00 00}
0x4C5C0 			One Of Option: 23 C, Value (8 bit): 0x17 {09 0E 17 03 00 00 17 00 00 00 00 00 00 00}
0x4C5CE 			One Of Option: 31 C, Value (8 bit): 0x1F {09 0E 18 03 00 00 1F 00 00 00 00 00 00 00}
0x4C5DC 			One Of Option: 39 C, Value (8 bit): 0x27 {09 0E 19 03 00 00 27 00 00 00 00 00 00 00}
0x4C5EA 			One Of Option: 47 C, Value (8 bit): 0x2F {09 0E 1A 03 00 00 2F 00 00 00 00 00 00 00}
0x4C5F8 			One Of Option: 55 C, Value (8 bit): 0x37 {09 0E 1B 03 00 00 37 00 00 00 00 00 00 00}
0x4C606 			One Of Option: 63 C, Value (8 bit): 0x3F {09 0E 1C 03 00 00 3F 00 00 00 00 00 00 00}
0x4C614 			One Of Option: 71 C, Value (8 bit): 0x47 {09 0E 1D 03 00 00 47 00 00 00 00 00 00 00}
0x4C622 			One Of Option: 79 C, Value (8 bit): 0x4F {09 0E 1E 03 00 00 4F 00 00 00 00 00 00 00}
0x4C630 			One Of Option: 87 C, Value (8 bit): 0x57 {09 0E 1F 03 00 00 57 00 00 00 00 00 00 00}
0x4C63E 			One Of Option: 95 C, Value (8 bit): 0x5F (default) {09 0E 20 03 30 00 5F 00 00 00 00 00 00 00}
0x4C64C 			One Of Option: 103 C, Value (8 bit): 0x67 {09 0E 21 03 00 00 67 00 00 00 00 00 00 00}
0x4C65A 			One Of Option: 111 C, Value (8 bit): 0x6F {09 0E 22 03 00 00 6F 00 00 00 00 00 00 00}
0x4C668 			One Of Option: 119 C, Value (8 bit): 0x77 {09 0E 23 03 00 00 77 00 00 00 00 00 00 00}
0x4C676 		End One Of {29 02}
```
