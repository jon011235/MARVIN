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
    output full, empty,
    output [ADDR_ : 0] fill,
    input [DATA_ - 1 : 0] din,
    output [DATA_ - 1 : 0] dout
);
    reg [ADDR_ : 0] fill_;
    wire [DATA_ : 0] dout_;
    reg [ADDR_ - 1 : 0] rp, wp;                 // Pointers

    bramsd #(                                   // Read and write data
        .ADDR_(ADDR_),
        .DATA_(DATA_)
    ) bram (
        .clk(clk),
        .aclr(~rst_),
        .we(we),
        .raddr(rp),
        .waddr(wp),
        .din(din),
        .dout(dout_)
    );

    always @(posedge clk, negedge rst_) begin   // Move pointers
        if (!rst_) begin
            rp = '0;
            wp = '0;
            fill_ = '0;
        end else begin
            if (re && fill_ > 0) begin          // Read
                if (rp < 2**ADDR_ - 1)
                    rp++;
                else begin
                    rp = '0;
                end

                if (!we)
                    fill_--;
            end

            if (we && fill_ < 2**ADDR_) begin   // Write
                if (wp < 2**ADDR_ - 1)
                    wp++;
                else begin
                    wp = '0;
                end

                if (!re)
                    fill_++;
            end
        end
    end

    assign full = fill_ == 2**ADDR_ ? 1 : 0;
    assign empty = fill_ == 0 ? 1 : 0;
    assign fill = fill_;
    assign dout = rp == wp && we ? din : dout_;
endmodule