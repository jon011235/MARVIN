/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Single port ram
    Authors:    Leonard Pfeiffer
*/

module rams #(
    parameter DATA_ = 8,
    parameter ADDR_ = 8,
    parameter RAMT = "block"    // "auto", "logic", "block" or "ultra"
)(
    input clk, ena, we,
    input [ADDR_ - 1 : 0] addr,
    input [DATA_ - 1 : 0] din,
    output wire [DATA_ - 1 : 0] dout
);
    (* ramstyle = RAMT *) reg [DATA_ - 1 : 0] ram [2**ADDR_ - 1 : 0];

    always @(posedge clk) begin
        if (ena) begin
            if (we) begin
                ram[addr] = din;
            end
        end
    end

    assign dout = ena ? ram[addr] : 'z;
endmodule