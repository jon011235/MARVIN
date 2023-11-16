/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Single port ram
    Authors:    Leonard Pfeiffer
*/

module rams #(
    parameter DATA_ = 8,
    parameter ADDR_ = 8,
    parameter RAMT = "block"    // "auto", "logic", "block" or "ultra"
)(
    input clk, we,
    input [ADDR_ - 1 : 0] addr,
    inout [DATA_ - 1 : 0] data,
);

endmodule