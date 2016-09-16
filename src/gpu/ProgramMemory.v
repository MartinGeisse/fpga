`default_nettype none
`timescale 1ns / 1ps

/**
 * This is a PicoBlaze program memory.
 */
module ProgramMemory (
		
		/** the clock signal **/
		input clk,
		
		/** the current instruction address **/
		input [9:0] address,
		
		/** the instruction **/
		output reg [17:0] instruction
		
	);
	
	reg [17:0] rom [1023:0];
	initial $readmemh("ProgramMemory.mif", rom, 0, 1023);
	always @(posedge clk) begin
		instruction <= rom[address];
	end
	
endmodule

