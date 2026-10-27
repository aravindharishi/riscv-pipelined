
`timescale 1ns/1ps

module tb_regfile;

    logic clk = 0;
    logic reset = 0;

    logic [4:0] rs1_addr, rs2_addr;
    logic [31:0] rs1_data, rs2_data;

    logic [4:0] rd_addr;
    logic [31:0] rd_data;
    logic reg_write;

    int errors = 0;

    // Clock period = 10 ns
    always #5 clk = ~clk;

    regfile dut (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data),
        .reg_write(reg_write)
    );

    initial begin
        rs1_addr = 0;
        rs2_addr = 0;
        rd_addr = 0;
        rd_data = 0;
        reg_write = 0;

        // Reset registers
        reset = 1;
        @(posedge clk);
        #1;
        reset = 0;

        // Write 100 into x5
        @(negedge clk);
        rd_addr = 5;
        rd_data = 100;
        reg_write = 1;

        @(posedge clk);
        #1;

        // Read x5
        rs1_addr = 5;
        #1;

        if (rs1_data === 32'd100)
            $display("WRITE/READ x5: PASS");
        else begin
            $display("WRITE/READ x5: FAIL");
            errors++;
        end
        
        @(negedge clk);
        rd_addr = 0;
        rd_data = 999;
        reg_write = 1;

        @(posedge clk);
        #1;

        rs1_addr = 0;
        #1;

        if (rs1_data === 32'd0)
            $display("x0 CONSTANT ZERO: PASS");
        else begin
            $display("x0 CONSTANT ZERO: FAIL");
            errors++;
        end

        @(negedge clk);
        rd_addr = 5;
        rd_data = 777;
        reg_write = 0;

        @(posedge clk);
        #1;

        rs1_addr = 5;
        #1;

        if (rs1_data === 32'd100)
            $display("WRITE DISABLE: PASS");
        else begin
            $display("WRITE DISABLE: FAIL");
            errors++;
        end

        if (errors == 0)
            $display("ALL REGISTER FILE TESTS PASSED");
        else
            $fatal(1, "%0d TESTS FAILED", errors);

        $finish;
    end

endmodule
