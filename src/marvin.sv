/*
    Project:    MARVIN
    Sector:     TOP
    Summary:    System-bus file, dedicated to intermodular communication
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module marvin (
    input clk_10, clk1_50, clk2_50, // Clocks

    input rst_,                     // Reset

    input btn_,                     // Push-button

    input [9:0] sw,                 // Toggle switches

    output [9:0] led,               // Leds

    output pkg::seg7p_t [5:0] hex_, // 8-element hex displays

    inout [13:0] sgpio,             // Sensor shield v5.0 GPIO pins
    inout [35:0] gpio,              // GPIO pins

    // ===== VGA =========================================================
    output pkg::color_t vga_color,  // VGA color output
    output vga_hs,                  // VGA horizontal sync
    output vga_vs,                  // VGA vertical sync

    // ===== SDRAM =======================================================
    output [12:0] dram_addr,        // SDRAM address
    inout [15:0] dram_dq,           // SDRAM data bus
    output [1:0] dram_bank,         // SDRAM bank address
    output [1:0] dram_qdm,          // SDRAM bit mask
    output dram_ras_,               // SDRAM row address strobe
    output dram_cas_,               // SDRAM col address strobe
    output dram_cke,                // SDRAM clock enable
    output dram_clk,                // SDRAM clock
    output dram_re,                 // SDRAM read enable
    output dram_cs_,                // SDRAM chip select

    // ===== UART ========================================================

    input uart_rx,                  // UART reception
    output uart_tx                  // UART transmission
);
    // ===== PLLs ============

    wire clk_200;

    pll pll (
        .inclk0(clk1_50),
        .c0(clk_200)
    );

    assign dram_clk = clk_200;

    // ===== BASIC ============
    assign led = '0;
    assign hex_ = '1;
    assign sgpio[13:1] = 'z;
    assign gpio = 'z;
    assign vga_color = '0;
    assign vga_hs = 0;
    assign vga_vs = 0;
    assign uart_tx = 'z;

    // ===== SDRAM ============
    assign dram_addr = '0;
    assign dram_dq = 'z;
    assign dram_bank = '0;
    assign dram_qdm = '0;
    assign dram_cas_ = 1;
    assign dram_ras_ = 1;
    assign dram_cke = 0;
    assign dram_re = 0;
    assign dram_cs_ = 1;
endmodule
