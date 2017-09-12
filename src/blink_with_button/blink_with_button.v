
module blink_with_button(clk, button, led);
    input clk;
    input button;
    output led;

    reg [24:0] counter;
    always @(posedge clk) begin
        counter <= counter +1;
    end

    assign led = counter[24] & button;

endmodule
