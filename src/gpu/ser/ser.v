module ser(clk, reset,
           en, wr, addr,
           data_in, data_out,
	   rxd, ready);
    input clk;
    input reset;
    input en;
    input wr;
    input addr;
    input [7:0] data_in;
    output reg [7:0] data_out;
    input rxd;
    output ready;

  wire rd_rcv_data;
  assign rd_rcv_data = (en == 1 && wr == 0 && addr == 1'b1) ? 1 : 0;

  wire rcv_ready;
  wire [7:0] rcv_data;
  rcvbuf rcvbuf1(clk, reset, rd_rcv_data, rcv_ready, rcv_data, rxd);

  always @(*) begin
    case (addr)
      1'b0:
        // rcv ctrl
        data_out = { 7'b0000000, rcv_ready };
      1'b1:
        // rcv data
        data_out = rcv_data;
      default:
        data_out = 8'hxx;
    endcase
  end

  assign ready = rcv_ready;

endmodule
