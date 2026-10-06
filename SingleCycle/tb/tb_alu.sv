module tb_alu;

    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [3:0]  alu_control;

    logic [31:0] result;


    alu dut (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_control(alu_control),
        .result(result)
    );


    initial begin

    // ADD
    operand_a = 32'd5;
    operand_b = 32'd10;
    alu_control = 4'b0000;

    #10;

    if (result == 32'd15)
        $display("ADD: PASS");
    else
        $display("ADD: FAIL - result = %d", result);


    // SUB
    operand_a = 32'd20;
    operand_b = 32'd7;
    alu_control = 4'b0001;

    #10;

    if (result == 32'd13)
        $display("SUB: PASS");
    else
        $display("SUB: FAIL - result = %d", result);


    // AND
    operand_a = 32'b1100;
    operand_b = 32'b1010;
    alu_control = 4'b0010;

    #10;

    if (result == 32'b1000)
        $display("AND: PASS");
    else
        $display("AND: FAIL");


    // OR
    operand_a = 32'b1100;
    operand_b = 32'b1010;
    alu_control = 4'b0011;

    #10;

    if (result == 32'b1110)
        $display("OR: PASS");
    else
        $display("OR: FAIL");


    // XOR
    operand_a = 32'b1100;
    operand_b = 32'b1010;
    alu_control = 4'b0100;

    #10;

    if (result == 32'b0110)
        $display("XOR: PASS");
    else
        $display("XOR: FAIL");


    $finish;

end

endmodule