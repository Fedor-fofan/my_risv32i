`timescale 1ns/1ps

`include "mr_cpu.svh"

module branch_unit (
    input [`XLEN-1:0] operA,
    input [`XLEN-1:0] operB,
    input [2:0] opcode,
    output logic take_branch
);
    
    always_comb begin
        case (opcode)
        `RVF3BEQ: take_branch = (operA == operB);
        `RVF3BGE: take_branch = ($signed(operA) >= $signed(operB));
        `RVF3BGEU: take_branch = (operA >= operB);
        `RVF3BLT: take_branch = ($signed(operA) < $signed(operB));
        `RVF3BLTU: take_branch = (operA < operB);
        `RVF3BNE: take_branch = (operA != operB); 
            default: begin
                take_branch = 1'b0;
            end
        endcase
    end

endmodule