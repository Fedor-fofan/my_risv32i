`timescale 1ns/1ps

`include "mr_cpu.svh"

module alu (
    input [`XLEN-1:0] srcA,
    input [`XLEN-1:0] srcB,
    input [3:0] opcode,

    output logic [`XLEN-1:0] result
);
    
    always @(*) begin
        case (opcode)
        `ALUADD : result = srcA + srcB;
        `ALUSUB : result = srcA - srcB;
        `ALUAND : result = srcA & srcB;
        `ALUOR  : result = srcA | srcB;
        `ALUXOR : result = srcA ^ srcB;
        `ALUSLL : result = srcA << srcB[4:0];
        `ALUSRL : result = srcA >> srcB[4:0];
        `ALUSRA : result = $signed(srcA) >>> srcB[4:0];
        `ALUSLT : result = ($signed(srcA) < $signed(srcB)) ? 32'd1 : 32'd0;
        `ALUSLTU: result = (srcA < srcB) ? 32'd1 : 32'd0; 
        default: result = 32'd0;
        endcase
    end

endmodule