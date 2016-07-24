
module testbench;

	reg clk = 0;
	always #5 clk = ~clk;
	
	dut dut1(
		.clk(clk)
	);
	
	initial $monitor("%b %b %b", clk, dut1.counter, dut1.computed);
	initial #300 $finish;
	
endmodule
