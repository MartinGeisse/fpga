`default_nettype none
`timescale 1ns / 1ps


module dsp(clk, reset,
           addr, wr,
           data_in,
           hsync, vsync,
           r, g, b);

    input clk;
    input reset;
    input [13:2] addr;
    input wr;
    input [15:0] data_in;
    output hsync;
    output vsync;
    output [2:0] r;
    output [2:0] g;
    output [2:0] b;

  reg state;

  display display1 (.clk(clk),
                    .dsp_row(addr[13:9]),
                    .dsp_col(addr[8:2]),
                    .dsp_en(wr),
                    .dsp_wr(wr),
                    .dsp_wr_data(data_in[15:0]),
                    .hsync(hsync),
                    .vsync(vsync),
                    .r(r[2:0]),
                    .g(g[2:0]),
                    .b(b[2:0]));

endmodule
