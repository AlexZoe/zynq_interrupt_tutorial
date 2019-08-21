# Tutorial for Hardware Interrupts with the Xilinx Zynq Platform Using Linux

## About
This tutorial explains how to generate interrupts with the Xilinx Zynq
platform within programmable logic and processing them in the Linux kernel using
 a device driver. The tutorial consist of two parts. The first one provides a
'quick start', providing required code snippets and a short description how to
use them. This section is best suited for those who are already familiar with
the Zynq platform as well as having at least some basic understanding of Linux
device drivers (but there is also great material available online for picking up
the necessary parts, such as the *Linux Device Drivers, Third Edition*).

*TBD*
The second part explains the specific steps for setting up hardware interrupts
in greater detail featuring a demonstrator sytem with a hardware timer
implemented in programmable logic. The system is deployed on Digilent's Zybo Z7
platform with a Zynq 7020 System-on-Chip (SoC).
Additionally, references to additional literature is referenced as appropriate.

Hopefully, others may find this tutorial helpful without having to read through
countless forum posts and reference manuals.

## Structure
The directories 'appl', 'driver', 'dts' and 'system' are related to the
demonstrator system. These directories contain a user space program for
configuring the hardware timer, the Linux driver, devicetree source file and the
hardware system.

Use the toplevel Makefile to build the subdirectories or use the one of the
respective directory.

## Keywords
Zynq 7000, Xilinx, Vivado, Linux Device Driver, Hardware Interrupts, Zybo Z7,
Digilent
