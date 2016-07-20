
module display_hello(clk, reset, hsync, vsync, r, g, b);

    input clk;
    input reset;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;

	wire[2:0] wideR;
	wire[2:0] wideG;
	wire[2:0] wideB;
	assign r = wideR[2];
	assign g = wideG[2];
	assign b = wideB[2];

	dsp dsp1 (.clk(clk),
		.dsp_row(addr[13:9]), // TODO
		.dsp_col(addr[8:2]), // TODO
		.dsp_en(en), // TODO
		.dsp_wr(wr), // TODO
		.dsp_wr_data(data_in[15:0]), // TODO
		// .dsp_rd_data(data_out[15:0]), // TODO unused, remove if no problem
		.hsync(hsync),
		.vsync(vsync),
		.r(wideR[2:0]),
		.g(wideG[2:0]),
		.b(wideB[2:0]));

endmodule
