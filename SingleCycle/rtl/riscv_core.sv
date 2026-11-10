
module riscv_core (
    input logic clk,
    input logic reset
);

    logic [31:0] pc;

    logic [31:0] instr_mem [0:255];
    logic [31:0] instruction;

    logic [6:0] opcode;
    logic [4:0] rd;
    logic [2:0] funct3;
    logic [4:0] rs1, rs2;
    logic [6:0] funct7;

    logic [31:0] rs1_data, rs2_data;
    logic [31:0] immediate;
    logic [31:0] alu_operand_b;
    logic [31:0] alu_result;

    logic reg_write;
    logic alu_src;
    logic [3:0] alu_control;
    logic valid_instr;

    initial begin
        $readmemh("programs/test.hex", instr_mem);
    end

    // Fetch instruction using byte-addressed PC
    assign instruction = instr_mem[pc[9:2]];

    always_ff @(posedge clk) begin
        if (reset)
            pc <= 32'd0;
        else
            pc <= pc + 32'd4;
    end

    instruction_decoder decoder (
        .instruction(instruction),
        .opcode(opcode),
        .rd(rd),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .funct7(funct7)
    );

    immediate_gen imm_gen (
        .instruction(instruction),
        .immediate(immediate)
    );

    control_unit control (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_control(alu_control),
        .valid_instr(valid_instr)
    );

    regfile registers (
        .clk(clk),
        .reset(reset),
        .rs1_addr(rs1),
        .rs2_addr(rs2),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .rd_addr(rd),
        .rd_data(alu_result),
        .reg_write(reg_write && !reset)
    );

    assign alu_operand_b = alu_src? immediate : rs2_data;

    alu execute_alu (
        .operand_a(rs1_data),
        .operand_b(alu_operand_b),
        .alu_control(alu_control),
        .result(alu_result)
    );

endmodule
