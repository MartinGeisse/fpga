iverilog -s testbench -s glbl -o test.vvp -y ~/verilog-xilinx-primitives/unisims -Itextmode ~/verilog-xilinx-primitives/glbl.v *.v display/*.v external/*.v kbd/*.v ram/*.v ser/*.v serback/*.v textmode/*.v
vvp test.vvp
