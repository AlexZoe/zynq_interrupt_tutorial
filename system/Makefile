#-------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/07/21
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#  @brief	Makefile for packaging hardware timer IP-core and building demo
#			system.
#
#-------------------------------------------------------------------------------

# Location of Vivado settings when installed at /opt/
XLNX_TOOL_CHAIN := /opt/Xilinx_18_3/Vivado/2018.3/settings64.sh
SHELL			:= /bin/bash

SRC_DIR := hdl
SCRIPT_DIR := tcl
BUILD_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.v)

ifdef XILINX_VIVADO_DIR_
ENV_CMD :=
else
ENV_CMD := source $(XLNX_TOOL_CHAIN) &&
endif

.PHONY: system clean build_dir ip_core
.DEFAULT: sim

system: build_dir ip_core
	$(ENV_CMD) \
	vivado -mode batch -source $(SCRIPT_DIR)/project.tcl

ip_core:
	$(ENV_CMD) \
	vivado -mode batch -source $(SCRIPT_DIR)/package_ip.tcl

build_dir:
	mkdir -p $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)
	@rm -rf *.log *.jou
	@rm -rf hdl/xgui
	@rm -rf hdl/component.xml
	@rm -rf .Xil
	@rm -rf *.str
