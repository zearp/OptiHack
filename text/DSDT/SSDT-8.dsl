/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-8.aml, Wed Apr 15 14:32:52 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000066 (102)
 *     Revision         0x02
 *     Checksum         0x69
 *     OEM ID           "APPLE"
 *     OEM Table ID     "HPET"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "APPLE", "HPET", 0x00000000)
{
    /*
     * External declarations were imported from
     * a reference file -- DSDT.aml
     */

    External (_SB_.PCI0.LPCB, DeviceObj)    // (from opcode)

    Name (\_SB.PCI0.LPCB.HPET._CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
    {
        IRQNoFlags ()
            {0,8,11}
        Memory32Fixed (ReadWrite,
            0xFED00000,         // Address Base
            0x00000400,         // Address Length
            )
    })
}

