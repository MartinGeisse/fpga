set -e
iverilog -Wall -s test1 -s glbl -o test1.vvp -y ~/verilog-xilinx-primitives/unisims ~/verilog-xilinx-primitives/glbl.v test1.v SdramInterface.v SdramInterfaceOriginal.v
vvp test1.vvp
