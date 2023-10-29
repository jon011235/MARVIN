/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic counter
    Authors:    Leonard Pfeiffer
*/

module counter #(
    parameter T
)(
    input clk, rst,
    output [$clog2(T)-1:0] count
);

endmodule : counter
