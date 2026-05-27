`timescale 1ns/1ps

`include "mr_cpu.svh"

module register_file #(
    localparam REG_COUNT = 32
)(
    input clk,
    input rst,

    input we,

    input [$clog2(REG_COUNT)-1:0] addr_rs1, addr_rs2, addr_rd,
    input [`XLEN-1:0] rd,

    output logic [`XLEN-1:0] rs1, rs2
);

    logic [`XLEN-1:0] rf [0:REG_COUNT-1];
    
    always_ff @( posedge clk ) begin

        if(rst) rf[2] <= 0;

        if(we) begin
            if(addr_rd != 0) rf[addr_rd] <= rd;
        end
    end

    assign rs1 = addr_rs1 == 0 ? 0 : rf[addr_rs1];
    assign rs2 = addr_rs2 == 0 ? 0 : rf[addr_rs2];

endmodule