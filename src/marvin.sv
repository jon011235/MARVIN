/*
    Project:    MARVIN
    Sector:     TOP
    Entity:     marvin
    Summary:    Toplevel design file
    Device:     terasIC® DE10-Lite Development Board with Altera® MAX 10 10M50DAF484C7G FPGA
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module marvin(
    // ===== CLOCKS ======================================================
    input clk_10,                   // 10MHz clock (for ADCs)   3.3V LVTTL

    input clk1_50,                  // 50MHz primary clock      3.3V LVTTL

    input clk2_50,                  // 50MHz secondary clock    3.3V LVTTL

    // ===== BASIC IN ====================================================
    input [1:0] key,                // 2 push buttons           3.3V Schmitt

    input [9:0] sw,                 // 10 toggle switches       3.3V LVTTL

    // ===== BASIC OUT ===================================================
    output [9:0] ledr,              // 10 red leds              3.3V LVTTL

    output pkg::seg7p_t [5:0] hex,    // 6x8-element hex display  3.3V LVTTL

    // ===== BASIC IO ====================================================
    inout [35:0] gpio,              // 36 pin expansion header  3.3V LVTTL

    // ===== ARDUINO =====================================================
    inout [15:0] ardu_gpio,         // 16 pin arduino connector 3.3V LVTTL
    inout ardu_rst_,                // Arduino reset            3.3V Schmitt

    // ===== VGA =========================================================
    output pkg::color_t vga_color,    // 3x4 VGA color output     3.3V LVTTL
    output vga_hs,                  // VGA horizontal sync      3.3V LVTTL
    output vga_vs,                  // VGA vertical sync        3.3V LVTTL

    // ===== SDRAM =======================================================
    output [12:0] dram_addr,        // 13 bit SDRAM address     3.3V LVTTL
    inout [15:0] dram_dq,           // 16 bit SDRAM data bus    3.3V LVTTL
    output [1:0] dram_bank,         // 2 bit SDRAM bank address 3.3V LVTTL
    output [1:0] dram_qdm,          // 2 bit SDRAM bit mask     3.3V LVTTL
    output dram_ras_,               // SDRAM row address strobe 3.3V LVTTL
    output dram_cas_,               // SDRAM col address strobe 3.3V LVTTL
    output dram_cke,                // SDRAM clock enable       3.3V LVTTL
    output dram_clk,                // 200MHz SDRAM clock       3.3V LVTTL
    output dram_re,                 // SDRAM read enable        3.3V LVTTL
    output dram_cs_,                // SDRAM chip select        3.3V LVTTL

    // ===== GSENSOR =====================================================
    inout gsensor_sdi,              // I2C D or SPI I 4 / IO 3  3.3V LVTTL
    inout gsensor_sdo,              // SPI O 4 / Alt I2C Addr   3.3V LVTTL
    output gsensor_cs_,             // I2C / SPI Mode           3.3V LVTTL
    output gsensor_sclk,            // I2C / SPI serial clock   3.3V LVTTL
    input [2:1] gsensor_int         // GSensor interrupt pins   3.3V LVTTL
);
    // ===== BASIC ============
    assign ledr = '0;
    assign hex = '0;
    assign gpio = '0;
    assign ardu_gpio = '0;
    assign ardu_rst_ = 0;
    assign vga_color = '0;
    assign vga_hs = 0;
    assign vga_vs = 0;

    // ===== SDRAM ============
    assign dram_addr = '0;
    assign dram_dq = '0;
    assign dram_bank = '0;
    assign dram_qdm = '0;
    assign dram_cas_ = 0;
    assign dram_ras_ = 0;
    assign dram_cke = 0;
    assign dram_clk = 0;
    assign dram_re = 0;
    assign dram_cs_ = 1;

    // ===== GSENSOR ==========
    assign gsensor_sdi = 0;
    assign gsensor_sdo = 0;
    assign gsensor_cs_ = 1;
    assign gsensor_sclk = 0;
endmodule
