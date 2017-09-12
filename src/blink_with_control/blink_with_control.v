
module blink_with_control(clk, enable, fast, led);
    input clk;
    input enable, fast;
    output led;

    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter +1;
    end

    assign led = counter[fast ? 23 : 24] & enable;

endmodule
