`default_nettype none
`timescale 1ns / 1ps

/*
 * Display size: 128x96 (2^7 * 0.75 * 2^7)
 */
module Display(clk, write, writeAddress, writeData, hsync, vsync, r, g, b);

	input clk;
	input write;
	input[13:0] writeAddress;
	input[2:0] writeData;
	output hsync;
	output vsync;
	output r;
	output g;
	output b;

	//
	// Note about naming: (stage N) contains logic; (stage N -> N + 1) is the transition that loads the pipeline
	// registers. Signals named (stage N) are valid during stage N.
	//

	//
	// stage 0 -> 1
	//

	wire[9:0] stage1x;
	wire[9:0] stage1y;
	wire stage1hsync, stage1vsync, stage1blank;
	VgaTiming vgaTiming(
		.clk(clk),
		.x(stage1x),
		.y(stage1y),
		.hsync(stage1hsync),
		.vsync(stage1vsync),
		.blank(stage1blank)
	);

	//
	// stage 1 -> 2
	//

	reg[3:0] frameBuffer[12287:0];
	reg[3:0] stage2pixel;
	always @(posedge clk) begin
		if (write) begin
			frameBuffer[writeAddress] <= {1'b0, writeData};
		end
		stage2pixel = frameBuffer[{stage1y[8:2], stage1x[8:2]}];
	end

	reg stage2hsync, stage2vsync, stage2blank;
	always @(posedge clk) begin
		stage2hsync <= stage1hsync;
		stage2vsync <= stage1vsync;
		stage2blank <= stage1blank | stage1x[9] | stage1y[9];
	end

	//
	// assign output signals from stage 2 signals
	//

	assign hsync = stage2hsync;
	assign vsync = stage2vsync;
	assign r = stage2blank ? 1'b0 : stage2pixel[2];
	assign g = stage2blank ? 1'b0 : stage2pixel[1];
	assign b = stage2blank ? 1'b0 : stage2pixel[0];

endmodule
