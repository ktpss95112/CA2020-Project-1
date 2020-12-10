`ifndef ALU_CONTROL_V
`define ALU_CONTROL_V

`include "const.v"

module ALU_Control (
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input       [9:0]   funct_i;
input       [1:0]   ALUOp_i;
output reg  [2:0]   ALUCtrl_o;

always @(funct_i, ALUOp_i) begin
    if (ALUOp_i == 2'b01) begin
        // R-type || sw
        case (funct_i)
            `FUNCT_7_3_ADD: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_ADD;
            `FUNCT_7_3_SUB: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_SUB;
            `FUNCT_7_3_MUL: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_MUL;
            `FUNCT_7_3_AND: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_AND;
            `FUNCT_7_3_XOR: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_XOR;
            `FUNCT_7_3_SLL: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_SLL;
            default       : ALUCtrl_o <= `ALU_CONTROL_CONSTANT_ADD; // sw
        endcase

    end else if (ALUOp_i == 2'b00) begin
        // I-type || lw
        case (funct_i[2:0])
            `FUNCT3_ADDI: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_ADD;
            `FUNCT3_SRAI: ALUCtrl_o <= `ALU_CONTROL_CONSTANT_SRA;
            default     : ALUCtrl_o <= `ALU_CONTROL_CONSTANT_ADD; // lw
        endcase

    end else begin
        // beq
        ALUCtrl_o <= `ALU_CONTROL_CONSTANT_SUB;
    end
end

endmodule

`endif
