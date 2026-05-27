// Константы cpu

`ifndef SR_CPU_SVH
`define SR_CPU_SVH

// ширина регистра
`define XLEN 32

// количество регистров в регистровом файле
`define REG_COUNT 32

//команды OPCODE
`define RVOPLUI       7'b0110111   // load upper immediate: place upper immediate into destination register rd
`define RVOPAUIPC     7'b0010111   // add upper immediate to PC: is used to build pc-relative addresses  
`define RVOPJAL       7'b1101111   // jump and link: store PC+4 to rd and imm-J offset e.g. for jump in function
`define RVOPJALR      7'b1100111   // jump and link register: PC+4 to rd, PC = imm-J+rs1(lsb rs1 set to zero) e.g.
`define RVOPBEQ       7'b1100011   // branch if equal: if(rs1 == rs2) PC = PC + imm-B else PC = PC + 4
`define RVOPBNE       7'b1100011   // branch if not equal: if(rs1 != rs2) PC = PC + imm-B esle PC = PC + 4
`define RVOPBLT       7'b1100011   // branch if less than: if(rs1 < rs2) PC = PC + imm-B esle PC = PC + 4
`define RVOPBGE       7'b1100011   // branch if greater or equal: if(rs1 >= rs2) PC = PC + imm-B else PC = PC+4
`define RVOPBLTU      7'b1100011   // U means unsigned BLTU(branch if less than (unsigned))
`define RVOPBGEU      7'b1100011   // branch if greater or equal (unsigned)
`define RVOPLB        7'b0000011   // load byte: rd = signed(MEM[rs1 + imm][7:0])
`define RVOPLH        7'b0000011   // load half word(2-bytes) rd = signed(MEM[rs1 + imm][15:0])
`define RVOPLW        7'b0000011   // load word(4-byte) rd = signed(MEM[rs1+imm][31:0])
`define RVOPLBU       7'b0000011   // load byte unsigned rd = zero_extend(MEM[rs1+imm][7:0])
`define RVOPLHU       7'b0000011   // load half word unsigned rd = zero_extend(MEM[rs1+imm][15:0])
`define RVOPSB        7'b0100011   // store byte MEM[rs1 + imm][7:0] = rs2[7:0]
`define RVOPSH        7'b0100011   // store half word MEM[rs1 + imm][15:0] = rs2[15:0]
`define RVOPSW        7'b0100011   // store word MEM[rs1 + imm][31:0] = rs2[31:0]
`define RVOPADDI      7'b0010011   // add immediate rd = rs1 + imm
`define RVOPSLTI      7'b0010011   // set less than immediate rd = (signed(rs1) < signed(imm)) ? 1 : 0
`define RVOPSLTIU     7'b0010011   // set less than immediate unsgined rd = (unsigned(rs1) < unsigned(imm)) ? 1 : 0
`define RVOPXORI      7'b0010011   // XOR imm: rd = rs1 ^ imm 
`define RVOPORI       7'b0010011   // OR imm: rd = rs1 | imm
`define RVOPANDI      7'b0010011   // AND imm: rd = rs1 & imm
`define RVOPSLLI      7'b0010011   // shift left logical imm: rd = rs1 << shamt
`define RVOPSRLI      7'b0010011   // shift right logical imm: rd = rs1 >> shamt
`define RVOPSRAI      7'b0010011   // shift right arithmetic imm: rd = signed(rs1) >> shamt (signed-extended)
`define RVOPADD       7'b0110011   // add rd = rs1 + rs2 
`define RVOPSUB       7'b0110011   // sub  rd = rs1 - rs2
`define RVOPSLL       7'b0110011   // shift left logical rd = rs1 << rs2[4:0] 
`define RVOPSLT       7'b0110011   // set less than rd = (rs1 < rs2) ? 1 : 0
`define RVOPSLTU      7'b0110011   // set less than unsigned rd = (unsigned(rs1) < (unsigned(rs2))) ? 1 : 0
`define RVOPXOR       7'b0110011   // XOR rd = rs1 ^ rs2
`define RVOPSRL       7'b0110011   // shift right logical rd = rs1 >> rs2
`define RVOPSRA       7'b0110011   // shift right arythmetical rd = rs1 >> rs2 sign extend
`define RVOPOR        7'b0110011   // OR rd = rs1 | rs2
`define RVOPAND       7'b0110011   // AND rd = rs1 & rs2
//конец OPCODE

// func3

//Jump
`define RVF3JALR      3'b000

//Branch
`define RVF3BEQ       3'b000
`define RVF3BNE       3'b001
`define RVF3BLT       3'b100
`define RVF3BGE       3'b101
`define RVF3BLTU      3'b110
`define RVF3BGEU      3'b111

//LOAD
`define RVF3LB        3'b000
`define RVF3LH        3'b001
`define RVF3LW        3'b010
`define RVF3LBU       3'b100
`define RVF3LHU       3'b101

//STORE
`define RVF3SB        3'b000
`define RVF3SH        3'b001
`define RVF3SW        3'b010

// Immediate

`define RVF3ADDI      3'b000
`define RVF3SLTI      3'b010
`define RVF3SLTIU     3'b011
`define RVF3XORI      3'b100
`define RVF3ORI       3'b110
`define RVF3ANDI      3'b111
`define RVF3SLLI      3'b001
`define RVF3SRLI      3'b101
`define RVF3SRAI      3'b101

// Operations

`define RVF3ADD       3'b000
`define RVF3SUB       3'b000
`define RVF3SLL       3'b001
`define RVF3SLT       3'b010
`define RVF3SLTU      3'b011
`define RVF3XOR       3'b100
`define RVF3SRL       3'b101
`define RVF3SRA       3'b101
`define RVF3OR        3'b110
`define RVF3AND      3'b111

`define RVF3ANY       3'b???
// end func3

//func7

// Immediate
`define RVF7SLLI      7'b0000000
`define RVF7SRLI      7'b0000000
`define RVF7SRAI      7'b0100000

// Operations
`define RVF7ADD       7'b0000000
`define RVF7SUB       7'b0100000
`define RVF7SLL       7'b0000000
`define RVF7SLT       7'b0000000
`define RVF7SLTU      7'b0000000
`define RVF7XOR       7'b0000000
`define RVF7SRL       7'b0000000
`define RVF7SRA       7'b0100000
`define RVF7OR        7'b0000000
`define RVF7AND       7'b0000000

`define RVF7ANY       7'b???????
// end func7

// ALU opcode

`define ALUADD         4'b0000
`define ALUSUB         4'b0001
`define ALUAND         4'b0010
`define ALUOR          4'b0011
`define ALUXOR         4'b0100
`define ALUSLT         4'b0101
`define ALUSLTU        4'b0110
`define ALUSLL         4'b0111
`define ALUSRL         4'b1000
`define ALUSRA         4'b1001

// end ALU opcode

`define MEMSIZE (1024*4)
`define ROMSIZE (256*4)

// write_back source

`define WBSRCALU 2'b00
`define WBSRCMEM 2'b01
`define WBSRCIMM 2'b10
`define WBSRCJAL 2'b11

// memory operation control 

`define MEMLB    4'b0000
`define MEMLBU   4'b0100
`define MEMLH    4'b0001
`define MEMLHU   4'b0101
`define MEMLW    4'b0111
`define MEMRD    4'b0010
`define MEMSB    4'b1000
`define MEMSH    4'b1001
`define MEMSW    4'b1010

// pc control 
`define PC_PLUS4   2'b00
`define PC_BRANCH  2'b01
`define PC_JAL     2'b10
`define PC_JALR    2'b11

`endif