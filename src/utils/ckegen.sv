/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic clock enable generators for one cycle (1) or half of the cycles (2)
    Authors:    Leonard Pfeiffer
*/

module ckegen1 #(
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
endmodule : ckegen1

module ckegen2 #(
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

    assign gen = 1 ? cnt < T >> 1 && !rst : 0;
endmodule : ckegen2
