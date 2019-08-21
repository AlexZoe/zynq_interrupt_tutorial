#-------------------------------------------------------------------------------
#
# @author		Alexander Zoellner
# @date			2019/06/20
# @mail			zoellner.contact<at>gmail.com
# @file			package_ip.tcl
#
# @brief		Packages a repository as IP core to be used in Vivado.
#
#-------------------------------------------------------------------------------

# Source and variable definitions and
source tcl/settings.tcl
# Create temporary project in memory to set compile order (chip type does not
# really matter here)
create_project tmp -in_memory -part ${CHIP}
# Set compile order to automatic
set_property source_mgmt_mode All [current_project]
# Package IP core
ipx::infer_core -name ${IP_CORE} -vendor user.org -library user \
	-taxonomy /UserIP ${IP_REPO}
# Set IP core name (the name during packaging seems to get ignored/overwritten)
set_property name ${IP_CORE} [ipx::current_core]
set_property display_name ${IP_CORE}_v${IP_MAJOR}_${IP_MINOR} [ipx::current_core]
set_property description ${IP_CORE}_v${IP_MAJOR}_${IP_MINOR} [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project
