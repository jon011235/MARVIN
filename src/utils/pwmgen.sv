/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic pwm generator
    Authors:    Leonard Pfeiffer
*/

module pwmgen #(
    parameter time Tclk = 20ns,
    parameter time Tdut = 20ms,
    parameter time Tmin = 500us,
    parameter time Tmax = 2500us,
    parameter int Wpos = 8
)(
    input clk, rst_, ena,
    input [Wpos - 1 : 0] pos,
    output reg pwm
);
    localparam Ndut = Tdut / Tclk;
    localparam Nmin = Tmin / Tclk;
    localparam M = (Tmax - Tmin) / (Tclk * 2**Wpos);

    wire [$clog2(Ndut) - 1 : 0] count;

    counter #(
        .N(Ndut)
    ) ctr (
        .clk(clk),
        .rst_(rst_),
        .ena(ena),
        .count(count)
    );

    assign pwm = 1 ? count < Nmin + pos * M && rst_ && ena : 0;
endmodule
