/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-5.aml, Wed Apr 15 14:32:52 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x000000D0 (208)
 *     Revision         0x01
 *     Checksum         0x95
 *     OEM ID           "Iffs"
 *     OEM Table ID     "IffsAsl"
 *     OEM Revision     0x00003000 (12288)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20051117 (537202967)
 */
DefinitionBlock ("", "SSDT", 1, "Iffs", "IffsAsl", 0x00003000)
{
    Scope (\_SB)
    {
        Device (IFFS)
        {
            OperationRegion (FFSN, SystemMemory, 0xD47FFD98, 0x0008)
            Field (FFSN, AnyAcc, Lock, Preserve)
            {
                FFSA,   8, 
                FFSS,   8, 
                FFST,   16, 
                FFSP,   32
            }

            Name (_HID, EisaId ("INT3392"))  // _HID: Hardware ID
            Name (_CID, EisaId ("PNP0C02"))  // _CID: Compatible ID
            Method (GFFS, 0, Serialized)
            {
                Return (FFSS)
            }

            Method (SFFS, 1, Serialized)
            {
                And (Arg0, FFSA, FFSS)
                Return (FFSS)
            }

            Method (GFTV, 0, Serialized)
            {
                Return (FFST)
            }

            Method (SFTV, 1, Serialized)
            {
                If (LLessEqual (Arg0, 0x05A0))
                {
                    Store (Arg0, FFST)
                }
                Else
                {
                    And (FFSS, 0xFFFE, FFSS)
                    Store (0x0A, FFST)
                }

                Return (FFST)
            }
        }
    }
}

