/*
    Project:    MARVIN
    Sector:     VGA
    Summary:    Output using vga protocol
    Authors:    DM8AT, Leonard Pfeiffer
*/

import pkg::*;

module vga #(
        // Screen informations
        parameter [15:0] WIDTH = 0,         // Screen width (pixels)
        parameter [15:0] HEIGHT = 0,        // Screen height (pixels)

        // Vertical timings
        parameter [15:0] VERT_FPORCH = 0,   // Vertical front porch (lines)
        parameter [15:0] VERT_BPORCH = 0,   // Vertical back porch (lines)
        parameter [15:0] VERT_SYNC = 0,     // Vertical synchronization (lines)

        // Horizontal timings
        parameter [15:0] HORI_FPORCH = 0,   // Horizontal front porch (pixels)
        parameter [15:0] HORI_BPORCH = 0,   // Horizontal bock porch (pixels)
        parameter [15:0] HORI_SYNC = 0      // Horizontal synchronization (pixels)
)(
        input pixelclk;             // Screen specific pixelclock
        input rst,                  // Reset
        input color_t color_in,     // Color for current pixel

        // Next pixel's coordinates
        output [15:0] pix_x,
        output [15:0] pix_y,

        output color_t color_out,   // VGA color output

        // VGA synchronization output
        output vga_vsync,
        output vga_hsync
    );
    
    // Total frame dimensions
    localparam [15:0] FULL_LINE = WIDTH + HORI_FPORCH + HORI_SYNC + HORI_BPORCH;      // Max line length
    localparam [15:0] FULL_FRAME = HEIGHT + VERT_FPORCH + VERT_SYNC + VERT_BPORCH;    // Max frame height
    
    // Current cursor position
    reg [15:0] c_pix_x;
    reg [15:0] c_pix_y;

    // Sequential process for updating pixels
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            c_pix_x <= 0;
            c_pix_y <= 0;
        end else begin
            c_pix_x ++; // Increase the pixel x position by 1

            // Check if the pixel x position is greater than a full line
            if (c_pix_x >= FULL_LINE) begin
                c_pix_x = 0;    // Reset the current pixel on the x position
                c_pix_y ++;     // Increase the current y position by 1
            end

            // Check if the pixel y position is greater than a full frame
            if (c_pix_y >= FULL_FRAME) begin
                c_pix_y = 0;    // Reset the current pixel on the y position
            end

            // Check if the pixel is in the visible area
            if ((c_pix_x < WIDTH) && (c_pix_y < HEIGHT)) begin
                color_out = color_in;   // Output the color to vga

                // Output the next pixel
                pix_x = c_pix_x+1;  // Output the x component
                pix_y = c_pix_y+1;  // Output the y component
            end else begin
                color_out = '0; // Set the color to black

                // Output 0,0 as pixel
                pix_x = '0;     //  Output the x component
                pix_y = '0;     //  Output the y component
            end

            // Check if the vertical synchronisation should be active
            if ((c_pix_y > (HEIGHT + VERT_FPORCH)) && (c_pix_y < (HEIGHT + VERT_FPORCH + VERT_SYNC))) begin
                vga_vsync = 1;  // Set the vertical sync to 1
            end else begin
                vga_vsync = 0;  // Set the vertical sync to low
            end

            // Check if the horizontal synchronisation should be active
            if ((c_pix_x > (WIDTH + HORI_FPORCH)) && (c_pix_x < (WIDTH + HORI_FPORCH + HORI_SYNC))) begin
                vga_hsync = 1;  // Set the horizontal synchronisation to 1
            end else begin
                vga_hsync = 0;  // Set the horizontal synchronisation to low
            end
        end
    end

endmodule