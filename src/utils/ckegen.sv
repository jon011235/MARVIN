/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic clock enable generator, active for one cycle
    Authors:    Leonard Pfeiffer
*/

module ckegen #(
    parameter int T = 'd50000000
)(
    input wire clk, rst,
    output reg gen
);
    reg [$clog2(T) - 1 : 0] cnt;

    always @(posedge clk, posedge rst)
        if (rst)
            cnt = '0;
        else
            if (cnt < T - 1)
                cnt++;
            else
                cnt = '0;

    assign gen = 1 ? cnt == '0 && !rst : 0;
endmodule
