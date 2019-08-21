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

PROJECT := hw_timer

ifneq ($(KERNELRELEASE),)

# Main object file
obj-m := $(PROJECT).o
# List additional object files here
#objs  :=

else

ifdef XILINX_VIVADO_DIR_
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
CC   := $(CROSS_COMPILE)gcc
KDIR ?= ~/dev/soc-linux-image/linux-xlnx/
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
	@rm -rf *.mod.*
	@rm -rf .$(PROJECT)*
	@rm -rf .tmp*
	@rm -rf .built-in*

endif

