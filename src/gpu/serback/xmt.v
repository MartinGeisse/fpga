//
// xmt.v -- serial line transmitter
//


`timescale 1ns/10ps
`default_nettype none


module xmt(clk, reset, load, empty, parallel_in, serial_out);
    input clk;
    input reset;
    input load;
    output reg empty;
    input [7:0] parallel_in;
    output serial_out;

  localparam SERIAL_PORT_BIT_DURATION_CLOCKS = (50 * 1000 * 1000) / 2000; // speed is 2 kbaud

  reg [3:0] state;
  reg [8:0] shift;
  reg [31:0] count;

  assign serial_out = shift[0];

  always @(posedge clk) begin
    if (reset == 1) begin
      state <= 4'h0;
      shift <= 9'b111111111;
      empty <= 1;
    end else begin
      if (state == 4'h0) begin
        if (load == 1) begin
          state <= 4'h1;
          shift <= { parallel_in, 1'b0 };
          count <= SERIAL_PORT_BIT_DURATION_CLOCKS;
          empty <= 0;
        end
      end else
      if (state == 4'hb) begin
        state <= 4'h0;
        empty <= 1;
      end else begin
        if (count == 0) begin
          state <= state + 1;
          shift[8:0] <= { 1'b1, shift[8:1] };
          count <= SERIAL_PORT_BIT_DURATION_CLOCKS;
        end else begin
          count <= count - 1;
        end
      end
    end
  end

endmodule
