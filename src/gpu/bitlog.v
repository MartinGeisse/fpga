/**
 * Samples a 1-bit input signal and stores it as a sequence of 32-bit RLE lengths
 * in a memory that can be read back. The input is assumed to be initially 0, so if
 * it is actually 1, the stored lengths start with a 0 entry.
 */
module bitlog(clk, reset, bitIn, readEnable, readIndex, readData, readWait);
	input clk, reset;
	input bitIn;
	input readEnable;
	input[8:0] readIndex;
	output[31:0] readData;
	output reg readWait;

	// input edge detection
	reg previousBitIn;
	initial begin
		previousBitIn <= 0;
	end
	always @(posedge clk) begin
		previousBitIn <= (reset ? 0 : bitIn);
	end
	wire isEdge;
	assign isEdge = (bitIn != previousBitIn);

	// length measurement
	reg[31:0] currentLength;
	initial begin
		currentLength <= 0;
	end
	always @(posedge clk) begin
		if (isEdge || reset) begin
			currentLength <= 0;
		end else begin
			currentLength <= currentLength + 1;
		end
	end

	// index counter
	reg[8:0] currentIndex;
	initial begin
		currentIndex <= 0;
	end
	always @(posedge clk) begin
		if (reset) begin
			currentIndex <= 0;
		end else if (isEdge) begin
			currentIndex <= currentIndex + 1;
		end
	end

	// length memory
	RAMB16_S36_S36 lengthMemory (

		// logging port
		.CLKA(clk),
		.ENA(isEdge),
		.SSRA(1'b0),
		.ADDRA(currentIndex),
		.WEA(1'b1),
		.DIA(currentLength),
		.DIPA(4'b0),
		
		// read port
		.CLKB(clk),
		.ENB(1'b1),
		.SSRB(1'b0),
		.ADDRB(readIndex),
		.WEB(1'b0),
		.DOB(readData)

	);

	// Read-wait signal. Note that back-to-back reads are not supported by
	// the bus protocol.
	initial begin
		readWait <= 0;
	end
	always @(posedge clk) begin
		if (reset) begin
			readWait <= 1;
		end else if (readEnable) begin
			readWait <= ~readWait;
		end else begin
			readWait <= 1;
		end
	end

endmodule
