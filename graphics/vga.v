//////////////////////////////////////////////////////////////////////
// Project : MARVIN
// Module  : vga
// Description: draw an inputed varrying color to the screen
// Refereced literature:
// - http://tinyvga.com/vga-timing/640x480@60Hz
//
// Authors : Mattis Levin Hänsel
//
//////////////////////////////////////////////////////////////////////

module vga (
        // input the CORRECT clock speed
        input clk,
        // reset the chip
        input res,
        // input the color for the pixel
        input [11 : 0] color,

        // input information about the screen
        // the screen width
        parameter [15 : 0] width,
        // the screen height
        parameter [15 : 0] height,

        // input information about the vga timings
        //  vertical timings
        //   vertical front porch
        parameter [15 : 0] vert_fporch,
        //   vertical back porch
        parameter [15 : 0] vert_bporch,
        //   vertical sync pulse length
        parameter [15 : 0] vert_sync,

        //  horizontal timins
        //   horizontal front porch
        parameter [15 : 0] back_fporch,
        //   horizontal back porch
        parameter [15 : 0] back_bporch,
        //   horizontal sync pulse length
        parameter [15 : 0] back_sync,

        // output the next pixel coordinate
        //  x component
        output [15 : 0] pix_x,
        //  y component
        output [15 : 0] pix_y,

        // output the vga color
        //  the red component
        output [3 : 0] vga_r,
        //  the green component
        output [3 : 0] vga_g,
        //  the blue component
        output [3 : 0] vga_b,

        // output the vga syncronisation
        //  vertical syncronisation
        output vga_vsync,
        //  horizontal syncronistaion
        output vga_hsync
    );

endmodule