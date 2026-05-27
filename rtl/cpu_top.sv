`timescale 1ns/1ps

`include "mr_cpu.svh"

module cpu_top (
    input  logic clk,
    input  logic rst
);

    
    // FETCH
    
    logic [`XLEN-1:0] pc, pc_next;

    // instruction memory
    logic [`XLEN-1:0] instr;

    rom imem (
        .addr(pc[$clog2(`ROMSIZE)-1:0]),
        .data(instr)
    );

    
    // DECODE
    
    logic [6:0] opcode;
    logic [2:0] func3;
    logic [6:0] func7;

    assign opcode = instr[6:0];
    assign func3  = instr[14:12];
    assign func7  = instr[31:25];


    // CONTROL UNIT

    logic regWrite, memWrite;
    logic [3:0] memControl;
    logic [1:0] pc_control;
    logic [2:0] branch_control;
    logic aluSrcA, aluSrcB;
    logic [3:0] aluControl;
    logic [1:0] wb_sel;

    unit_control cu (
        .opcode(opcode),
        .func3(func3),
        .func7(func7),

        .regWrite(regWrite),
        .memWrite(memWrite),
        .memControl(memControl),

        .pc_control(pc_control),
        .branch_control(branch_control),

        .aluSrcA(aluSrcA),
        .aluSrcB(aluSrcB),
        .aluControl(aluControl),

        .wb_sel(wb_sel)
    );


    // REGISTER FILE
    logic [$clog2(`REG_COUNT)-1:0] rs1_addr, rs2_addr, rd_addr;
    logic [`XLEN-1:0] rs1_data, rs2_data;
    logic [`XLEN-1:0] wb_data;

    assign rs1_addr = instr[19:15];
    assign rs2_addr = instr[24:20];
    assign rd_addr  = instr[11:7];

    register_file rf (
        .clk(clk),
        .rst(rst),
        .we(regWrite),

        .addr_rs1(rs1_addr),
        .addr_rs2(rs2_addr),
        .addr_rd(rd_addr),

        .rd(wb_data),

        .rs1(rs1_data),
        .rs2(rs2_data)
    );

    
    // imm generator
    
    logic [`XLEN-1:0] imm;

    imm_gen immu (
        .instruction(instr),
        .imm(imm)
    );

    // alu input mux
    logic [`XLEN-1:0] alu_a, alu_b;
    logic [`XLEN-1:0] alu_result;

    assign alu_a = (aluSrcA) ? pc      : rs1_data;
    assign alu_b = (aluSrcB) ? imm     : rs2_data;

    // ALU
    alu alu0 (
        .srcA(alu_a),
        .srcB(alu_b),
        .opcode(aluControl),
        .result(alu_result)
    );


    //branch unit

    logic take_branch;

    branch_unit bu (
        .operA(rs1_data),
        .operB(rs2_data),
        .opcode(branch_control),
        .take_branch(take_branch)
    );

     // data memort

    logic [`XLEN-1:0] mem_rdata;

    dmem dmem0 (
        .clk(clk),
        .we(memWrite),
        .addr(alu_result[$clog2(`MEMSIZE)-1:0]),
        .memControl(memControl),
        .wdata(rs2_data),
        .rdata(mem_rdata)
    );

    // wb sel 

    always_comb begin
        case (wb_sel)
            `WBSRCALU: wb_data = alu_result;
            `WBSRCMEM: wb_data = mem_rdata;
            `WBSRCIMM: wb_data = imm;
            `WBSRCJAL: wb_data = pc + 4;
            default:   wb_data = alu_result;
        endcase
    end

    // pc logic
    pc_unit pcu (
        .current_pc(pc),
        .sel(pc_control),
        .take_branch(take_branch),
        .imm_jump(alu_result),
        .pc_next(pc_next)
    );

    always_ff @(posedge clk) begin
        if (rst)
            pc <= 0;
        else
            pc <= pc_next;
    end

endmodule