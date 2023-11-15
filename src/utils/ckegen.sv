/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic clock enable generator, active for one cycle
    Authors:    Leonard Pfeiffer
*/

module ckegen #(
    parameter int T = 'd50000000
)(
    input wire clk, rst_,
    output reg gen
);
    reg [$clog2(T) - 1 : 0] cnt;

    always @(posedge clk, negedge rst_) begin
        if (!rst_) begin
            cnt = '0;
        end else begin
            if (cnt < T - 1) begin
                cnt++;
            end else begin
                cnt = '0;
            end
        end
    end

    assign gen = 1 ? cnt == '0 && rst_ : 0;
endmodule
