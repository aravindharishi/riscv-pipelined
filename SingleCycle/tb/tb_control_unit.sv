
`timescale 1ns/1ps

module tb_control_unit;

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    logic reg_write;
    logic alu_src;
    logic [3:0] alu_control;
    logic valid_instr;

    int errors = 0;

    control_unit dut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_control(alu_control),
        .valid_instr(valid_instr)
    );

    task automatic check_control(
        input string name,
        input logic [6:0] test_opcode,
        input logic [2:0] test_funct3,
        input logic [6:0] test_funct7,
        input logic expected_valid,
        input logic expected_src,
        input logic [3:0] expected_alu
    );
        opcode = test_opcode;
        funct3 = test_funct3;
        funct7 = test_funct7;

        #10;

        if (valid_instr === expected_valid &&
            reg_write === expected_valid &&
            (!expected_valid ||
              (alu_src === expected_src &&
               alu_control === expected_alu)))
            $display("%s: PASS", name);
        else begin
            $display("%s: FAIL", name);
            errors++;
        end
    endtask

    initial begin

        // ADD
        check_control(
            "ADD",
            7'b0110011,
            3'b000,
            7'b0000000,
            1'b1, 1'b0, 4'b0000
        );

        // SUB
        check_control(
            "SUB",
            7'b0110011,
            3'b000,
            7'b0100000,
            1'b1, 1'b0, 4'b0001
        );

        // AND
        check_control(
            "AND",
            7'b0110011,
            3'b111,
            7'b0000000,
            1'b1, 1'b0, 4'b0010
        );

        // ADDI
        check_control(
            "ADDI",
            7'b0010011,
            3'b000,
            7'b0000000,
            1'b1, 1'b1, 4'b0000
        );

        // SRAI
        check_control(
            "SRAI",
            7'b0010011,
            3'b101,
            7'b0100000,
            1'b1, 1'b1, 4'b0111
        );

        // Invalid R-type encoding
        check_control(
            "INVALID R-TYPE",
            7'b0110011,
            3'b000,
            7'b1111111,
            1'b0, 1'b0, 4'b0000
        );

        if (errors == 0)
            $display("ALL CONTROL TESTS PASSED");
        else
            $fatal(1, "%0d TESTS FAILED", errors);

        $finish;
    end

endmodule
