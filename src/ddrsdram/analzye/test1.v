
`timescale = 1ns/100ps

module test1();

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

    // inputs from RAM chip (quiet for now)
    reg[15:0] sd_d_io;
    reg sd_udqs_io, sd_ldqs_io;
    initial begin
        sd_d_io <= 0;
        sd_udqs_io <= 0;
        sd_ldqs_io <= 0;
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

    // Wishbone interface (quiet for now)
    wire[25:2] wadr_i = 0;
    wire wstb_i = 0;
    wire wwe_i = 0;
    wire[3:0] wwrb_i = 0;
    wire[31:0] wdat_i = 0;
    wire[31:0] wdat_o;
    wire wack_o;

    // DUT
    SdramInterfaceOriginal sdramInterfaceOriginal(
        
        // clocks and reset
        .clk0(ddr_clk_0),
        .clk90(ddr_clk_90),
        .clk180(ddr_clk_180),
        .clk270(ddr_clk_270),
        .reset(~ddr_clk_ok),

        // SDRAM chip interface
        .sd_ck_p(sdram_ck_p),
        .sd_ck_n(sdram_ck_n),
        .sd_a_o(sdram_a[12:0]),
        .sd_ba_o(sdram_ba[1:0]),
        .sd_d_IO(sdram_dq[15:0]),
        .sd_ras_o(sdram_ras_n),
        .sd_cas_o(sdram_cas_n),
        .sd_we_o(sdram_we_n),
        .sd_udm_o(sdram_udm),
        .sd_ldm_o(sdram_ldm),
        .sd_udqs_io(sdram_udqs),
        .sd_ldqs_io(sdram_ldqs),
        .sd_cs_o(sdram_cs_n),
        .sd_cke_o(sdram_cke),

        // Wishbone interface
        .wadr_i(addr[25:2]),
        .wstb_i(stb),
        .wwe_i(we),
        .wwrb_i(4'b1111),
        .wdat_i(data_in_buf[31:0]),
        .wdat_o(data_out[31:0]),
        .wack_o(ack)
        
    )

endmodule;

