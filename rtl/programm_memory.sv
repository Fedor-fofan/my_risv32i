`timescale 1ns/1ps

`include "mr_cpu.svh"

module rom (
    input  logic [$clog2(`ROMSIZE)-1:0] addr,
    output logic [`XLEN-1:0] data
);

    logic [31:0] mem [0:`ROMSIZE];

    assign data = mem[addr[7:2]];

    initial begin
    integer i;

    for(i = 0; i < `ROMSIZE; i = i + 1)
        mem[i] = 32'h00000013; // NOP = addi x0,x0,0

    $readmemh("sim/programm.hex", mem);
end

endmodule