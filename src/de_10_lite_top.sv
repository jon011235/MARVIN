/*
    Project:    MARVIN
    Sector:     TOP
    Summary:    Toplevel design file, dedicated to pll instantiations and io-formatting
    Device:     terasIC® DE10-Lite Development Board with Altera® MAX 10 10M50DAF484C7G FPGA
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module de_10_lite_top (
    // ===== CLOCKS ======================================================
    input clk_10,                   // 10MHz clock (for ADCs)   3.3V LVTTL

    input clk1_50,                  // 50MHz primary clock      3.3V LVTTL

    input clk2_50,                  // 50MHz secondary clock    3.3V LVTTL

    // ===== BASIC IN ====================================================
    input [1:0] key_,               // Push buttons             3.3V Schmitt

    input [9:0] sw,                 // Toggle switches          3.3V LVTTL

    // ===== BASIC OUT ===================================================
    output [9:0] ledr,              // Red leds                 3.3V LVTTL

    output pkg::seg7p_t [5:0] hex_, // 8-element hex displays   3.3V LVTTL

    // ===== BASIC IO ====================================================
    inout [35:0] gpio,              // Expansion header         3.3V LVTTL

    // ===== ARDUINO =====================================================
    inout [15:0] ardu_gpio,         // Arduino connector        3.3V LVTTL
    inout ardu_rst_,                // Arduino reset            3.3V Schmitt

    // ===== VGA =========================================================
    output pkg::color_t vga_color,    // VGA color output       3.3V LVTTL
    output vga_hs,                  // VGA horizontal sync      3.3V LVTTL
    output vga_vs,                  // VGA vertical sync        3.3V LVTTL

    // ===== SDRAM =======================================================
    output [12:0] dram_addr,        // SDRAM address            3.3V LVTTL
    inout [15:0] dram_dq,           // SDRAM data bus           3.3V LVTTL
    output [1:0] dram_bank,         // SDRAM bank address       3.3V LVTTL
    output [1:0] dram_qdm,          // SDRAM bit mask           3.3V LVTTL
    output dram_ras_,               // SDRAM row address strobe 3.3V LVTTL
    output dram_cas_,               // SDRAM col address strobe 3.3V LVTTL
    output dram_cke,                // SDRAM clock enable       3.3V LVTTL
    output dram_clk,                // SDRAM clock              3.3V LVTTL
    output dram_re,                 // SDRAM read enable        3.3V LVTTL
    output dram_cs_,                // SDRAM chip select        3.3V LVTTL

    // ===== GSENSOR =====================================================
    inout gsensor_sdi,              // I2C D or SPI I 4 / IO 3  3.3V LVTTL
    inout gsensor_sdo,              // SPI O 4 / Alt I2C Addr   3.3V LVTTL
    output gsensor_cs_,             // I2C / SPI Mode           3.3V LVTTL
    output gsensor_sclk,            // I2C / SPI serial clock   3.3V LVTTL
    input [2:1] gsensor_int         // GSensor interrupt pins   3.3V LVTTL
);
    marvin marvin (
        .clk_10(clk_10),
        .clk1_50(clk1_50),
        .clk2_50(clk2_50),
        .rst_(key_[0] && ardu_rst_),
        .btn_(key_[1]),
        .sw(sw),
        .led(ledr),
        .hex_(hex_),
        .sgpio(ardu_gpio[13:0]),
        .gpio(gpio),

        .vga_color(vga_color),
        .vga_hs(vga_hs),
        .vga_vs(vga_vs),

        .dram_addr(dram_addr),
        .dram_dq(dram_dq),
        .dram_bank(dram_bank),
        .dram_qdm(dram_qdm),
        .dram_ras_(dram_ras_),
        .dram_cas_(dram_cas_),
        .dram_cke(dram_cke),
        .dram_clk(dram_clk),
        .dram_re(dram_re),
        .dram_cs_(dram_cs_),

        .uart_rx(ardu_gpio[14]),
        .uart_tx(ardu_gpio[15])
    );

    // ===== Assignments =====

    assign ardu_gpio[0] = 'z;
    assign ardu_gpio[15:2] = 'z;
    assign ardu_rst_ = 'z;

    // ===== GSENSOR ==========
    assign gsensor_sdi = 'z;
    assign gsensor_sdo = 'z;
    assign gsensor_cs_ = 1;
    assign gsensor_sclk = 0;
endmodule
