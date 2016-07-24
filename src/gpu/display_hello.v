`default_nettype none
`timescale 1ns / 1ps


module display_hello(clk, reset, hsync, vsync, r, g, b, serialPortDataIn);

    input clk;
    input reset;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;
    input serialPortDataIn;


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
	 	.interrupt(0)
	 	
	);
	
	ProgramMemory programMemory (
		.clk(clk),
		.address(cpuInstructionAddress),
		.instruction(cpuInstruction)
	);


	//
	// Display
	//

	wire[2:0] wideR;
	assign r = wideR[2];
	wire[2:0] wideG;
	assign g = wideG[2];
	wire[2:0] wideB;
	assign b = wideB[2];
	reg[4:0] rowIndexRegister;

	dsp dsp1 (
		.clk(clk),
		.reset(reset),
		.addr({rowIndexRegister[4:0], cpuPortId[6:0]}),
		.en(cpuWriteStrobe & ~cpuPortId[7]),
		.wr(1),
		.data_in({8'b00001111, cpuWriteData}),
		.hsync(hsync),
		.vsync(vsync),
		.r(wideR),
		.g(wideG),
		.b(wideB)
	);
	
	always @(posedge clk) begin
		if (cpuWriteStrobe & (cpuPortId == 8'b10000000)) begin
			rowIndexRegister <= cpuWriteData[4:0];
		end
	end
	
	
	//
	// Serial Port
	//
	ser ser1(
		.clk(clk),
		.reset(reset),
		.en((cpuWriteStrobe | cpuReadStrobe) & (cpuPortId == 8'b1000001x)),
		.wr(cpuWriteStrobe),
		.addr(cpuPortId[0]),
		.data_in(cpuWriteData),
		.data_out(cpuReadData),
		.rdx(serialPortDataIn)
	);

endmodule
