/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Blockram based shift register
    Authors:    Leonard Pfeiffer
*/

module shiftbram #(
    parameter int unsigned DATA_ = 8,
    parameter int unsigned ADDR_ = 8
)(
    input clk, ena, aclr, 
    input [DATA_ - 1 : 0] din,
    output [DATA_ - 1 : 0] dout,
    output [2**ADDR_ - 1 : 0] [DATA_ - 1 : 0] taps
);
    altshift_taps #(
        .intended_device_family("MAX 10"),
        .lpm_hint("RAM_BLOCK_TYPE=AUTO"),
        .lpm_type("altshift_taps"),
        .number_of_taps(2**ADDR_),
        .tap_distance(DATA_),
        .width(DATA_)
    ) shift (
        .clock(clk),
        .clken(ena),
        .aclr(aclr),
        .shiftin(din),
        .shiftout(dout),
        .taps(taps)
    );
endmodule