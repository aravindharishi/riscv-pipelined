
`timescale 1ns/1ps

module tb_decoder;

    logic [31:0] instruction;
    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [6:0] funct7;

    instruction_decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );

    initial begin

        // add x5, x1, x2
        instruction = 32'h002082B3;

        #10;

        $display("Opcode = %b", opcode);
        $display("rd     = %d", rd);
        $display("rs1    = %d", rs1);
        $display("rs2    = %d", rs2);
        $display("funct3 = %b", funct3);
        $display("funct7 = %b", funct7);

        if (opcode === 7'b0110011 &&
            rd     === 5'd5 &&
            rs1    === 5'd1 &&
            rs2    === 5'd2 &&
            funct3 === 3'b000 &&
            funct7 === 7'b0000000)
            $display("ADD DECODE: PASS");
        else
            $fatal(1, "ADD DECODE: FAIL");

        $finish;
    end

endmodule
