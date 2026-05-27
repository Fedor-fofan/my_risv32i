`timescale 1ns/1ps

module tb_top;

    logic clk;
    logic rst;

    cpu_top dut (
        .clk (clk),
        .rst (rst)
    );

    // clock
    always #5 clk = ~clk;

    initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
    end
    initial begin

        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        #50000;

        $finish;
    end

endmodule