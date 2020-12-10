`ifndef ALU_V
`define ALU_V

`include "const.v"

module ALU (
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);

input       [31:0]  data1_i;
input       [31:0]  data2_i;
input       [2:0]   ALUCtrl_i;
output reg  [31:0]  data_o;
output              Zero_o;

assign Zero_o = data_o == 0;

always @(data1_i, data2_i, ALUCtrl_i) begin
    case (ALUCtrl_i)
        `ALU_CONTROL_CONSTANT_ADD: data_o <= data1_i + data2_i;
        `ALU_CONTROL_CONSTANT_SUB: data_o <= data1_i - data2_i;
        `ALU_CONTROL_CONSTANT_MUL: data_o <= data1_i * data2_i;
        `ALU_CONTROL_CONSTANT_AND: data_o <= data1_i & data2_i;
        `ALU_CONTROL_CONSTANT_XOR: data_o <= data1_i ^ data2_i;
        `ALU_CONTROL_CONSTANT_SLL: data_o <= data1_i << data2_i[4:0];
        `ALU_CONTROL_CONSTANT_SRA: data_o <= $signed(data1_i) >>> data2_i[4:0];
    endcase
end

endmodule

`endif
