
module regfile (
    input  logic        clk,
    input  logic        reset,

    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,

    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,

    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data,
    input  logic        reg_write
);

    logic [31:0] registers [0:31];

    always_ff @(posedge clk) begin
        if (reset) begin
            for (int i = 0; i < 32; i = i + 1)
                registers[i] <= 32'd0;
        end
        else if (reg_write && rd_addr != 5'd0) begin
            registers[rd_addr] <= rd_data;
        end
    end

    assign rs1_data = (rs1_addr == 5'd0)
                    ? 32'd0 : registers[rs1_addr];

    assign rs2_data = (rs2_addr == 5'd0)
                    ? 32'd0 : registers[rs2_addr];

endmodule
