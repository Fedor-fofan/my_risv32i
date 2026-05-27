`timescale 1ns/1ps

`include "mr_cpu.svh"


module decoder(
    input [`XLEN-1:0] instruction, 
    
    output logic [6:0] opcode,

    output logic [$clog2(`REG_COUNT)-1:0] rs1, rs2, rd,

    output logic [2:0] func3,
    output logic [6:0] func7

);

    assign opcode = instruction[6:0];
    assign rd = instruction[11:7];
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign func3 = instruction[14:12];
    assign func7 = instruction[31:25];

endmodule