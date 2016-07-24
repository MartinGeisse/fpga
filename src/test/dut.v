
module dut(clk);

	input clk;

	reg[3:0] counter;
	initial counter = 0;
	always @(posedge clk) begin
		counter <= counter + 1;
	end
	
	wire computed;
	// synthesis translate_off 
	defparam myLut.INIT = 16'h6555;
	// synthesis translate_on 
	LUT4 myLut (
		.I0(counter[0]),
		.I1(counter[1]),
		.I2(counter[2]),
		.I3(counter[3]),
		.O(computed)
	)/* synthesis xc_props = "INIT=6555"*/;
	
endmodule
