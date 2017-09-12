`default_nettype none
`timescale 1ns / 1ps


module Gpu(clk, reset, hsync, vsync, r, g, b, serialPortDataIn);

    input clk;
    input reset;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;
    input serialPortDataIn;



	////////////////////////////////////////////////////////////////////////////////
	// output components (as seen from Arduino)
	////////////////////////////////////////////////////////////////////////////////

	//
	// CPU
	//
	
	wire[9:0] cpuInstructionAddress;
	wire[17:0] cpuInstruction;
	wire[7:0] cpuPortId;
	wire[7:0] cpuReadData;
	wire[7:0] cpuWriteData;
	wire cpuReadStrobe;
	wire cpuWriteStrobe;
	wire cpuInterrupt;
	
	kcpsm3 cpu (
	
		// system signals
	 	.clk(clk),
	 	.reset(reset),
	 	
	 	// instruction memory
	 	.address(cpuInstructionAddress),
	 	.instruction(cpuInstruction),
	 	
	 	// port I/O
	 	.write_strobe(cpuWriteStrobe),
	 	.read_strobe(cpuReadStrobe),
	 	.port_id(cpuPortId),
	 	.out_port(cpuWriteData),
	 	.in_port(cpuReadData),
	 	
	 	// interrupts
	 	.interrupt(cpuInterrupt)
	 	
	);
	
	ProgramMemory programMemory (
		.clk(clk),
		.address(cpuInstructionAddress),
		.instruction(cpuInstruction)
	);


	//
	// Display
	//

	reg[6:0] rowIndexRegister;
	Display display(
		.clk(clk),
		.write(cpuWriteStrobe & ~cpuPortId[7]),
		.writeAddress({rowIndexRegister, cpuPortId[6:0]}),
		.writeData(cpuWriteData[2:0]),
		.hsync(hsync),
		.vsync(vsync),
		.r(r),
		.g(g),
		.b(b)
	);
	always @(posedge clk) begin
		if (cpuWriteStrobe & (cpuPortId == 8'b10000000)) begin
			rowIndexRegister <= cpuWriteData[6:0];
		end
	end
	
	
	//
	// Serial Port
	//

	wire serialPortReady;

	ser ser1(
		.clk(clk),
		.reset(reset),
		.en((cpuWriteStrobe | cpuReadStrobe) & (cpuPortId[7:1] == 7'b1000001)),
		.wr(cpuWriteStrobe),
		.addr(cpuPortId[0]),
		.data_in(cpuWriteData),
		.data_out(cpuReadData),
		.rxd(serialPortDataIn),
		.ready(serialPortReady)
	);

	//
	// wiring
	//

	assign cpuInterrupt = serialPortReady;






	////////////////////////////////////////////////////////////////////////////////
	// input and debugging components (as seen from Arduino)
	////////////////////////////////////////////////////////////////////////////////



endmodule
