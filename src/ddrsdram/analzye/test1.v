
`timescale 1ns/100ps

module test1();

    // simulation control
    initial begin

        // check output clock generation
        // $monitor("%b, %b, %b, %b, %b -- %b, %b", ddr_clk_0, ddr_clk_90, ddr_clk_180, ddr_clk_270, ddr_clk_ok, sd_ck_p, sd_ck_n);
        // #15000;

        // check clock-enable generation
        // $monitor("%d: %b / %d, %d", $time, sd_cke_o, dut.sd_state, dut.init_state);
        // #15_000_000;

        // check periodic refresh commands while idle after startup
        @(dut.init_state === 8);
        @(dut.sd_state == 0);
        $monitor("%d: %d / CSn = %b, RASn = %b, CASn = %b, WEn = %b", $time, dut.sd_state, sd_cs_o, sd_ras_o, sd_cas_o, sd_we_o);
        #10_000_000;

        $finish;
    end

    // clocks
    reg ddr_clk_0, ddr_clk_90, ddr_clk_180, ddr_clk_270, ddr_clk_ok;
    initial begin
        ddr_clk_0 <= 0;
        ddr_clk_90 <= 0;
        ddr_clk_180 <= 1;
        ddr_clk_270 <= 1;
        ddr_clk_ok <= 0;
        #10000;
        ddr_clk_ok <= 1;
    end
    always begin
        #2.5;
        ddr_clk_0 <= ~ddr_clk_0;
        ddr_clk_180 <= ~ddr_clk_180;
        #2.5;
        ddr_clk_90 <= ~ddr_clk_90;
        ddr_clk_270 <= ~ddr_clk_270;
    end

    // outputs to RAM chip (these are tested here)
	wire sd_ck_p;
	wire sd_ck_n;
	wire [12:0] sd_a_o;
	wire [1:0] sd_ba_o;
	wire sd_ras_o;
	wire sd_cas_o;
	wire sd_we_o;
	wire sd_udm_o;
	wire sd_ldm_o;
	wire sd_cs_o;
	wire sd_cke_o;

    // I/O wires to/from RAM chip
    wire[15:0] sd_d_io;
    wire sd_udqs_io, sd_ldqs_io;

    // Wishbone interface (quiet for now)
    wire[25:2] wadr_i = 0;
    wire wstb_i = 0;
    wire wwe_i = 0;
    wire[3:0] wwrb_i = 0;
    wire[31:0] wdat_i = 0;
    wire[31:0] wdat_o;
    wire wack_o;

    // DUT
    SdramInterfaceOriginal dut(
        
        // clocks and reset
        .clk0(ddr_clk_0),
        .clk90(ddr_clk_90),
        .clk180(ddr_clk_180),
        .clk270(ddr_clk_270),
        .reset(~ddr_clk_ok),

        // SDRAM chip interface
        .sd_CK_P(sd_ck_p),
        .sd_CK_N(sd_ck_n),
        .sd_A_O(sd_a_o[12:0]),
        .sd_BA_O(sd_ba_o[1:0]),
        .sd_RAS_O(sd_ras_o),
        .sd_CAS_O(sd_cas_o),
        .sd_WE_O(sd_we_o),
        .sd_UDM_O(sd_udm_o),
        .sd_LDM_O(sd_ldm_o),
        .sd_UDQS_IO(sd_udqs_io),
        .sd_LDQS_IO(sd_ldqs_io),
        .sd_CS_O(sd_cs_o),
        .sd_CKE_O(sd_cke_o),
        .sd_D_IO(sd_d_io[15:0]),

        // Wishbone interface
        .wADR_I(wadr_i),
        .wSTB_I(wstb_i),
        .wWE_I(wwe_i),
        .wWRB_I(wwrb_i),
        .wDAT_I(wdat_i),
        .wDAT_O(wdat_o),
        .wACK_O(wack_o)

    );

endmodule
