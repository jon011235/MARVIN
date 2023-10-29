/*
    Project:    MARVIN
    Sector:     Debugging
    Summary:    Pass debug data to the FPGA
    Authors:    DM8AT, Leonard Pfeiffer
*/

module toplevel_debug (
    input clk_50,               // 50MHz clock input
    input rst,

    output color_t vga_color,   // VGA color output
    output vga_vsync,           // Vertical synchronization output
    output vga_hsync,           // Horizontal synchronization output

    output reg [9:0] leds       // 10 red leds
);
    wire [15:0] pix_x;
    wire [15:0] pix_y;
    reg color_t col;

    vga #(
        .WIDTH('d800),
        .HEIGHT('d600),
        .VERT_FPORCH('d37),
        .VERT_BPORCH('d23),
        .VERT_SYNC('d6),
        .HORI_FPORCH('d56),
        .HORI_BPORCH('d64),
        .HORI_SYNC('d120)
    )(
        .pixelclk(clk_50),
        .rst(!rst),
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

endmodule