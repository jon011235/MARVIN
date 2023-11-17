/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Blockram based fifo
    Authors:    Leonard Pfeiffer
*/

module bramfifo #(
    parameter int unsigned DATA_ = 8,
    parameter int unsigned DEPTH = 8
)(
    input clk, re, we,
    input [DATA_ - 1 : 0] din,
    output [DATA_ - 1 : 0] dout
);

endmodule