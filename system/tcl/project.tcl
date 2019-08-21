#-------------------------------------------------------------------------------
#
# @author		Alexander Zoellner
# @date			2019/06/20
# @mail			zoellner.contact<at>gmail.com
# @file			project.tcl
#
# @brief		Creates a new vivado project from scratch.
#
#				Create new vivado project, instantiates required
#				components and generates the bitstream.
#
#-------------------------------------------------------------------------------

# Source and variable definitions and
source tcl/settings.tcl

###################### Basic project setup part #########################
#create_project ${MODULE} -in_memory -part ${CHIP}
create_project -force ${outputDir}/${MODULE} -part ${CHIP} ${MODULE}

# Set the board pre-sets
set_property board_part ${BOARD} [current_project]
# Add path to IP core definition (component.xml)
set_property ip_repo_paths ${IP_REPO} [current_project]
update_ip_catalog

# Create block design
create_bd_design ${MODULE}
update_compile_order -fileset sources_1
# Instantiate ARM cores (PS)
startgroup
	create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 \
		processing_system7_0
endgroup
# Let Vivado wizard connect basic peripherals
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 \
	-config {make_external "FIXED_IO, DDR" \
		apply_board_preset "1" \
		Master "Disable" \
		Slave "Disable" } \
	[get_bd_cells processing_system7_0]
# Change clock frequency and activate PL -> PS interrupt port
startgroup
	set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {100} \
		CONFIG.PCW_USE_FABRIC_INTERRUPT {1} CONFIG.PCW_IRQ_F2P_INTR {1}] \
		[get_bd_cells processing_system7_0]
endgroup
# Save current block design
save_bd_design

####################### Project specific part ###########################
# Instantiate own IP core
startgroup
	create_bd_cell -type ip -vlnv user.org:user:${IP_CORE}:${IP_MAJOR}.${IP_MINOR} \
	${IP_CORE}_0
endgroup
# Connect IP core with Vivado wizard
apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
	-config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} \
		Master {/processing_system7_0/M_AXI_GP0} \
		Slave {/${IP_CORE}_0/s_axi} \
		intc_ip {New AXI Interconnect} \
		master_apm {0}} \
	[get_bd_intf_pins ${IP_CORE}_0/s_axi]
# Connect external ports of IP core (only the interrupt port in this case)
connect_bd_net [get_bd_pins ${IP_CORE}_0/${IP_CORE}_intr_o] \
	[get_bd_pins processing_system7_0/IRQ_F2P]

##################### General project compilaton ########################
# Save current block design
save_bd_design
# Set current project
#current_project ${MODULE}
validate_bd_design
# Add system wrapper file
make_wrapper -files [get_files ${MODULE}/${MODULE}.srcs/sources_1/bd/${MODULE}/${MODULE}.bd] -top
add_files -norecurse ${MODULE}/${MODULE}.srcs/sources_1/bd/${MODULE}/hdl/${MODULE}_wrapper.v
# Synthesis run
reset_run synth_1
# Implementation run (routing/mapping) and bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs 2
# Wait until the run has finished
wait_on_run impl_1

