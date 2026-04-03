## ============================================================
## Constraint File: Adaptive FIR Filter with LMS Algorithm
## Board  : EDGE Artix-7 (XC7A35T)
## Project: LMS Adaptive Filter + UART Output
## Clock  : 50 MHz
##
## Active Ports in top.v:
##   input  clk          -- 50 MHz system clock
##   input  [15:0] sw    -- 16-bit input signal via switches
##   input  [4:0]  pb    -- pb[0]=Reset(top), pb[1]=Send/Sample(bottom)
##   output tx           -- UART TX to PC via USB-UART bridge
##
## Pin Usage Summary:
##   pb[0] -> K13  : Reset LMS weights & FIR delay line
##   pb[1] -> L14  : Sample switches + trigger UART send (one-shot pulse)
##   tx    -> C4   : USB-UART TXD (connects to PC COM port via onboard bridge)
## ============================================================


## ------------------------------------------------------------
## Clock Signal — 50 MHz onboard oscillator
## ------------------------------------------------------------
set_property -dict { PACKAGE_PIN N11  IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 20.000 -waveform {0 10} [get_ports { clk }];


## ------------------------------------------------------------
## Switches — sw[15:0] : 16-bit input sample
## Set via onboard DIP switches before pressing pb[1]
## sw[0] = LSB (rightmost), sw[15] = MSB (leftmost)
## ------------------------------------------------------------
set_property -dict { PACKAGE_PIN L5   IOSTANDARD LVCMOS33 } [get_ports { sw[0]  }];  # LSB
set_property -dict { PACKAGE_PIN L4   IOSTANDARD LVCMOS33 } [get_ports { sw[1]  }];
set_property -dict { PACKAGE_PIN M4   IOSTANDARD LVCMOS33 } [get_ports { sw[2]  }];
set_property -dict { PACKAGE_PIN M2   IOSTANDARD LVCMOS33 } [get_ports { sw[3]  }];
set_property -dict { PACKAGE_PIN M1   IOSTANDARD LVCMOS33 } [get_ports { sw[4]  }];
set_property -dict { PACKAGE_PIN N3   IOSTANDARD LVCMOS33 } [get_ports { sw[5]  }];
set_property -dict { PACKAGE_PIN N2   IOSTANDARD LVCMOS33 } [get_ports { sw[6]  }];
set_property -dict { PACKAGE_PIN N1   IOSTANDARD LVCMOS33 } [get_ports { sw[7]  }];
set_property -dict { PACKAGE_PIN P1   IOSTANDARD LVCMOS33 } [get_ports { sw[8]  }];
set_property -dict { PACKAGE_PIN P4   IOSTANDARD LVCMOS33 } [get_ports { sw[9]  }];
set_property -dict { PACKAGE_PIN T8   IOSTANDARD LVCMOS33 } [get_ports { sw[10] }];
set_property -dict { PACKAGE_PIN R8   IOSTANDARD LVCMOS33 } [get_ports { sw[11] }];
set_property -dict { PACKAGE_PIN N6   IOSTANDARD LVCMOS33 } [get_ports { sw[12] }];
set_property -dict { PACKAGE_PIN T7   IOSTANDARD LVCMOS33 } [get_ports { sw[13] }];
set_property -dict { PACKAGE_PIN P8   IOSTANDARD LVCMOS33 } [get_ports { sw[14] }];
set_property -dict { PACKAGE_PIN M6   IOSTANDARD LVCMOS33 } [get_ports { sw[15] }];  # MSB


## ------------------------------------------------------------
## Push Buttons — pb[4:0]
##
##   pb[0] -> K13 (Button-top)    : RESET
##            Resets all LMS weights (wn[0..3]) and
##            FIR delay line (xn_0..xn_3) to zero
##
##   pb[1] -> L14 (Button-bottom) : SAMPLE + SEND
##            Latches sw[15:0] into x_sample on rising edge
##            Triggers one UART transmission: "Y=XXXX E=XXXX\r\n"
##
##   pb[2..4] : Not used in this project (constrained but unconnected)
##              Vivado will not error — ports pb[2..4] are declared
##              in top.v but internally unused (no logic driven by them)
##
## PULLDOWN ensures button reads 0 when not pressed (active-high logic)
## ------------------------------------------------------------
set_property -dict { PACKAGE_PIN K13  IOSTANDARD LVCMOS33  PULLDOWN true } [get_ports { pb[0] }];  # RESET       (Button-top)
set_property -dict { PACKAGE_PIN L14  IOSTANDARD LVCMOS33  PULLDOWN true } [get_ports { pb[1] }];  # SAMPLE+SEND (Button-bottom)
set_property -dict { PACKAGE_PIN M12  IOSTANDARD LVCMOS33  PULLDOWN true } [get_ports { pb[2] }];  # Unused      (Button-left)
set_property -dict { PACKAGE_PIN L13  IOSTANDARD LVCMOS33  PULLDOWN true } [get_ports { pb[3] }];  # Unused      (Button-right)
set_property -dict { PACKAGE_PIN M14  IOSTANDARD LVCMOS33  PULLDOWN true } [get_ports { pb[4] }];  # Unused      (Button-center)


## ------------------------------------------------------------
## UART TX — Connects to onboard USB-UART bridge (CP2102/similar)
## Maps to: usb_uart_txd on the board (FPGA transmits → PC receives)
##
## Settings for PuTTY / serial terminal:
##   Baud Rate : 9600
##   Data Bits : 8
##   Stop Bits : 1
##   Parity    : None
##   Flow Ctrl : None
##
## Expected output on press of pb[1]:
##   Y=0A3F E=01C2
##   Y=0B10 E=00F0
## ------------------------------------------------------------
set_property -dict { PACKAGE_PIN C4   IOSTANDARD LVCMOS33 } [get_ports { tx }];  # USB-UART TXD


## ------------------------------------------------------------
## Configuration & Bitstream Properties
## Required for Artix-7 (XC7A35T) proper operation
## ------------------------------------------------------------
set_property CFGBVS VCCO        [current_design];
set_property CONFIG_VOLTAGE 3.3 [current_design];
