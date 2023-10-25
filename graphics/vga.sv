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

module vga #(
        // input information about the screen
        // the screen width
        parameter [15 : 0] WIDTH = 0,
        // the screen height
        parameter [15 : 0] HEIGHT = 0,

        // input information about the vga timings
        //  vertical timings
        //   vertical front porch
        parameter [15 : 0] VERT_FPORCH = 0,
        //   vertical back porch
        parameter [15 : 0] VERT_BPORCH = 0,
        //   vertical sync pulse length
        parameter [15 : 0] VERT_SYNC = 0,

        //  horizontal timins
        //   horizontal front porch
        parameter [15 : 0] HORI_FPORCH = 0,
        //   horizontal back porch
        parameter [15 : 0] HORI_BPORCH = 0,
        //   horizontal sync pulse length
        parameter [15 : 0] HORI_SYNC = 0
)
(
        // input the CORRECT clock speed
        input clk,
        // reset the chip
        input res,
        // input the color for the pixel
        input [11 : 0] color,

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

    // store the maximal length of an line
    parameter [15 : 0] FULL_LINE = WIDTH + HORI_FPORCH + HORI_SYNC + HORI_BPORCH;
    // store the height of an frame
    parameter [15 : 0] FULL_FRAME = HEIGHT + VERT_FPORCH + VERT_SYNC + VERT_BPORCH;

    // store the current pixel x position
    reg [15 : 0] c_pix_x;
    // store the current pixel y position
    reg [15 : 0] c_pix_y;

    // main process for updateing the pixels
    always @(posedge clk or posedge res) begin
        // check if the chip is being reseted
        if (res) begin
            // reset all registers 0
            //  reset the current x position
            c_pix_x <= 0;
            //  reset the current y position
            c_pix_y <= 0;
        end
        else begin
            // increase the pixel x position by 1
            c_pix_x ++;

            // check if the pixel x position is greater than a full line
            if (c_pix_x >= FULL_LINE) begin
                // reset the current pixel on the x position
                c_pix_x = 0;
                // increase the current y position by 1
                c_pix_y ++;
            end

            // check if the pixel y position is greater than a full frame
            if (c_pix_y >= FULL_FRAME) begin
                // reset the current pixel on the y position
                c_pix_y = 0;
            end

            // check if the pixel is in the visible area
            if ((c_pix_x < WIDTH) && (c_pix_y < HEIGHT)) begin
                // output the color to vga
                //  output the red component
                vga_r = color[11 : 8];
                //  ouptut the green component
                vga_g = color[7 : 4];
                //  output the blue component
                vga_b = color[3 : 0];

                // output the next pixel
                //  output the x component
                pix_x = c_pix_x+1;
                //  output the y component
                pix_y = c_pix_y+1;
            end
            else begin
                // set the color to black
                //  set red to 0
                vga_r = '0;
                //  set green to 0
                vga_g = '0;
                //  set blue to 0
                vga_b = '0;

                // output 0,0 as pixel
                //  output the x component
                pix_x = '0;
                //  output the y component
                pix_y = '0;
            end

            // check if the vertical synchronisation should be active
            if ((c_pix_y > (HEIGHT+VERT_FPORCH)) && (c_pix_y < (HEIGHT+VERT_FPORCH+VERT_SYNC))) begin
                // set the vertical sync to heigh
                vga_vsync = 1;
            end
            else begin
                // set the vertical sync to low
                vga_vsync = 0;
            end

            // check if the horizontal synchronisation should be active
            if ((c_pix_x > (WIDTH+HORI_FPORCH)) && (c_pix_x < (WIDTH+HORI_FPORCH+HORI_SYNC))) begin
                // set the horizontal synchronisation to height
                vga_hsync = 1;
            end
            else begin
                // set the horizontal synchronisation to low
                vga_hsync = 0;
            end
        end
    end

endmodule