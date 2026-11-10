
module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,

    output logic       reg_write,
    output logic       alu_src,
    output logic [3:0] alu_control,
    output logic       valid_instr
);

    localparam logic [6:0] OP_REG = 7'b0110011;
    localparam logic [6:0] OP_IMM = 7'b0010011;

    localparam logic [3:0] ALU_ADD  = 4'b0000;
    localparam logic [3:0] ALU_SUB  = 4'b0001;
    localparam logic [3:0] ALU_AND  = 4'b0010;
    localparam logic [3:0] ALU_OR   = 4'b0011;
    localparam logic [3:0] ALU_XOR  = 4'b0100;
    localparam logic [3:0] ALU_SLL  = 4'b0101;
    localparam logic [3:0] ALU_SRL  = 4'b0110;
    localparam logic [3:0] ALU_SRA  = 4'b0111;
    localparam logic [3:0] ALU_SLT  = 4'b1000;
    localparam logic [3:0] ALU_SLTU = 4'b1001;

    always_comb begin
        reg_write   = 1'b0;
        alu_src     = 1'b0;
        alu_control = ALU_ADD;
        valid_instr = 1'b0;

        case (opcode)

            OP_REG: begin
                alu_src = 1'b0;

                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_ADD;
                            valid_instr = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SUB;
                            valid_instr = 1'b1;
                        end
                    end

                    3'b111: begin
                        alu_control = ALU_AND;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b110: begin
                        alu_control = ALU_OR;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b100: begin
                        alu_control = ALU_XOR;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b001: begin
                        alu_control = ALU_SLL;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SRL;
                            valid_instr = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SRA;
                            valid_instr = 1'b1;
                        end
                    end

                    3'b010: begin
                        alu_control = ALU_SLT;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b011: begin
                        alu_control = ALU_SLTU;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    default: ;
                endcase
            end

            // Register-immediate instructions
            OP_IMM: begin
                alu_src = 1'b1;

                case (funct3)
                    3'b000: begin
                        alu_control = ALU_ADD;
                        valid_instr = 1'b1;
                    end

                    3'b111: begin
                        alu_control = ALU_AND;
                        valid_instr = 1'b1;
                    end

                    3'b110: begin
                        alu_control = ALU_OR;
                        valid_instr = 1'b1;
                    end

                    3'b100: begin
                        alu_control = ALU_XOR;
                        valid_instr = 1'b1;
                    end

                    3'b010: begin
                        alu_control = ALU_SLT;
                        valid_instr = 1'b1;
                    end

                    3'b011: begin
                        alu_control = ALU_SLTU;
                        valid_instr = 1'b1;
                    end

                    3'b001: begin
                        alu_control = ALU_SLL;
                        valid_instr = (funct7 == 7'b0000000);
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin
                            alu_control = ALU_SRL;
                            valid_instr = 1'b1;
                        end
                        else if (funct7 == 7'b0100000) begin
                            alu_control = ALU_SRA;
                            valid_instr = 1'b1;
                        end
                    end

                    default: ;
                endcase
            end

            default: ;
        endcase

        reg_write = valid_instr;

    end

endmodule
