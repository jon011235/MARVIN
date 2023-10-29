/*
    Project:    MARVIN
    Sector:     VGA
    Summary:    Output using vga protocol
    Authors:    DM8AT, Leonard Pfeiffer
*/

import pkg::*;

module vga #(
        // Screen informations
        parameter int unsigned H_SIZE = 800,    // Screen width (pixels)
        parameter int unsigned V_SIZE = 600,    // Screen height (pixels)

        // Horizontal timings
        parameter int unsigned H_FP = 56,       // Horizontal front porch (pixels)
        parameter int unsigned H_SYNC = 120,    // Horizontal synchronization (pixels)
        parameter int unsigned H_BP = 64        // Horizontal bock porch (pixels)

        // Vertical timings
        parameter int unsigned V_FP = 37,       // Vertical front porch (lines)
        parameter int unsigned V_SYNC = 6,      // Vertical synchronization (lines)
        parameter int unsigned V_BP = 23,       // Vertical back porch (lines)
)(
        input pixelclk,         // Screen specific pixelclock
        input rst,              // Reset
        input color_t color_in, // Color for current pixel

        // Next pixel's coordinates
        output [$clog2(H_SIZE) - 1 : 0] pix_x,
        output [$clog2(V_SIZE) - 1 : 0] pix_y,

        output color_t color_out,   // VGA color output

        // VGA synchronization output
        output vga_vsync,
        output vga_hsync
    );

    // Total frame dimensions
    localparam int unsigned FullHSize = H_SIZE + H_FP + H_SYNC + H_BP;  // Max line length
    localparam int unsigned FullVSize = V_SIZE + V_FP + V_SYNC + V:BP;  // Max frame height
    
    // Current cursor position
    reg [$clog2(FullHSize) - 1 : 0] c_pix_x;
    reg [$clog2(FullVSize) - 1 : 0] c_pix_y;

    // Sequential process for updating pixels
    always @(posedge pixelclk, posedge rst) begin
        if (rst) begin
            // Reset all registers
            c_pix_x <= 0;
            c_pix_y <= 0;
        end else begin
            c_pix_x ++; // Increase the pixel x position by 1

            // Check if the pixel x position is greater than a full line
            if (c_pix_x >= FullHSize) begin
                c_pix_x = 0;    // Reset the current pixel on the x position
                c_pix_y ++;     // Increase the current y position by 1
            end

            // Check if the pixel y position is greater than a full frame
            if (c_pix_y >= FullVSize) begin
                c_pix_y = 0;    // Reset the current pixel on the y position
            end

            // Check if the pixel is in the visible area
            if ((c_pix_x < H_SIZE) && (c_pix_y < V_SIZE)) begin
                color_out = color_in;   // Output the color to vga

                // Output the next pixel
                pix_x = c_pix_x + 1;  // Output the x component
                pix_y = c_pix_y + 1;  // Output the y component
            end else begin
                color_out = '0; // Set the color to black

                // Output 0,0 as pixel
                pix_x = '0;     //  Output the x component
                pix_y = '0;     //  Output the y component
            end

            // Check if the vertical synchronisation should be active
            if ((c_pix_y > (H_SIZE + V_FP)) && (c_pix_y < (H_SIZE + V_FP + V_SYNC))) begin
                vga_vsync = 1;  // Set the vertical sync to 1
            end else begin
                vga_vsync = 0;  // Set the vertical sync to low
            end

            // Check if the horizontal synchronisation should be active
            if ((c_pix_x > (H_SIZE + H_FP)) && (c_pix_x < (H_SIZE + H_FP + H_SYNC))) begin
                vga_hsync = 1;  // Set the horizontal synchronisation to 1
            end else begin
                vga_hsync = 0;  // Set the horizontal synchronisation to low
            end
        end
    end
endmodule
