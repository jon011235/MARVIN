/*
    Project:    MARVIN
    Sector:     COM
    Summary:    Uart interface
    Authors:    Leonard Pfeiffer
*/

import pkg::*;
import uart_pkg::*;

module uart #(
    parameter int unsigned CLK = 50000000,
    parameter int unsigned BAUDRATE = 2000000,
    parameter int unsigned BUFFER_ = 8,
    parameter int unsigned START_ = 1,
    parameter int unsigned DATA_ = 8,
    parameter int unsigned STOP_ = 1,
    parameter parity_t PARITY = NONE
)(
    input clk, rst_,
    input [ADDRBUS_ - 1 : 0] addrbus,
    inout [7 : 0] databus,                                      // Correct bus size later
    input rx,
    output tx
);
    localparam int unsigned BIT_ = CLK / BAUDRATE;
    localparam int unsigned PARITY_ = PARITY == NONE ? 0 : 1;

    localparam AE = START_ - 1;     // StArt bits End
    localparam DS = AE + 1;         // Data bits Start
    localparam DE = DS + DATA_ - 1; // Data bits End
    localparam PL = DE + PARITY_;   // Parity bit Location
    localparam OS = PL + 1;         // StOp bits Start
    localparam OE = OS + STOP_ - 1; // StOp bits Snd
    localparam ME = OE;             // Message End
    localparam ML = ME + 1;         // Message Length

    wire ren, ten, rbre, rbwe, rbempty, tbre, tbwe, tbempty;
    wire [ME : 0] rmsg, tmsg;
    wire [DATA_ - 1 : 0] rbdin, rbdout, tbdout;
    
    wire [$clog2(BIT_) - 1 : 0] rcycles, tcycles;
    wire [$clog2(ML) - 1 : 0] rbits, tbits;

    assign databus = rbdout;                                    // Remove later

    bramfifo #(
        .DATA_(DATA_),
        .ADDR_(BUFFER_)
    ) rbuffer (
        .clk(clk),
        .rst_(rst_),
        .re(rbre),
        .we(rbwe),
        .empty(rbempty),
        .din(~rmsg[DE : DS]),
        .dout(rbdout)
    );

    bramfifo #(
        .DATA_(DATA_),
        .ADDR_(BUFFER_)
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
            // ===== RX ===========================================================================

            if (!ren && !rx) begin // Reception initialization
                ren = 1;
            end
            
            if (ren) begin
                if (rcycles < BIT_ - 1) begin // Clock counter
                    rcycles++;
                end else begin
                    rcycles = '0;

                    if (rbits < ME) begin // Bit counter
                        rbits++;
                    end else begin
                        ren = 0;
                        rbits = '0;

                        // Check start & stop bits
                        if (rmsg[AE : 0] == '0 && rmsg[OE : OS] == '1) begin
                            // Check parity
                            case (PARITY)
                                EVEN:
                                    if (~^rmsg[DE : DS]) begin
                                        rbwe = 1;
                                    end
                                ODD:
                                    if (^rmsg[DE : DS]) begin
                                        rbwe = 1;
                                    end
                                MARK:
                                    if (rmsg[PL] == 1) begin
                                        rbwe = 1;
                                    end
                                SPACE:
                                    if (rmsg[PL] == 0) begin
                                        rbwe = 1;
                                    end
                                NONE:
                                    rbwe = 1; // Do not check parity 
                            endcase
                        end
                    end
                end

                if (rcycles == BIT_ / 2) begin // Read at midpoint of bit
                    rmsg[rbits] = rx;
                end
            end

            // ===== TX ===========================================================================

            tx = 1;
            tbre = 0;
            
            if (!ten && !tbempty) begin // Transmission initialization
                ten = 1;
                tbre = 1;
                // Startbits
                tmsg[AE : 0] = '0;
                // Databits
                tmsg[DE : DS] = ~tbdout;

                // Parity bit
                case (PARITY)
                    EVEN:
                        tmsg[PL] = ~^tmsg[DE : DS];
                    ODD:
                        tmsg[PL] = ^tmsg[DE : DS];
                    MARK:
                        tmsg[PL] = 1;
                    SPACE:
                        tmsg[PL] = 0;
                    NONE:;
                        // Do not add parity
                endcase

                // Stopbits
                tmsg[OE : OS] = '1;
            end
        
            if (ten) begin // Transmission
                if (tcycles < BIT_ - 1) begin // Clock counter
                    tcycles++;
                end else begin
                    tcycles = '0;

                    if (tbits < ME) begin // Bit counter
                        tbits++;
                    end else begin
                        ten = '0;
                        tbits = '0;
                    end
                end
                
                tx = tmsg[tbits];
            end
        end
    end
endmodule
