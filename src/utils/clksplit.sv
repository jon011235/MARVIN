/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic clock splitter, active half of the cycles
    Authors:    Leonard Pfeiffer
*/

module clksplit #(
    parameter int T = 'd50000000
)(
    input wire clk, rst_, ena,
    output reg cke
);
    wire [$clog2(T) - 1 : 0] count;

    counter #(
        .T(T)
    ) ctr (
        .clk(clk),
        .rst_(rst_),
        .ena(ena),
        .count(count)
    );

    assign gen = 1 ? cnt <= (T >> 1) + 1 && rst_ && ena : 0;
endmodule
