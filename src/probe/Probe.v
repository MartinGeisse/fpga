`default_nettype none
`timescale 1ns / 1ps

module Probe(clk, start, sample, reset, dataIn, hsync, vsync, r, g, b);

	parameter LOG2_OF_NUMBER_OF_CHANNELS = 4;
	parameter LOG2_OF_NUMBER_OF_SAMPLES = 8;
	parameter LOG2_OF_X_SCALE = 5;
	parameter LOG2_OF_Y_SCALE = 4;

	localparam NUMBER_OF_CHANNELS = 1 << LOG2_OF_NUMBER_OF_CHANNELS;
	localparam NUMBER_OF_SAMPLES = 1 << LOG2_OF_NUMBER_OF_SAMPLES;
	localparam STOP_DRAWING_PIXEL_ROW = NUMBER_OF_CHANNELS << (LOG2_OF_Y_SCALE + 1);

	input clk;
	input start, sample, reset;
	input[NUMBER_OF_CHANNELS - 1:0] dataIn;
	output hsync, vsync, r, g, b;


	//
	// sampling memory
	//
	
	reg started;
	reg[NUMBER_OF_CHANNELS - 1:0] memory[NUMBER_OF_SAMPLES - 1:0];
	reg[LOG2_OF_NUMBER_OF_SAMPLES:0] numberOfSamplesRecorded;

	initial begin
		started <= 0;
		numberOfSamplesRecorded <= 0;
	end

	always @(posedge clk) begin
		if (reset) begin
			started <= 0;
			numberOfSamplesRecorded <= 0;
		end else begin
			if (start) begin
				started <= 1;
			end
			if ((start | started) & sample) begin
				memory[numberOfSamplesRecorded] <= dataIn;
				numberOfSamplesRecorded <= numberOfSamplesRecorded + 1;
			end
		end
	end
	

	//
	// VGA output
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
	ProbeVgaTiming vgaTiming(
		.clk(clk),
		.x(stage1x),
		.y(stage1y),
		.hsync(stage1hsync),
		.vsync(stage1vsync),
		.blank(stage1blank)
	);


	//
	// stage 1
	//

	//
	// stage 1 -> 2
	//

	reg stage2WithinDrawingWindowX;
	always @(posedge clk) begin
		if (stage1x >> LOG2_OF_X_SCALE == numberOfSamplesRecorded) begin
			stage2WithinDrawingWindowX <= 0;
		end else if (stage1x == 0) begin
			stage2WithinDrawingWindowX <= 1;
		end
	end

	reg[LOG2_OF_NUMBER_OF_SAMPLES - 1:0] stage2SampleIndex;
	always @(posedge clk) begin
		stage2SampleIndex <= stage1x >> LOG2_OF_X_SCALE;
	end

	reg stage2WithinDrawingWindowY;
	always @(posedge clk) begin
		if (stage1y == STOP_DRAWING_PIXEL_ROW) begin
			stage2WithinDrawingWindowY <= 0;
		end else if (stage1y == 0) begin
			stage2WithinDrawingWindowY <= 1;
		end
	end

	reg[LOG2_OF_NUMBER_OF_CHANNELS - 1:0] stage2ChannelIndex;
	always @(posedge clk) begin
		stage2ChannelIndex <= stage1y >> (LOG2_OF_Y_SCALE + 1);
	end

	reg stage2AtBackgroundBar, stage2AtPixelBar;
	always @(posedge clk) begin
		stage2AtBackgroundBar <= ~stage1y[LOG2_OF_Y_SCALE];
		stage2AtPixelBar <= (stage1y[LOG2_OF_Y_SCALE - 1 : 0] == 0);
	end

	reg stage2hsync, stage2vsync, stage2blank;
	always @(posedge clk) begin
		stage2hsync <= stage1hsync;
		stage2vsync <= stage1vsync;
		stage2blank <= stage1blank | stage1x[9] | stage1y[9];
	end


	//
	// stage 2 -> 3
	//

	reg[NUMBER_OF_CHANNELS - 1:0] stage3Sample;
	always @(posedge clk) begin
		stage3Sample <= memory[stage2SampleIndex];
	end

	reg[LOG2_OF_NUMBER_OF_CHANNELS - 1:0] stage3ChannelIndex;
	always @(posedge clk) begin
		stage3ChannelIndex <= stage2ChannelIndex;
	end

	reg stage3AtBackgroundBar, stage3AtPixelBar;
	always @(posedge clk) begin
		stage3AtBackgroundBar <= stage2AtBackgroundBar;
		stage3AtPixelBar <= stage2AtPixelBar;
	end

	reg stage3hsync, stage3vsync, stage3blank;
	always @(posedge clk) begin
		stage3hsync <= stage2hsync;
		stage3vsync <= stage2vsync;
		stage3blank <= stage2blank | ~stage2WithinDrawingWindowX | ~stage2WithinDrawingWindowY;
	end


	//
	// stage 3
	//

	wire stage3BitValue = stage3Sample[stage3ChannelIndex];

	//
	// stage 3 -> 4
	//
	
	reg stage4r, stage4g, stage4b, stage4hsync, stage4vsync;
	always @(posedge clk) begin
		if (stage3blank) begin
			stage4r <= 0;
			stage4g <= 0;
			stage4b <= 0;
		end else if (stage3AtPixelBar & (stage3AtBackgroundBar ^ stage3BitValue)) begin
			stage4r <= 1;
			stage4g <= 1;
			stage4b <= 1;
		end else begin
			stage4r <= 0;
			stage4g <= 0;
			stage4b <= stage3AtBackgroundBar;
		end
		stage4hsync <= stage3hsync;
		stage4vsync <= stage3vsync;
	end


	//
	// output
	//

	assign hsync = stage4hsync;
	assign vsync = stage4vsync;
	assign r = stage4r;
	assign g = stage4g;
	assign b = stage4b;

endmodule
