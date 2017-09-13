//
// ser.v -- serial line interface
//


`timescale 1ns/10ps
`default_nettype none


module serback(clk, rst,
           stb, we,
           data_in, data_out,
	         txd);
    // internal interface
    input clk;
    input rst;
    input stb;
    input we;
    input [7:0] data_in;
    output [7:0] data_out;
    // external interface
    output txd;

  wire wr_xmt_data;
  wire xmt_rdy;
  assign wr_xmt_data = (stb == 1 && we == 1) ? 1 : 0;
  xmtbuf xmtbuf_1(clk, rst, wr_xmt_data, xmt_rdy, data_in, txd);
  assign data_out = { 7'b0000000, xmt_rdy };

endmodule
