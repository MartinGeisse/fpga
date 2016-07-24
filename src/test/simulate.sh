iverilog -o testbench.vvp -y ~/verilog-xilinx-primitives/unisims ~/verilog-xilinx-primitives/glbl.v dut.v testbench.v
vvp testbench.vvp
