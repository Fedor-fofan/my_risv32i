`timescale 1ns/1ps

`include "mr_cpu.svh"

module unit_control (
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,

    // register file
    output logic regWrite,

    // memory
    output logic memWrite,
    output logic [3:0] memControl,

    // control flow
    output logic [1:0] pc_control,
    output logic [2:0] branch_control,

    // ALU
    output logic aluSrcA,
    output logic aluSrcB,
    output logic [3:0] aluControl,

    // writeback select
    output logic [1:0] wb_sel
);

    always_comb begin

    regWrite      = 0;

    memWrite      = 0;
    memControl    = 0;

    pc_control    = `PC_PLUS4;
    branch_control= 0;

    aluSrcA       = 0;
    aluSrcB       = 0;
    aluControl    = `ALUADD;

    wb_sel        = `WBSRCALU;

        casez({func7, func3, opcode})

        ////////////////////////////////////////////////
        //------------------U-TYPE--------------------//
        ////////////////////////////////////////////////

        {`RVF7ANY, `RVF3ANY, `RVOPLUI} : begin
            regWrite = 1; wb_sel = `WBSRCIMM; 
        end

        ////////////////////////////////////////////////
        //------------------I-TYPE--------------------//
        ////////////////////////////////////////////////

        {`RVF7ANY, `RVF3ANY, `RVOPAUIPC}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcA = 1; aluSrcB = 1; aluControl = `ALUADD;
        end

        {`RVF7ANY, `RVF3ADDI, `RVOPADDI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUADD;
        end

        {`RVF7ANY, `RVF3SLTI, `RVOPSLTI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUSLT;
        end

        {`RVF7ANY, `RVF3SLTIU, `RVOPSLTIU}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUSLTU;
        end

        {`RVF7ANY, `RVF3XORI, `RVOPXORI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUXOR;
        end

        {`RVF7ANY, `RVF3ORI, `RVOPORI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUOR;
        end

        {`RVF7ANY, `RVF3ANDI, `RVOPANDI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUAND;
        end

        {`RVF7SLLI, `RVF3SLLI, `RVOPSLLI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUSLL;
        end

        {`RVF7SRLI, `RVF3SRLI, `RVOPSRLI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUSRL;
        end

        {`RVF7SRAI, `RVF3SRAI, `RVOPSRAI}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluSrcB = 1; aluControl = `ALUSRA;
        end

        ////////////////////////////////////////////////
        //------------------R-TYPE--------------------//
        ////////////////////////////////////////////////
        
        {`RVF7ADD, `RVF3ADD, `RVOPADD}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUADD;
        end

        {`RVF7SUB, `RVF3SUB, `RVOPSUB}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSUB;
        end

        {`RVF7SLL, `RVF3SLL, `RVOPSLL}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSLL;
        end

        {`RVF7SLT, `RVF3SLT, `RVOPSLT}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSLT;
        end

        {`RVF7SLTU, `RVF3SLTU, `RVOPSLTU}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSLTU;
        end

        {`RVF7XOR, `RVF3XOR, `RVOPXOR}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUXOR;
        end

        {`RVF7SRL, `RVF3SRL, `RVOPSRL}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSRL;
        end
        
        {`RVF7SRA, `RVF3SRA, `RVOPSRA}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUSRA;
        end

        {`RVF7OR, `RVF3OR, `RVOPOR}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUOR;
        end
        
        {`RVF7AND, `RVF3AND, `RVOPAND}: begin
            regWrite = 1; wb_sel = `WBSRCALU; aluControl = `ALUAND;
        end

        ////////////////////////////////////////////////
        //------------------S-TYPE--------------------//
        ////////////////////////////////////////////////

        {`RVF7ANY, `RVF3SB, `RVOPSB}: begin
            memWrite = 1; aluSrcB = 1; aluControl = `ALUADD; memControl = `MEMSB; 
        end

        {`RVF7ANY, `RVF3SH, `RVOPSH}: begin
            memWrite = 1; memControl = `MEMSH; aluControl = `ALUADD; aluSrcB = 1;
        end

        {`RVF7ANY, `RVF3SW, `RVOPSW}: begin
            memWrite = 1; memControl = `MEMSW; aluSrcB = 1; aluControl = `ALUADD;
        end

        ///////////////////////////////////////////////
        //-------------------l-TYPE------------------//
        ///////////////////////////////////////////////

        {`RVF7ANY, `RVF3LB, `RVOPLB}: begin
            regWrite = 1; wb_sel = `WBSRCMEM; aluSrcB = 1;
            aluControl = `ALUADD; memControl = `MEMLB;
        end

        {`RVF7ANY, `RVF3LBU, `RVOPLBU}: begin
            regWrite = 1; wb_sel = `WBSRCMEM; aluSrcB = 1; 
            aluControl = `ALUADD; memControl = `MEMLBU;
        end

        {`RVF7ANY, `RVF3LH, `RVOPLH}: begin
            regWrite = 1; wb_sel = `WBSRCMEM; aluSrcB = 1; 
            aluControl = `ALUADD; memControl = `MEMLH;
        end

        {`RVF7ANY, `RVF3LHU, `RVOPLHU}: begin
            regWrite = 1; wb_sel = `WBSRCMEM; aluSrcB = 1; 
            aluControl = `ALUADD; memControl = `MEMLHU;
        end

        {`RVF7ANY, `RVF3LW, `RVOPLW}: begin
            regWrite = 1; wb_sel = `WBSRCMEM; aluSrcB = 1; 
            aluControl = `ALUADD; memControl = `MEMLW;
        end

        ////////////////////////////////////////////////
        //------------------J-TYPE--------------------//
        ////////////////////////////////////////////////

        {`RVF7ANY, `RVF3ANY, `RVOPJAL}: begin
            regWrite = 1; pc_control = `PC_JAL; wb_sel = `WBSRCJAL; 
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3JALR, `RVOPJALR}: begin
            regWrite = 1; pc_control = `PC_JALR; wb_sel = `WBSRCJAL;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end
        
        ////////////////////////////////////////////////
        //------------------B-TYPE--------------------//
        ////////////////////////////////////////////////

        {`RVF7ANY, `RVF3BEQ, `RVOPBEQ}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BEQ; 
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3BNE, `RVOPBNE}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BNE;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3BGE, `RVOPBGE}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BGE;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3BGEU, `RVOPBGEU}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BGEU;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3BLT, `RVOPBLT}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BLT;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end

        {`RVF7ANY, `RVF3BLTU, `RVOPBLTU}: begin
            pc_control = `PC_BRANCH; branch_control = `RVF3BLTU;
            aluSrcB = 1; aluControl = `ALUADD; aluSrcA = 1;
        end
        endcase
    end

endmodule