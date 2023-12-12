/*
    Project:    MARVIN
    Sector:     COM
    Summary:    Uart interface
    Authors:    Leonard Pfeiffer
*/

import pkg::*;

module uart #(
    parameter CLK_ natural = 50000000,
    parameter BUFF_ natural = 64,
    parameter BAUD_ natural = 115200,
    parameter DATA_ natural = 8,
    parameter STOP_ natural = 1,
    parameter PARITY string  = "none"   // even, odd, mark, space
)(
    input clk, rst_,
    input [ADDRBUS_ - 1 : 0] addrbus,
    inout [DATABUS_ - 1 : 0] databus,
    input rx,
    output tx
);

endmodule