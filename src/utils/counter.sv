/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic counter
    Authors:    Leonard Pfeiffer
*/

module counter #(
    parameter int T // Largest number that will be reached
)(
    input clk, rst,
    output [$clog2(T) - 1 : 0] count
);
    reg countr;

    always @(posedge clk, posedge rst)
        if (rst)
            countr = '0;
        else
            if (countr < T)
                countr++;
            else
                countr = '0;
    
    assign count = countr;
endmodule : counter
