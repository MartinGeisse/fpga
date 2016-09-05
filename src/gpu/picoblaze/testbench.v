`default_nettype none
`timescale 1ns / 1ps

module testbench;

	defparam glbl.ROC_WIDTH = 0;

	reg clk = 0;
	always #5 clk = ~clk;
	
	reg reset = 1;
	initial #25 reset = 0;
	
	display_hello dut1(
		.clk(clk),
		.reset(reset)
	);
	
	initial begin
		$monitor("wr %b, port %h, data %h", dut1.cpuWriteStrobe, dut1.cpuPortId, dut1.cpuWriteData);
		#5000
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[0], dut1.dsp1.display1.dspmem1.display_att_lo.mem[0], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[0], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[0]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[1], dut1.dsp1.display1.dspmem1.display_att_lo.mem[1], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[1], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[1]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[2], dut1.dsp1.display1.dspmem1.display_att_lo.mem[2], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[2], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[2]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[3], dut1.dsp1.display1.dspmem1.display_att_lo.mem[3], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[3], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[3]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[4], dut1.dsp1.display1.dspmem1.display_att_lo.mem[4], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[4], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[4]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[5], dut1.dsp1.display1.dspmem1.display_att_lo.mem[5], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[5], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[5]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[6], dut1.dsp1.display1.dspmem1.display_att_lo.mem[6], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[6], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[6]);
		$display("%h%h %h%h", dut1.dsp1.display1.dspmem1.display_att_hi.mem[7], dut1.dsp1.display1.dspmem1.display_att_lo.mem[7], dut1.dsp1.display1.dspmem1.display_chr_hi.mem[7], dut1.dsp1.display1.dspmem1.display_chr_lo.mem[7]);
		#2000
		$finish;
	end
	
endmodule
