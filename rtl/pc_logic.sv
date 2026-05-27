`timescale 1ns/1ps

`include "mr_cpu.svh"

module pc_unit (
    input [`XLEN-1:0] current_pc,
    input [1:0] sel,
    input take_branch, 
    input [`XLEN-1:0] imm_jump,
    output logic [`XLEN-1:0] pc_next
);
    
    always_comb begin
        case(sel)
        `PC_PLUS4: pc_next = current_pc + 4;
        `PC_BRANCH: begin
            pc_next = take_branch ? (imm_jump) : (current_pc + 4); 
        end
        `PC_JAL: begin
            pc_next = imm_jump;
        end
        `PC_JALR: begin
            pc_next = imm_jump & 32'hFFFF_FFFE;
        end
        default: begin
            pc_next = current_pc + 4;
        end
        endcase
    end

endmodule