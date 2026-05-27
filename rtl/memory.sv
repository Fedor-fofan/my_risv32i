`timescale 1ns/1ps

`include "mr_cpu.svh"

module dmem (
    input clk,

    input we,

    input [3:0] memControl,

    input [$clog2(`MEMSIZE)-1:0] addr,
    input [`XLEN-1:0] wdata,

    output logic [`XLEN-1:0] rdata
);

    logic [7:0] mem [0:`MEMSIZE-1];

    always_ff @(posedge clk) begin

        if (we) begin

            case (memControl)

            `MEMSB: begin

                mem[addr] <= wdata[7:0];

            end

            `MEMSH: begin

                mem[addr]     <= wdata[7:0];
                mem[addr + 1] <= wdata[15:8];

            end

            `MEMSW: begin

                mem[addr]     <= wdata[7:0];
                mem[addr + 1] <= wdata[15:8];
                mem[addr + 2] <= wdata[23:16];
                mem[addr + 3] <= wdata[31:24];

            end

            endcase
        end
    end

    always @(*) begin

        case (memControl)

        `MEMLB: begin

            rdata = {
                {24{mem[addr][7]}},
                mem[addr]
            };

        end

        `MEMLBU: begin

            rdata = {
                24'b0,
                mem[addr]
            };

        end

        `MEMLH: begin

            rdata = {

                {16{mem[addr + 1][7]}},

                mem[addr + 1],
                mem[addr]

            };

        end

        `MEMLHU: begin

            rdata = {

                16'b0,

                mem[addr + 1],
                mem[addr]

            };

        end

        `MEMLW: begin

            rdata = {

                mem[addr + 3],
                mem[addr + 2],
                mem[addr + 1],
                mem[addr]

            };

        end

        default: begin

            rdata = 32'b0;

        end

        endcase
    end

endmodule