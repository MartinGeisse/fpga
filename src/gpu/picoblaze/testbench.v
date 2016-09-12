`default_nettype none
`timescale 1ns / 1ps

module testbench;

	defparam glbl.ROC_WIDTH = 0;

	localparam HALF_CLOCK_CYCLE_DURATION = 5;
	localparam CLOCK_CYCLE_DURATION = 2 * HALF_CLOCK_CYCLE_DURATION;

	reg clk = 0;
	always #HALF_CLOCK_CYCLE_DURATION clk = ~clk;
	
	reg reset = 1;
	initial #(5 * HALF_CLOCK_CYCLE_DURATION) reset = 0;

    reg[63:0] clockCycle = 0;
    always @(posedge clk) begin
        clockCycle <= clockCycle + 1;
    end

    localparam SERIAL_PORT_BIT_DURATION_CLOCKS = 500;
    localparam SERIAL_PORT_BIT_DURATION = SERIAL_PORT_BIT_DURATION_CLOCKS * CLOCK_CYCLE_DURATION;
	reg serialPortDataIn = 1;
    task send;
        input [7:0] value;
        begin
            serialPortDataIn <= 0;
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[0];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[1];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[2];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[3];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[4];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[5];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[6];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= value[7];
            #SERIAL_PORT_BIT_DURATION;
            serialPortDataIn <= 1;
            #SERIAL_PORT_BIT_DURATION;
        end
    endtask
	initial begin
	    #1000
	    send(0);
	    send(10);
	    send(15);
	    send(65);
	    $finish;
	end
	
	display_hello dut1(
		.clk(clk),
		.reset(reset),
		.serialPortDataIn(serialPortDataIn)
	);

	always @(posedge clk) begin
	    if (dut1.cpuReadStrobe) begin
            if (dut1.cpuPortId == 8'h82 && dut1.cpuReadData == 8'h00) begin
                // ignore waiting for a serial port byte
            end else begin
    	        $display("%d: read %h: %h", clockCycle, dut1.cpuPortId, dut1.cpuReadData);
            end
	    end
	    if (dut1.cpuWriteStrobe) begin
	        $display("%d: write %h: %h", clockCycle, dut1.cpuPortId, dut1.cpuWriteData);
	    end
	end
	
endmodule
