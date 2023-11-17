/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Semi dual port blockram
    Authors:    Leonard Pfeiffer
*/

module bramsd #(
    parameter int unsigned ADDR_ = 8,
    parameter int unsigned DATA_ = 8
)(
    input clk, aclr, we,
    input [ADDR_ - 1 : 0] raddr, waddr,
    input [DATA_ - 1 : 0] din,
    output [DATA_ - 1 : 0] dout
);
	altsyncram	bram (
        .clock0(clk),
        .clock1(1'b1),
        .clocken0(1'b1),
        .clocken1(1'b1),
        .clocken2(1'b1),
        .clocken3(1'b1),
        .aclr0(aclr),
        .aclr1(1'b0),
        .rden_a(1'b1),
        .rden_b(1'b1),
        .wren_a(we),
        .wren_b(1'b0),
        .address_a(waddr),
        .address_b(raddr),
        .data_a(din),
        .data_b('1),
        .q_a(),
        .q_b(dout),
        .addressstall_a(1'b0),
        .addressstall_b(1'b0),
        .byteena_a(1'b1),
        .byteena_b(1'b1),
        .eccstatus()
    );

	defparam
        bram.widthad_a = ADDR_,
        bram.widthad_b = ADDR_,
        bram.numwords_a = 2**ADDR_,
        bram.numwords_b = 2**ADDR_,
        bram.width_a = DATA_,
        bram.width_b = DATA_,
        bram.clock_enable_input_a = "BYPASS",
        bram.clock_enable_input_b = "BYPASS",
        bram.clock_enable_output_b = "BYPASS",
        bram.address_reg_b = "CLOCK0",
        bram.outdata_aclr_b = "CLEAR0",
        bram.address_aclr_b = "CLEAR0",
        bram.intended_device_family = "MAX 10",
        bram.lpm_type = "altsyncram",
        bram.operation_mode = "DUAL_PORT",
        bram.outdata_reg_b = "CLOCK0",
        bram.power_up_uninitialized = "FALSE",
        bram.read_during_write_mode_mixed_ports = "DONT_CARE",
        bram.width_byteena_a = 1
    ;
endmodule