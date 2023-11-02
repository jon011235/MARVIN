/*
    Project:    MARVIN
    Sector:     Debugging
    Summary:    Pass debug data to the FPGA
    Authors:    DM8AT, Leonard Pfeiffer
*/

module toplevel_debug (
    input clk_50,               // 50MHz clock input
    input rst_,                 // Lowactive reset

    output color_t vga_color,   // VGA color output
    output vga_vsync,           // Vertical synchronization output
    output vga_hsync,           // Horizontal synchronization output

    output reg [9:0] leds       // 10 red leds
);
    wire [$clog2('d800) - 1 : 0] pix_x;
    wire [$clog2('d600) - 1 : 0] pix_y;
    reg color_t col;

    vga (
        .pixelclk(clk_50),
        .rst(!rst_),
        .color(col),

        .pix_x(pix_x),
        .pix_y(pix_y),

        .color_out(vga_color),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync)
    );

    assign col.red = '0;
    assign col.green = pix_y[3:0];
    assign col.blue = pix_x[3:0];

    assign leds[9:1] = '0;
    assign leds[0] = '1;
endmodule
