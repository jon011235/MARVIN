module ckegen2 #(
    parameter int DIV = 'd50000000
)(
    input clk, rst,
    output reg gen
);
    reg [$clog2(DIV) - 1 : 0] cnt;

    always @(posedge cref or rst) begin
        if (rst) begin
            cnt = '0;
        end else begin
            if (cnt < DIV - 1) begin
                cnt++;
            end else begin
                cnt = '0;
            end
        end
    end

    assign gen = (1 ? cnt < DIV >> 1 && !rst : 0);
endmodule
