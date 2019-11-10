#-------------------------------------------------------------------------------
#
#  @author	Alexander Zoellner
#  @date	2019/08/19
#  @mail	zoellner.contact<at>gmail.com
#  @file	Makefile
#
#  @brief	Toplevel Makefile for building subdirectories.
#
#-------------------------------------------------------------------------------

.PHONY: clean doc ip_core system driver application all

.DEFAULT_GOAL := all

all: ip_core system driver application doc

ip_core:
	$(MAKE) -C system/ ip_core

system:
	$(MAKE) -C system/ system

driver:
	$(MAKE) -C driver/

application:
	$(MAKE) -C appl/

doc:
	$(MAKE) -C doc/

clean:
	@$(MAKE) -C system/ clean
	@$(MAKE) -C driver/ clean
	@$(MAKE) -C appl/ clean
	@$(MAKE) -C doc/ clean
