/**
 * @author      Alexander Zoellner
 * @date        2019/06/20
 * @mail        zoellner.contact@gmail.com
 * @file        timer_toplevel.v
 *
 * @brief       Instantiates the timer module and connects to i/o and
 *              bus interface
 */

`timescale 1 ns / 1 ns

`default_nettype none

module timer_toplevel #
(
  // Timer params
  parameter integer C_COUNTER_WIDTH = 32,
  // AXI slave params
  parameter integer C_S_AXI_DATA_WIDTH = 32,
  parameter integer C_S_AXI_ADDR_WIDTH = 7
)
(
  // Timer interface
  output wire timer_intr_o,

  // AXI slave interface
  input wire s_axi_aclk,
  input wire s_axi_aresetn,
  input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr,
  input wire [2:0] s_axi_awprot,
  input wire s_axi_awvalid,
  output wire s_axi_awready,
  input wire [C_S_AXI_DATA_WIDTH-1:0] s_axi_wdata,
  input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb,
  input wire s_axi_wvalid,
  output wire s_axi_wready,
  output wire [1 : 0] s_axi_bresp,
  output wire s_axi_bvalid,
  input wire s_axi_bready,
  input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr,
  input wire [2 : 0] s_axi_arprot,
  input wire s_axi_arvalid,
  output wire s_axi_arready,
  output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata,
  output wire [1 : 0] s_axi_rresp,
  output wire s_axi_rvalid,
  input wire s_axi_rready
);

  // Parameters and glue logic
  wire sys_reset;
  wire sys_clk;

  wire [C_COUNTER_WIDTH-1 : 0] w_timer_0_load_val;
  wire [C_S_AXI_DATA_WIDTH-1 : 0] w_timer_0_control;
  wire [C_S_AXI_DATA_WIDTH-1 : 0] w_timer_0_ctl_reset;

  // Module begin
  assign sys_reset = ~s_axi_aresetn;
  assign sys_clk = s_axi_aclk;

  timer #
  (
    .COUNTER_WIDTH(C_COUNTER_WIDTH)
  )
    timer_0
  (
    .clk(sys_clk),
    .reset(sys_reset),
    .load_value_i(w_timer_0_load_val),
    .start_i(w_timer_0_control[0]),
    .auto_reload_i(w_timer_0_control[1]),
    .interrupt_o(timer_intr_o),
    .clear_enable_o(w_timer_0_ctl_reset[0])
  );

  assign w_timer_0_ctl_reset[C_S_AXI_DATA_WIDTH-1 : 1] = 0;

  axi_slave_if #
  (
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  )
    axi_slave_0
  (
    .slv_reg_0(w_timer_0_control),
    .slv_reg_reset_0(w_timer_0_ctl_reset),
    .slv_reg_1(w_timer_0_load_val),
    .slv_reg_2(),
    .slv_reg_3(),
    .slv_reg_4(),
    .slv_reg_5(),
    .slv_reg_6(),
    .slv_reg_7(),
    .slv_reg_8(),
    .slv_reg_9(),
    .slv_reg_10(),
    .slv_reg_11(),
    .slv_reg_12(),
    .slv_reg_13(),
    .slv_reg_14(),
    .slv_reg_15(),
    .slv_reg_16(),
    .slv_reg_17(),
    .slv_reg_18(),
    .slv_reg_19(),
    .slv_reg_20(),
    .slv_reg_21(),
    .slv_reg_22(),
    .slv_reg_23(),
    .slv_reg_24(),
    .slv_reg_25(),
    .slv_reg_26(),
    .slv_reg_27(),
    .slv_reg_28(),
    .slv_reg_29(),
    .slv_reg_30(),
    .slv_reg_31(),

		.S_AXI_ACLK(s_axi_aclk),
    .S_AXI_ARESETN(s_axi_aresetn),
		.S_AXI_AWADDR(s_axi_awaddr),
		.S_AXI_AWPROT(s_axi_awprot),
		.S_AXI_AWVALID(s_axi_awvalid),
		.S_AXI_AWREADY(s_axi_awready),
		.S_AXI_WDATA(s_axi_wdata),
		.S_AXI_WSTRB(s_axi_wstrb),
		.S_AXI_WVALID(s_axi_wvalid),
		.S_AXI_WREADY(s_axi_wready),
		.S_AXI_BRESP(s_axi_bresp),
		.S_AXI_BVALID(s_axi_bvalid),
		.S_AXI_BREADY(s_axi_bready),
		.S_AXI_ARADDR(s_axi_araddr),
		.S_AXI_ARPROT(s_axi_arprot),
		.S_AXI_ARVALID(s_axi_arvalid),
		.S_AXI_ARREADY(s_axi_arready),
		.S_AXI_RDATA(s_axi_rdata),
		.S_AXI_RRESP(s_axi_rresp),
		.S_AXI_RVALID(s_axi_rvalid),
		.S_AXI_RREADY(s_axi_rready)
  );

  endmodule

`default_nettype wire
