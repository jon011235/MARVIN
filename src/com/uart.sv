/*
    Project:    MARVIN
    Sector:     COM
    Summary:    Uart interface
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module uart #(
    parameter int unsigned CLKF = 50000000,
    parameter int unsigned BAUDR = 2000000,
    parameter int unsigned BUFR_ = 8,
    parameter int unsigned START_ = 1,
    parameter int unsigned DATA_ = 8,
    parameter int unsigned STOP_ = 1
)(
    input clk, rst_,
    input [ADDRBUS_ - 1 : 0] addrbus,
    inout [DATABUS_ - 1 : 0] databus,
    input rx,
    output tx
);
    localparam int unsigned BIT_ = CLKF / BAUDR;

    wire ren, ten, rbre, rbwe, rbempty, tbre, tbwe, tbempty;
    wire [DATA_ - 1 : 0] rdata, tdata, rdtmp;
    wire [$clog2(BIT_) - 1 : 0] rcycles, tcycles;
    wire [$clog2(START_ + DATA_ + STOP_) - 1 : 0] rbits, tbits;

    bramfifo #(
        .DATA_(DATA_),
        .ADDR_(BUFR_)
    ) rbuffer (
        .clk(clk),
        .rst_(rst_),
        .re(rbre),
        .we(rbwe),
        .empty(rbempty),
        .din(rdata),
        .dout(rbtmp)
    );

    bramfifo #(
        .DATA_(DATA_),
        .ADDR_(BUFR_)
    ) tbuffer (
        .clk(clk),
        .rst_(rst_),
        .re(tbre),
        .we(tbwe),
        .empty(tbempty),
        .din(databus),
        .dout(tdata)
    );

    always @(posedge clk) begin
        if (!rst_) begin
            ren = 0;
            rcycles = '0;
            rbits = '0;
            tcycles = '0;
            tbits = '0;
        end else begin
            // ===== RX =====

            if (!ren && !rx) begin
                ren = 1;
            end
            
            if (ren) begin
                if (rcycles < BIT_ - 1) begin
                    rcycles++;
                end else begin
                    rcycles = '0;

                    if (rbits < START_ + DATA_ + STOP_ - 1) begin
                        rbits++;
                    end else begin
                        ren = 0;
                        rbits = '0;
                    end
                end

                if (START_ <= rbits && rbits < START_ + DATA_ && rcycles = BIT_ / 2) begin
                    rdata[rbits - START_] = !rx;
                end
            end

            // ===== TX =====

            if (ten) begin
                if (tcycles < BIT_ - 1) begin
                    tcycles++;
                end else begin
                    tcycles = '0;

                    if (tbits < START_ + DATA_ + STOP_ - 1) begin
                        tbits++;
                    end else begin
                        ten = '0;
                        tbits = '0;
                    end
                end

                if (tbits < START_) begin
                    tx = '0;
                end else if (tbits < START_ + DATA_) begin
                    tx = tdata[tbits - START_];
                end else begin
                    tx = '1;
                end
            end else begin
                tx = '1;
            end
        end
    end
endmodule