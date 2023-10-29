/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic pwm generator
    Authors:    Leonard Pfeiffer
*/

module pwmgen #(
    parameter int T
)(
    input clk, rst,
    input [$clog2(T) - 1 : 0] ton,
    output reg pwm
);
    reg [$clog2(T) - 1 : 0] countr;

    always @(posedge clk, posedge rst)
        if (rst)
            countr = '0;
        else
            if (countr < T - 1)
                countr++;
            else
                countr = '0;

    assign pwm = 1 ? countr < ton && !rst : 0;
endmodule