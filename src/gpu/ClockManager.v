//
// clk_rst.v -- clock and reset generator
//


`timescale 1ns/10ps
`default_nettype none


module ClockManager(clk_in,
               ddr_clk_0, ddr_clk_90, ddr_clk_180,
               ddr_clk_270, ddr_clk_ok, clk);
    input clk_in;
    output ddr_clk_0;
    output ddr_clk_90;
    output ddr_clk_180;
    output ddr_clk_270;
    output ddr_clk_ok;
    output clk;

  wire clk50_in;
  wire clk50_out;
  wire clk50_ok;
  wire clk100_out;
  wire clk100_in;
  wire clk100_0;
  wire clk100_90;
  wire clk100_180;
  wire clk100_270;
  wire clk100_ok;

  //------------------------------------------------------------

  IBUFG clk_in_buffer(
    .I(clk_in),
    .O(clk50_in)
  );

  DCM_SP dcm50(
    .RST(1'b0),
    .CLKIN(clk50_in),
    .CLKFB(clk),
    .CLK0(clk50_out),
    .CLK2X(clk100_out),
    .LOCKED(clk50_ok),
    .PSCLK(1'b0),
    .PSEN(1'b0),
    .PSINCDEC(1'b0)
  );

  defparam dcm50.CLKDV_DIVIDE = 2.0;
  defparam dcm50.CLKFX_DIVIDE = 1;
  defparam dcm50.CLKFX_MULTIPLY = 4;
  defparam dcm50.CLKIN_DIVIDE_BY_2 = "FALSE";
  defparam dcm50.CLKIN_PERIOD = 20.0;
  defparam dcm50.CLKOUT_PHASE_SHIFT = "NONE";
  defparam dcm50.CLK_FEEDBACK = "1X";
  defparam dcm50.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
  defparam dcm50.DLL_FREQUENCY_MODE = "LOW";
  defparam dcm50.DUTY_CYCLE_CORRECTION = "TRUE";
  defparam dcm50.PHASE_SHIFT = 0;
  defparam dcm50.STARTUP_WAIT = "FALSE";

  BUFG clk50_buffer(
    .I(clk50_out),
    .O(clk)
  );

  BUFG clk100_buffer(
    .I(clk100_out),
    .O(clk100_in)
  );

  //------------------------------------------------------------

  DCM_SP dcm100(
    .RST(~clk50_ok),
    .CLKIN(clk100_in),
    .CLKFB(ddr_clk_0),
    .CLK0(clk100_0),
    .CLK90(clk100_90),
    .CLK180(clk100_180),
    .CLK270(clk100_270),
    .LOCKED(clk100_ok),
    .PSCLK(1'b0),
    .PSEN(1'b0),
    .PSINCDEC(1'b0)
  );

  defparam dcm100.CLKDV_DIVIDE = 2.0;
  defparam dcm100.CLKFX_DIVIDE = 1;
  defparam dcm100.CLKFX_MULTIPLY = 4;
  defparam dcm100.CLKIN_DIVIDE_BY_2 = "FALSE";
  defparam dcm100.CLKIN_PERIOD = 10.0;
  defparam dcm100.CLKOUT_PHASE_SHIFT = "NONE";
  defparam dcm100.CLK_FEEDBACK = "1X";
  defparam dcm100.DESKEW_ADJUST = "SYSTEM_SYNCHRONOUS";
  defparam dcm100.DLL_FREQUENCY_MODE = "LOW";
  defparam dcm100.DUTY_CYCLE_CORRECTION = "TRUE";
  defparam dcm100.PHASE_SHIFT = 0;
  defparam dcm100.STARTUP_WAIT = "FALSE";

  BUFG clk100_0_buffer(
    .I(clk100_0),
    .O(ddr_clk_0)
  );

  BUFG clk100_90_buffer(
    .I(clk100_90),
    .O(ddr_clk_90)
  );

  BUFG clk100_180_buffer(
    .I(clk100_180),
    .O(ddr_clk_180)
  );

  BUFG clk100_270_buffer(
    .I(clk100_270),
    .O(ddr_clk_270)
  );

  assign ddr_clk_ok = clk100_ok;

endmodule
