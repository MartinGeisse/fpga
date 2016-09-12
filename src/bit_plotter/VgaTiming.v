`default_nettype none
`timescale 1ns / 1ps

module VgaTiming(clk, x, y, hsync, vsync, blank);
	input clk;
	output reg [9:0] x;
	output reg [9:0] y;
	output reg hsync;
	output reg vsync;
	output blank;

	reg z;
	reg xblank, yblank;

	initial begin
		p <= 0;
		x <= 0;
		y <= 0;
		hsync <= 1;
		vsync <= 1;
		xblank <= 0;
		yblank <= 0;
	end

	always @(posedge clk) begin
		if (p == 1) begin
			p <= 0;
			if (x == 799) begin
				x <= 0;
				xblank <= 0;
				if (y == 524) begin
					y <= 0;
					yblank <= 0;
				end else begin
					if (y == 479) begin
						yblank <= 1;
					end else if (y == 489) begin
						vsync <= 0;
					end else if (y == 491) begin
						vsync <= 1;
					end
					y <= y + 1;
				end
			end else begin
				if x == 639 begin
					xblank <= 1;
				end else if (x == 655) begin
					hsync <= 0;
				end else if (x == 751) begin
					hsync <= 1;
				end
				x <= x + 1;
			end
		end else begin
			p <= p + 1;
		end
	end

	assign blank = xblank | yblank;

endmodule
