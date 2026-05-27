`timescale 1ns/1ps

`include "mr_cpu.svh"

module imm_gen (
    input [`XLEN-1:0] instruction,
    output logic [31:0] imm
);
    
localparam logic [6:0] OPCODE_LOAD    = 7'b0000011;
localparam logic [6:0] OPCODE_STORE   = 7'b0100011;

localparam logic [6:0] OPCODE_BRANCH  = 7'b1100011;

localparam logic [6:0] OPCODE_JALR    = 7'b1100111;
localparam logic [6:0] OPCODE_JAL     = 7'b1101111;

localparam logic [6:0] OPCODE_LUI     = 7'b0110111;
localparam logic [6:0] OPCODE_AUIPC   = 7'b0010111;

localparam logic [6:0] OPCODE_OP_IMM  = 7'b0010011;
localparam logic [6:0] OPCODE_OP      = 7'b0110011;

localparam logic [6:0] OPCODE_SYSTEM  = 7'b1110011;


logic [6:0] opcode;

    assign opcode = instruction[6:0];

    always @(*) begin

        case(opcode)

            // ====================
            // I-TYPE
            // ====================
            OPCODE_LOAD,
            OPCODE_OP_IMM,
            OPCODE_JALR:
            begin
                imm = {
                    {20{instruction[31]}},
                    instruction[31:20]
                };
            end


            // ====================
            // S-TYPE
            // ====================
            OPCODE_STORE:
            begin
                imm = {
                    {20{instruction[31]}},
                    instruction[31:25],
                    instruction[11:7]
                };
            end


            // ====================
            // B-TYPE
            // ====================
            OPCODE_BRANCH:
            begin
                imm = {
                    {19{instruction[31]}},
                    instruction[31],
                    instruction[7],
                    instruction[30:25],
                    instruction[11:8],
                    1'b0
                };
            end


            // ====================
            // U-TYPE
            // ====================
            OPCODE_LUI,
            OPCODE_AUIPC:
            begin
                imm = {
                    instruction[31:12],
                    12'b0
                };
            end


            // ====================
            // J-TYPE
            // ====================
            OPCODE_JAL:
            begin
                imm = {
                    {11{instruction[31]}},
                    instruction[31],
                    instruction[19:12],
                    instruction[20],
                    instruction[30:21],
                    1'b0
                };
            end


            default:
            begin
                imm = 32'b0;
            end

        endcase
    end

endmodule