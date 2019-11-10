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

PROJECT			:= hw_timer_interrupt

XLNX_TOOL_CHAIN := /opt/Xilinx-18-3/xilinx-vivado-2018_3-settings.sh
SHELL			:= /bin/bash

SRC_DIR			:= hdl
SCRIPT_DIR		:= tcl
BUILD_DIR		:= build

ifdef XILINX_VIVADO
ENV_CMD :=
else
ENV_CMD := source $(XLNX_TOOL_CHAIN) &&
endif

.PHONY: system clean build_dir ip_core
.DEFAULT_GOAL := all

all: ip_core system

system: build_dir
	$(ENV_CMD) \
	vivado -mode batch -source $(SCRIPT_DIR)/project.tcl

ip_core:
	$(ENV_CMD) \
	vivado -mode batch -source $(SCRIPT_DIR)/package_ip.tcl

build_dir:
	mkdir -p $(BUILD_DIR)

clean:
	@rm -rf $(BUILD_DIR)/$(PROJECT)
	@rm -rf $(BUILD_DIR)
	@rm -rf *.log *.jou
	@rm -rf $(SRC_DIR)/xgui
	@rm -rf $(SRC_DIR)/component.xml
	@rm -rf .Xil
	@rm -rf *.str
