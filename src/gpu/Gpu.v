`default_nettype none
`timescale 1ns / 1ps


module Gpu(rawClk, reset,
		hsync, vsync, r, g, b, displayModeSwitch,
		serialPortDataIn,
		keyboardPs2Clk, keyboardPs2Data,
		backwardsSerialPortDataOutNegated,
		sdram_ck_p, sdram_ck_n, sdram_cke, sdram_cs_n, sdram_ras_n, sdram_cas_n, sdram_we_n, sdram_ba, sdram_a, sdram_udm, sdram_ldm, sdram_udqs, sdram_ldqs, sdram_dq);

	//
	// ports
	//

    input rawClk;
    input reset; // TODO synchronize
    output hsync;
    output vsync;
    output r;
    output g;
    output b;
    input serialPortDataIn;
	input displayModeSwitch;
	input keyboardPs2Clk;
	input keyboardPs2Data;
	output backwardsSerialPortDataOutNegated;

    output sdram_ck_p;
    output sdram_ck_n;
    output sdram_cke;
    output sdram_cs_n;
    output sdram_ras_n;
    output sdram_cas_n;
    output sdram_we_n;
    output[1:0] sdram_ba;
    output[12:0] sdram_a;
    output sdram_udm;
    output sdram_ldm;
    inout sdram_udqs;
    inout sdram_ldqs;
    inout[15:0] sdram_dq;


	//
	// common wiring declarations
	//


	//
	// clocks
	//

	wire clk, ddrClk, ddrClk90, ddrClk180, ddrClk270, ddrClkOk;
	ClockManager clockManager1(
		.clk_in(rawClk),
		.clk(clk),
		.ddr_clk_0(ddrClk),
		.ddr_clk_90(ddrClk90),
		.ddr_clk_180(ddrClk180),
		.ddr_clk_270(ddrClk270),
		.ddr_clk_ok(ddrClkOk)
	);



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
	wire[15:0] textmodeDisplayDataOut;
	textmode_display textmodeDisplay1(
		.clk(clk),
		.dsp_row(textmodeRowIndexRegister),
		.dsp_col(textmodeColumnIndexRegister),
		.dsp_en(icpuPortId[2] & (icpuWriteStrobe | icpuReadStrobe)),
		.dsp_wr(icpuWriteStrobe),
		.dsp_wr_data({8'b00000111, icpuWriteData}),
		.dsp_rd_data(textmodeDisplayDataOut), // TODO doesn't yet work because the display provides data one cycle too late!
		.hsync(textmodeHsync),
		.vsync(textmodeVsync),
		.r(textmodeR),
		.g(textmodeG),
		.b(textmodeB)
	);


	//
	// keyboard input
	//

	wire keyboardPs2Clk, keyboardPs2Data;
	wire[7:0] keyboardDataOut;
	kbd keyboardInterface1(
		.clk(clk),
		.rst(reset),
        .stb(icpuReadStrobe & icpuPortId[4]),
		.we(0),
		.addr(icpuPortId[3]),
        .data_out(keyboardDataOut),
        .ps2_clk(keyboardPs2Clk),
		.ps2_data(keyboardPs2Data)
	);


	//
	// serial port (backwards direction)
	//

	wire[7:0] serbackDataOut;
	wire backwardsSerialPortDataOut;
	serback serback1(
		.clk(clk),
		.rst(reset),
        .stb((icpuReadStrobe | icpuWriteStrobe) & icpuPortId[5]),
		.we(icpuWriteStrobe),
        .data_in(icpuWriteData),
		.data_out(serbackDataOut),
		.txd(backwardsSerialPortDataOut)
	);


	//
	// SDRAM
	//

	wire accessSdramInterface;
	assign accessSdramInterface = (icpuReadStrobe | icpuWriteStrobe) & icpuPortId[7];

	reg sdramInterfaceStb, sdramInterfaceWe;
	reg[25:2] sdramInterfaceAddressRegister;
	reg[31:0] sdramInterfaceWriteDataRegister;
	wire[31:0] sdramInterfaceReadData;
	reg[31:0] sdramInterfaceReadDataRegister;
	reg sdramInterfaceReady;
	wire sdramInterfaceAck;
	SdramInterface SdramInterface1(
		.clk(clk),
		.rst(reset),
		.ddr_clk_0(ddrClk),
		.ddr_clk_90(ddrClk90),
		.ddr_clk_180(ddrClk180),
		.ddr_clk_270(ddrClk270),
		.ddr_clk_ok(ddrClkOk),
		.stb(sdramInterfaceStb),
		.we(sdramInterfaceWe),
		.addr(sdramInterfaceAddressRegister),
		.data_in(sdramInterfaceWriteDataRegister),
		.data_out(sdramInterfaceReadData),
		.ack(sdramInterfaceAck),
		.sdram_ck_p(sdram_ck_p),
		.sdram_ck_n(sdram_ck_n),
		.sdram_cke(sdram_cke),
		.sdram_cs_n(sdram_cs_n),
		.sdram_ras_n(sdram_ras_n),
		.sdram_cas_n(sdram_cas_n),
		.sdram_we_n(sdram_we_n),
		.sdram_ba(sdram_ba),
		.sdram_a(sdram_a),
		.sdram_udm(sdram_udm),
		.sdram_ldm(sdram_ldm),
		.sdram_udqs(sdram_udqs),
		.sdram_ldqs(sdram_ldqs),
		.sdram_dq(sdram_dq)
	);
	always @(posedge clk) begin
		// This is not Wishbone compliant, but OK for the SDRAM interface: the stb signal is high only for one
		// cycle. That cycle is delayed by one WRT the R/W pulse of the Pico, since the address and write-data
		// also are. The latter are registered and stay constant during the whole operation, which the SDRAM
		// interface needs.
		sdramInterfaceStb <= accessSdramInterface;
		if (accessSdramInterface) begin
			sdramInterfaceWe <= icpuWriteStrobe;
			sdramInterfaceAddressRegister[25:2] <= {17'd0, icpuPortId[6:0]};
			if (icpuWriteStrobe) begin
				sdramInterfaceWriteDataRegister <= {24'd0, icpuWriteData};
			end else begin
				sdramInterfaceWriteDataRegister <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end
		end
		if (sdramInterfaceAck) begin
			sdramInterfaceReadDataRegister <= sdramInterfaceReadData;
			sdramInterfaceReady <= 1;
		 end else if (accessSdramInterface) begin
			sdramInterfaceReady <= 0;
		 end
	end


	//
	// wiring
	//

	assign icpuInterrupt = 0;
	assign icpuReadData = 
		icpuPortId[4] ? keyboardDataOut :
		icpuPortId[5] ? serbackDataOut :
		icpuPortId[6] ? (icpuPortId[3] ? sdramInterfaceReadDataRegister[7:0] : {7'd0, sdramInterfaceReady}) :
		textmodeDisplayDataOut[7:0];
	assign backwardsSerialPortDataOutNegated = ~backwardsSerialPortDataOut;



	////////////////////////////////////////////////////////////////////////////////
	// common wiring
	////////////////////////////////////////////////////////////////////////////////

	assign hsync = (displayModeSwitch ? displayHsync : textmodeHsync);
	assign vsync = (displayModeSwitch ? displayVsync : textmodeVsync);
	assign r = (displayModeSwitch ? displayR : textmodeR);
	assign g = (displayModeSwitch ? displayG : textmodeG);
	assign b = (displayModeSwitch ? displayB : textmodeB);


endmodule
