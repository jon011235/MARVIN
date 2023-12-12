/*
    Project:    MARVIN
    Sector:     UTILS
    Summary:    Single port blockram
    Authors:    Leonard Pfeiffer
*/

module brams #(
    parameter int unsigned ADDR_ = 8,
    parameter int unsigned DATA_ = 8
)(
    input clk, aclr, we,
    input [ADDR_ - 1 : 0] addr,
    inout [DATA_ - 1 : 0] data
);
    wire [DATA_ - 1 : 0] din, dout;

    always @(posedge clk) begin
        if (aclr || we) begin
            data = 'z;
        end else begin
            data = dout;
        end
    end

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
        .address_a(addr),
        .address_b(1'b1),
        .data_a(din),
        .data_b({8{1'b1}}),
        .q_a(dout),
        .q_b(),
        .addressstall_a(1'b0),
        .addressstall_b(1'b0),
        .byteena_a(1'b1),
        .byteena_b(1'b1),
        .eccstatus()
    );

    defparam
        bram.widthad_a = ADDR_,
        bram.numwords_a = 2**ADDR_,
        bram.width_a = DATA_,
        bram.clock_enable_input_a = "BYPASS",
        bram.clock_enable_output_a = "BYPASS",
        bram.intended_device_family = "MAX 10",
        bram.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
        bram.lpm_type = "altsyncram",
        bram.operation_mode = "SINGLE_PORT",
        bram.outdata_aclr_a = "CLEAR0",
        bram.outdata_reg_a = "CLOCK0",
        bram.power_up_uninitialized = "FALSE",
        bram.read_during_write_mode_port_a = "NEW_DATA_WITH_NBE_READ",
        bram.width_byteena_a = 1;
endmodule