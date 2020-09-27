#-------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/07/21
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#  @brief	Makefile for building hardware timer Linux device driver.
#
#-------------------------------------------------------------------------------

TARGET := hw_timer

ifneq ($(KERNELRELEASE),)

# Main object file
obj-m := $(TARGET).o

else

# 'XILINX_VIVADO' gets defined when sourcing the Xilinx environment
ifdef XILINX_VIVADO
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
CC   := $(CROSS_COMPILE)gcc
# Path to Xilinx kernel headers
KDIR ?= ~/dev/projects/xilinx_repos/linux-xlnx/
else
KDIR ?= /lib/modules/$(shell uname -r)/build
endif

.PHONY := default clean

default:
	$(MAKE) -C $(KDIR) M=$$PWD C=1 modules

clean:
	@rm -rf *.order
	@rm -rf *.symvers
	@rm -rf *.o
	@rm -rf *.ko
	@rm -rf *.mod*
	@rm -rf .$(TARGET)*
	@rm -rf .tmp*
	@rm -rf .built-in*

endif

