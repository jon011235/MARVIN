/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic counter
    Authors:    Leonard Pfeiffer
*/

module counter #(
    parameter int T = 'd5000000 // Largest number that will be reached
)(
    input clk, rst_, ena,
    output [$clog2(T) - 1 : 0] count
);
    reg [$clog2(T) - 1 : 0] countr;

    always @(posedge clk, negedge rst_) begin
        if (!rst_) begin
            countr = '0;
        end else if (ena) begin
            if (countr < T) begin
                countr++;
            end else begin
                countr = '0;
            end
        end
    end

    assign count = countr;
endmodule : counter
