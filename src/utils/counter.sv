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
    output [$clog2(T) - 1 : 0] cnt
);
    reg cntr;

    always @(posedge clk, posedge rst)
        if (rst)
            cntr = '0;
        else
            if (cntr < T - 1)
                cntr++;
            else
                cntr = '0;
    
    assign cnt = cntr;
endmodule : counter
