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
    output reg gen
);
    reg [$clog2(T) - 1 : 0] cnt;

    always @(posedge clk, negedge rst_)
        if (!rst_)
            cnt = '0;
        else
            if (cnt < T - 1)
                cnt++;
            else
                cnt = '0;

    assign gen = 1 ? cnt <= (T >> 1) + 1 && rst_ && ena : 0;
endmodule
