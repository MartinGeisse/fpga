`default_nettype none
`timescale 1ns / 1ps


module Probetest(clk,
		hsync, vsync, r, g, b,
		buttonSouth, buttonWest,
		switches);

	//
	// ports
	//

    input clk;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;
    input buttonSouth;
	input buttonWest;
	input[3:0] switches;


	//
	// trigger generator
	//

	reg[21:0] triggerCounter;
	always @(posedge clk) begin
		triggerCounter <= triggerCounter + 1;
	end
	wire sample = (triggerCounter == 0);


	//
	// probe
	//

	Probe #(
		.LOG2_OF_NUMBER_OF_CHANNELS(2),
		.LOG2_OF_NUMBER_OF_SAMPLES(12),
		.LOG2_OF_X_SCALE(2)
	) probe(
		.clk(clk),
		.start(buttonSouth),
		.sample(sample),
		.reset(buttonWest),
		.dataIn(switches),
		.hsync(hsync),
		.vsync(vsync),
		.r(r),
		.g(g),
		.b(b)
	);

endmodule
