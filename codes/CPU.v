`include "Adder.v"
`include "ALU_Control.v"
`include "ALU.v"
`include "Control.v"
// `include "Instruction_Memory.v"
// `include "Data_Memory.v"
`include "MUX32.v"
// `include "PC.v"
// `include "Registers.v"
`include "Sign_Extend.v"
`include "Hazard_Detection.v"
`include "Pipeline_Registers.v"

module CPU (
    clk_i,
    rst_i,
    start_i
);

// Ports
input clk_i;
input rst_i;
input start_i;

wire [31:0] instr;
assign instr = PipelineRegIFID.instr_o;

wire Flush;


Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (1'd1), // TODO
    .pc_i       (Add_PC.data_o),
    .pc_o       ()
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o),
    .instr_o    ()
);

PipelineRegIFID PipelineRegIFID(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .instr_i    (Instruction_Memory.instr_o),
    .instr_o    ()
);

Control Control(
    .Op_i       (instr[6:0]),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .Branch_o   ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (instr[19:15]),
    .RS2addr_i  (instr[24:20]),
    .RDaddr_i   (instr[11:7]),
    .RDdata_i   (MUX_RegWriteSrc.data_o),
    .RegWrite_i (Control.RegWrite_o),
    .RS1data_o  (),
    .RS2data_o  ()
);

Sign_Extend ImmGen(
    .data_i     (instr[31:20]),
    .data_o     ()
);

MUX32 MUX_ALUSrc(
    .data0_i    (Registers.RS2data_o),
    .data1_i    (ImmGen.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()
);

Data_Memory Data_Memory(
    .clk_i       (clk_i),
    .addr_i      (ALU.data_o),
    .MemRead_i   (Control.MemRead_o),
    .MemWrite_i  (Control.MemWrite_o),
    .data_i      (Registers.RS2data_o),
    .data_o      ()
);

MUX32 MUX_RegWriteSrc(
    .data0_i    (ALU.data_o),
    .data1_i    (Data_Memory.data_o),
    .select_i   (Control.MemtoReg_o),
    .data_o     ()
);

Hazard_Detection Hazard_Detection(
    .Stall_o    ()
);

endmodule

