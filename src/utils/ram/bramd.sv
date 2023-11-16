/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Dual port blockram
    Authors:    Leonard Pfeiffer
*/

module bramd #(
    parameter int unsigned ADDR_ = 8,
    parameter int unsigned DATA_ = 8
)(
    input clk, aclr, wea, web,
    input [ADDR_ - 1 : 0] addra, addrb,
    input [DATA_ - 1 : 0] dina, dinb,
    output [DATA_ - 1 : 0] douta, doutb
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
        .wren_a(wea),
        .wren_b(web),
        .address_a(addra),
        .address_b(addrb),
        .data_a(dina),
        .data_b(dinb),
        .q_a(douta),
        .q_b(doutb),
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
        bram.clock_enable_output_a = "BYPASS",
        bram.clock_enable_output_b = "BYPASS",
        bram.address_reg_b = "CLOCK0",
        bram.outdata_reg_a = "CLOCK0",
        bram.outdata_reg_b = "CLOCK0",
        bram.outdata_aclr_a = "CLEAR0",
        bram.outdata_aclr_b = "CLEAR0",
        bram.indata_reg_b = "CLOCK0",
        bram.read_during_write_mode_port_a = "NEW_DATA_WITH_NBE_READ",
        bram.read_during_write_mode_port_b = "NEW_DATA_WITH_NBE_READ",
        bram.wrcontrol_wraddress_reg_b = "CLOCK0",
        bram.intended_device_family = "MAX 10",
        bram.lpm_type = "altsyncram",
        bram.operation_mode = "BIDIR_DUAL_PORT",
        bram.power_up_uninitialized = "FALSE",
        bram.read_during_write_mode_mixed_ports = "DONT_CARE",
        bram.width_byteena_a = 1,
        bram.width_byteena_b = 1
    ;
endmodule