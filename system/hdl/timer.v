/**
 * @author      Alexander Zoellner
 * @date        2019/06/20
 * @mail        zoellner.contact@gmail.com
 * @file        timer.v
 *
 * @brief       Simple programmable down-counter generating interrupts
 *              after the timer expires.
 */

`timescale 1 ns / 1 ns

`default_nettype none

/* Module interface */
module timer #
(
    parameter integer COUNTER_WIDTH = 32
)
(
    input   wire clk,
    input   wire reset,

    input   wire [COUNTER_WIDTH-1 : 0] load_value_i,
    input   wire start_i,
    input   wire auto_reload_i,

    output  wire interrupt_o,
    output  reg  clear_enable_o
);

/* Module body */

// Increase bit width by one since MSB is used for comparison
reg [COUNTER_WIDTH:0] r_count = 0;

reg s_state;
localparam       s_idle = 1'b0,
                 s_cnt  = 1'b1;

/*
 * FSM of the timer
 *
 * Loads r_counter until the start bit is received. Generates an interrupt when
 * r_counter underflows. Automatically starts again if 'auto_reload' is set.
 */
always @(posedge clk)
  if (reset) begin
      r_count <= 0;
      clear_enable_o <= 1'b0;
      s_state <= s_idle;
  end
  else begin
      r_count <= 0;
      clear_enable_o <= 1'b0;
      case (s_state)

        s_idle:
          begin
            r_count[COUNTER_WIDTH] <= 1'b0;
            r_count[COUNTER_WIDTH-1:0] <= load_value_i;
            if (start_i == 1'b1) begin
                s_state <= s_cnt;
                clear_enable_o <= 1'b1;
            end
          end

        s_cnt:
          begin
            if (r_count[COUNTER_WIDTH] == 1'b1) begin
                r_count[COUNTER_WIDTH-1:0] <= load_value_i;
                if (auto_reload_i == 1'b0)
                    s_state <= s_idle;
            end
            else begin
              r_count <= r_count - 1;
            end
          end

        default:
          s_state <= s_idle;

      endcase
    end

assign interrupt_o = r_count[COUNTER_WIDTH];

endmodule

`default_nettype wire
