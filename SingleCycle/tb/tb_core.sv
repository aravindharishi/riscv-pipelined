
`timescale 1ns/1ps

module tb_core;

    logic clk = 0;
    logic reset = 1;

    int errors = 0;

    // 10 ns clock period
    always #5 clk = ~clk;

    riscv_core dut (
        .clk(clk),
        .reset(reset)
    );

    initial begin

endmodule
