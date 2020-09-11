/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20180427 (64-bit version)(RM)
 * Copyright (c) 2000 - 2018 Intel Corporation
 * 
 * Disassembling to non-symbolic legacy ASL operators
 *
 * Disassembly of SSDT-11.aml, Wed Apr 15 14:32:52 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x0000035A (858)
 *     Revision         0x02
 *     Checksum         0xAC
 *     OEM ID           "ACDT"
 *     OEM Table ID     "_UIAC"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20180427 (538444839)
 */
DefinitionBlock ("", "SSDT", 2, "ACDT", "_UIAC", 0x00000000)
{
    Device (UIAC)
    {
        Name (_HID, "UIA00000")  // _HID: Hardware ID
        Name (RMCF, Package (0x02)
        {
            "XHC", 
            Package (0x04)
            {
                "port-count", 
                Buffer (0x04)
                {
                     0x15, 0x00, 0x00, 0x00                         
                }, 

                "ports", 
                Package (0x1C)
                {
                    "HS03", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS03"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x03, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS04", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS04"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x04, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS05", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS05"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x05, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS06", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS06"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x06, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS07", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS07"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x07, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS08", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS08"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x08, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS09", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS09"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x09, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS10", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS10"
                        }, 

                        "UsbConnector", 
                        Zero, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x0A, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS11", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS11"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x0B, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "HS12", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "HS12"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x0C, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "SS01", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "SS01"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x10, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "SS02", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "SS02"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x11, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "SS05", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "SS05"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x14, 0x00, 0x00, 0x00                         
                        }
                    }, 

                    "SS06", 
                    Package (0x06)
                    {
                        "name", 
                        Buffer (0x05)
                        {
                            "SS06"
                        }, 

                        "UsbConnector", 
                        0x03, 
                        "port", 
                        Buffer (0x04)
                        {
                             0x15, 0x00, 0x00, 0x00                         
                        }
                    }
                }
            }
        })
    }
}

