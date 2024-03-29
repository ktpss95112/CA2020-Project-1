`ifndef CONST_V
`define CONST_V

`define ALU_CONTROL_CONSTANT_ADD 3'b000
`define ALU_CONTROL_CONSTANT_SUB 3'b001
`define ALU_CONTROL_CONSTANT_MUL 3'b010
`define ALU_CONTROL_CONSTANT_AND 3'b011
`define ALU_CONTROL_CONSTANT_XOR 3'b100
`define ALU_CONTROL_CONSTANT_SLL 3'b101
`define ALU_CONTROL_CONSTANT_SRA 3'b110

`define OPCODE_R_TYPE 7'b0110011
`define OPCODE_I_TYPE 7'b0010011
`define OPCODE_LOAD   7'b0000011
`define OPCODE_STORE  7'b0100011
`define OPCODE_BRANCH 7'b1100011

`define FUNCT_7_3_ADD 10'b0000000000
`define FUNCT_7_3_SUB 10'b0100000000
`define FUNCT_7_3_MUL 10'b0000001000
`define FUNCT_7_3_AND 10'b0000000111
`define FUNCT_7_3_XOR 10'b0000000100
`define FUNCT_7_3_SLL 10'b0000000001

`define FUNCT3_ADDI 3'b000
`define FUNCT3_SRAI 3'b101

`endif
