`default_nettype none
`timescale 1ns / 1ps

module BitPlotter(clk, start, clear, bitIn, r, g, b, hsync, vsync);
    input clk;
	input start, clear;
	input bitIn;
	output reg r, g, b, hsync, vsync;

	// ------------------------
	// data-in sampling
	// ------------------------

	reg running;
	initial running <= 0;
	always @(posedge clk) begin
		if (clear) begin
			running <= 0;
		end else if (start) begin
			running <= 1;
		end
	end

	reg writeEnable;
	reg[12:0] prescaleCounter;
	reg[13:0] writeIndex;
	initial begin
		writeEnable <= 0;
		prescaleCounter <= 0;
		writeIndex <= 0;
	end
	always @(posedge clk) begin
		if (clear) begin
			writeEnable <= 0;
			prescaleCounter <= 0;
			writeIndex <= 0;
		end else if (running) begin
			if (prescaleCounter == 0) begin
				writeEnable <= 1;
				if (writeIndex != 14'b11111111111111) begin
					writeIndex <= writeIndex + 1;
				end
			end else begin
				writeEnable <= 0;
			end
			prescaleCounter <= prescaleCounter + 1;
		end
	end

	// ------------------------
	// VGA pipeline 0->1
	// ------------------------

	wire[9:0] vga1x;
	wire[9:0] vga1y;
	wire vga1hsync, vga1vsync, vga1blank;
	VgaTiming vgaTiming(
		.clk(clk),
		.x(vga1x),
		.y(vga1y),
		.hsync(vga1hsync),
		.vsync(vga1vsync),
		.blank(vga1blank)
	);

	// ------------------------
	// VGA pipeline 1
	// ------------------------

	wire[13:0] vga1index;
	assign vga1index = {vga1y[7:3], vga1x[8:0]};

	// ------------------------
	// VGA pipeline 1->2
	// ------------------------

	reg vga2endOfDataReached;
	initial vga2endOfDataReached <= 0;
	always @(posedge clk) begin
		if (vga1y[9]) begin
			vga2endOfDataReached <= 0;
		end else if (vga1index == writeIndex) begin
			vga2endOfDataReached <= 1;
		end
	end

	reg vga2hsync, vga2vsync, vga2blank;
	always @(posedge clk) begin
		vga2hsync <= vga1hsync;
		vga2vsync <= vga1vsync;
		vga2blank <= vga1blank | vga1y[0] | vga1y[1] | vga1y[2] | vga1x[9] | vga1y[8] | vga1y[9];
	end

	wire vga2dataBit;
	RAMB16_S1_S1 storage (

		// write port (data sampling)
		.CLKA(clk),
		.ENA(writeEnable),
		.SSRA(1'b0),
		.WEA(1'b1),
		.ADDRA(writeIndex),
		.DIA(bitIn),

		// read port (VGA)
		.CLKB(clk),
		.ENB(1'b1),
		.SSRB(1'b0),
		.WEB(1'b0),
		.ADDRB(vga1index),
		.DOB(vga2dataBit)

	);

	// ------------------------
	// VGA pipeline 2
	// ------------------------

	wire vga2combinedBlank;
	assign vga2combinedBlank = vga2blank | vga2endOfDataReached;

	// ------------------------
	// VGA pipeline 2->3
	// ------------------------

	always @(posedge clk) begin
		r <= (vga2combinedBlank ? 0 : ~vga2dataBit);
		g <= (vga2combinedBlank ? 0 : vga2dataBit);
		b <= 0;
		hsync <= vga2hsync;
		vsync <= vga2vsync;
	end

endmodule
