//////////////////////////////////////////////////////////////////////
// Project : MARVIN
// Module  : toplevel_debug
// Description: pass debug data to the FPGA
//
// Authors : Mattis Levin Hänsel
//
//////////////////////////////////////////////////////////////////////

module toplevel_debug (
    // input for the 50 Hz clock
    input clk_50,
    // input for a reset button
    input rst,
    // output for the vga signals
    //  output for the red amount
    output [3 : 0] vga_r,
    //  output for the green amount
    output [3 : 0] vga_g,
    //  output for the blue amount
    output [3 : 0] vga_b,
    //  output the vertical sync pulse
    output vga_vsync,
    //  output the horizontal sync pulse
    output vga_hsync,

    // 10 red leds
    output reg [9 : 0] leds
);

wire [15 : 0] pix_x;
wire [15 : 0] pix_y;
reg [15 : 0] col;

vga #(
    .WIDTH('d800),
    .HEIGHT('d600),
    .VERT_FPORCH('d37),
    .VERT_BPORCH('d23),
    .VERT_SYNC('d6),
    .HORI_FPORCH('d56),
    .HORI_BPORCH('d64),
    .HORI_SYNC('d120)
)
(
    .clk(clk_50),
    .rst(!rst),
    .color(col),

    .pix_x(pix_x),
    .pix_y(pix_y),

    .vga_r(vga_r),
    .vga_g(vga_g),
    .vga_b(vga_b),
    .vga_hsync(vga_hsync),
    .vga_vsync(vga_vsync)
);

assign col[3 : 0] = '0;
assign col[7 : 4] = pix_y[3 : 0];
assign col[11 : 8] = pix_x[3 : 0];
    
endmodule