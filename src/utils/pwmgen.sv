/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Generic pwm generator
    Authors:    Leonard Pfeiffer
*/

module pwmgen #(
    parameter time CLK_ = 20ns,     // Clock cycle duration
    parameter time DUTY = 20ms,     // PWM duty cycle duration
    parameter time MIN = 500us,     // Minimum ontime
    parameter time MAX = 2500us,    // Maximum ontime
    parameter int unsigned POS_ = 8          // Position input width
)(
    input clk, rst_, ena,
    input [POS_ - 1 : 0] pos,
    output reg pwm
);
    // Clock cycle count calculations
    localparam DUTY_ = DUTY / CLK_;
    localparam MIN_ = MIN / CLK_;

    // Factor for transformation
    localparam M = (MAX - MIN) / (CLK_ * 2**POS_);

    wire [$clog2(DUTY_) - 1 : 0] count;

    counter #(
        .T(DUTY_)
    ) ctr (
        .clk(clk),
        .rst_(rst_),
        .ena(ena),
        .count(count)
    );

    assign pwm = 1 ? count < MIN_ + pos * M && rst_ && ena : 0;
endmodule
