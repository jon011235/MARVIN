/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Blockram based fifo
    Authors:    Leonard Pfeiffer
*/

module bramfifo #(
    parameter int unsigned DATA_ = 8,
    parameter int unsigned ADDR_ = 8
)(
    input clk, rst_, re, we,
    output [ADDR_ : 0] fill,
    input [DATA_ - 1 : 0] din,
    output [DATA_ - 1 : 0] dout
);
    reg [ADDR_ : 0] fillr;
    reg [ADDR_ - 1 : 0] rp, wp;                 // Pointers

    bramsd #(                                   // Read and write data
        .ADDR_(ADDR_),
        .DATA_(DATA_)
    ) bram (
        .clk(clk),
        .aclr(~rst_),
        .we(we),
        .raddr(raddr),
        .waddr(waddr),
        .din(din),
        .dout(dout)
    );

    always @(posedge clk, negedge rst_) begin   // Move pointers
        if (!rst_) begin
            rp = '0;
            wp = '0;
            fill = '0;
        end else begin
            if (re && fillr > 0) begin
                if (rp < 2**ADDR_ - 1) begin
                    rp++;
                end else begin
                    rp = '0;
                end
            end

            if (we && fillr < 2**ADDR_) begin
                if (wp < 2**ADDR_ - 1) begin
                    wp++;
                end else begin
                    wp = '0;
                end
            end
        end
    end

    assign fill = fillr;
endmodule