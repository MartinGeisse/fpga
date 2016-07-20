
module display_hello(clk, reset, hsync, vsync, r, g, b);

    input clk;
    input reset;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;

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

	dsp dsp1 (.clk(clk),
		.dsp_row(rowIndexRegister[4:0]),
		.dsp_col(addr[8:2]), // TODO
		.dsp_en(en), // TODO
		.dsp_wr(wr), // TODO
		.dsp_wr_data(data_in[15:0]), // TODO
		// .dsp_rd_data(data_out[15:0]), // TODO unused, remove if no problem
		.hsync(hsync),
		.vsync(vsync),
		.r(wideR),
		.g(wideG),
		.b(wideB)
	);

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
	 	.interrupt(0),
	 	
	);
	
	// TODO instruction memory

	//
	// port wiring
	//
	
	// TODO

endmodule
