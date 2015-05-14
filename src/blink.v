
module blink(clk, led);
    output led;
    input  clk;

    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter +1;
    end

    assign led = counter[24];

endmodule
