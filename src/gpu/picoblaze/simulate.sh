iverilog -o testbench.vvp -y ~/verilog-xilinx-primitives/unisims ~/verilog-xilinx-primitives/glbl.v display_hello.v ProgramMemory.v external/kcpsm3.v dsp/*.v testbench.v
vvp testbench.vvp
