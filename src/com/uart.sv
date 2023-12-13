/*
    Project:    MARVIN
    Sector:     COM
    Summary:    Uart interface
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module uart #(
    parameter int unsigned F_CLK = 50000000,
    parameter int unsigned BAUDRATE = 2000000,
    parameter int unsigned BUFFER_ = 8,
    parameter int unsigned START_ = 1,
    parameter int unsigned DATA_ = 8,
    parameter int unsigned STOP_ = 1,
    parameter int unsigned PARITY = "none" // "even", "odd", "mark"
)(
    input clk, rst_,
    input [ADDRBUS_ - 1 : 0] addrbus,
    inout [DATABUS_ - 1 : 0] databus,
    input rx,
    output tx
);
    localparam int unsigned BIT_ = CLKF / BAUDR;

    wire ren, ten, rbre, rbwe, rbempty, tbre, tbwe, tbempty;
    wire [DATA_ - 1 : 0] rbdin, rbdout, tbdout;
    wire [START_ + STOP_ + DATA_ - 1 : 0] rdata, tdata;
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
        .din(rbdin),
        .dout(rbdout)
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
        .dout(tbdout)
    );

    always @(posedge clk) begin
        if (!rst_) begin
            ren = 0;
            rcycles = '0;
            rbits = '0;
            ten = 0;
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

                        // Write to buffer and test parity
                    end
                end
                
                rdata[rbits] = rx;
            end

            // ===== TX =====

            tx = 1;
            
            if (!ten && !tbempty) begin
                ten = 1;
                tbre = 1;
                tdata[START_ - 1 : 0] = '0;
                tdata[START_ + DATA_ - 1 : START_] = ~tbdata;

                // Add parity bit
            end
        
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
                
                tx = tdata[tbits];
            end
        end
    end
endmodule
