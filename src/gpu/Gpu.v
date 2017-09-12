`default_nettype none
`timescale 1ns / 1ps


module Gpu(clk, reset, hsync, vsync, r, g, b, serialPortDataIn, displayModeSwitch);

	//
	// ports
	//

    input clk;
    input reset;
    output hsync;
    output vsync;
    output r;
    output g;
    output b;
    input serialPortDataIn;
	input displayModeSwitch;


	//
	// common wiring declarations
	//






	////////////////////////////////////////////////////////////////////////////////
	// output components (as seen from Arduino)
	////////////////////////////////////////////////////////////////////////////////

	//
	// O-CPU
	//
	
	wire[9:0] ocpuInstructionAddress;
	wire[17:0] ocpuInstruction;
	wire[7:0] ocpuPortId;
	wire[7:0] ocpuReadData;
	wire[7:0] ocpuWriteData;
	wire ocpuReadStrobe;
	wire ocpuWriteStrobe;
	wire ocpuInterrupt;
	
	kcpsm3 ocpu (
	
		// system signals
	 	.clk(clk),
	 	.reset(reset),
	 	
	 	// instruction memory
	 	.address(ocpuInstructionAddress),
	 	.instruction(ocpuInstruction),
	 	
	 	// port I/O
	 	.write_strobe(ocpuWriteStrobe),
	 	.read_strobe(ocpuReadStrobe),
	 	.port_id(ocpuPortId),
	 	.out_port(ocpuWriteData),
	 	.in_port(ocpuReadData),
	 	
	 	// interrupts
	 	.interrupt(ocpuInterrupt)
	 	
	);
	
	OcpuProgramMemory ocpuProgramMemory (
		.clk(clk),
		.address(ocpuInstructionAddress),
		.instruction(ocpuInstruction)
	);


	//
	// Display
	//

	reg[6:0] rowIndexRegister;
	wire displayHsync, displayVsync, displayR, displayG, displayB;
	Display display(
		.clk(clk),
		.write(ocpuWriteStrobe & ~ocpuPortId[7]),
		.writeAddress({rowIndexRegister, ocpuPortId[6:0]}),
		.writeData(ocpuWriteData[2:0]),
		.hsync(displayHsync),
		.vsync(displayVsync),
		.r(displayR),
		.g(displayG),
		.b(displayB)
	);
	always @(posedge clk) begin
		if (ocpuWriteStrobe & (ocpuPortId == 8'b10000000)) begin
			rowIndexRegister <= ocpuWriteData[6:0];
		end
	end
	
	
	//
	// Serial Port
	//

	wire serialPortReady;

	ser ser1(
		.clk(clk),
		.reset(reset),
		.en((ocpuWriteStrobe | ocpuReadStrobe) & (ocpuPortId[7:1] == 7'b1000001)),
		.wr(ocpuWriteStrobe),
		.addr(ocpuPortId[0]),
		.data_in(ocpuWriteData),
		.data_out(ocpuReadData),
		.rxd(serialPortDataIn),
		.ready(serialPortReady)
	);

	//
	// wiring
	//

	assign ocpuInterrupt = serialPortReady;





	////////////////////////////////////////////////////////////////////////////////
	// input and debugging components (as seen from Arduino)
	////////////////////////////////////////////////////////////////////////////////

	reg[4:0] textmodeRowIndexRegister;
	reg[6:0] textmodeColumnIndexRegister;

	//
	// I-CPU
	//
	
	wire[9:0] icpuInstructionAddress;
	wire[17:0] icpuInstruction;
	wire[7:0] icpuPortId;
	wire[7:0] icpuReadData;
	wire[7:0] icpuWriteData;
	wire icpuReadStrobe;
	wire icpuWriteStrobe;
	wire icpuInterrupt;
	
	kcpsm3 icpu (
	
		// system signals
	 	.clk(clk),
	 	.reset(reset),
	 	
	 	// instruction memory
	 	.address(icpuInstructionAddress),
	 	.instruction(icpuInstruction),
	 	
	 	// port I/O
	 	.write_strobe(icpuWriteStrobe),
	 	.read_strobe(icpuReadStrobe),
	 	.port_id(icpuPortId),
	 	.out_port(icpuWriteData),
	 	.in_port(icpuReadData),
	 	
	 	// interrupts
	 	.interrupt(icpuInterrupt)
	 	
	);
	
	IcpuProgramMemory icpuProgramMemory (
		.clk(clk),
		.address(icpuInstructionAddress),
		.instruction(icpuInstruction)
	);


	//
	// Textmode display
	//

	always @(posedge clk) begin
		if (icpuWriteStrobe) begin
			if (icpuPortId[0]) begin
				textmodeRowIndexRegister <= icpuWriteData[4:0];
			end
			if (icpuPortId[1]) begin
				textmodeColumnIndexRegister <= icpuWriteData[6:0];
			end
		end
	end
	
	wire textmodeHsync, textmodeVsync, textmodeR, textmodeG, textmodeB;
	textmode_display textmode_display1(
		.clk(clk),
		.dsp_row(textmodeRowIndexRegister),
		.dsp_col(textmodeColumnIndexRegister),
		.dsp_en(icpuPortId[2] & (icpuWriteStrobe | icpuReadStrobe)),
		.dsp_wr(icpuWriteStrobe),
		.dsp_wr_data({8'b00000111, icpuWriteData}),
		.dsp_rd_data(icpuReadData), // TODO doesn't yet work because the display provides data one cycle too late!
		.hsync(textmodeHsync),
		.vsync(textmodeVsync),
		.r(textmodeR),
		.g(textmodeG),
		.b(textmodeB)
	);

	//
	// wiring
	//

	assign icpuInterrupt = 0;





	////////////////////////////////////////////////////////////////////////////////
	// common wiring
	////////////////////////////////////////////////////////////////////////////////

	assign hsync = (displayModeSwitch ? displayHsync : textmodeHsync);
	assign vsync = (displayModeSwitch ? displayVsync : textmodeVsync);
	assign r = (displayModeSwitch ? displayR : textmodeR);
	assign g = (displayModeSwitch ? displayG : textmodeG);
	assign b = (displayModeSwitch ? displayB : textmodeB);


endmodule
