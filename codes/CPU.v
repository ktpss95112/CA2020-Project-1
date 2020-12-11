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
`include "BEQ_Detection.v"
`include "Forwarding.v"

module CPU (
    clk_i,
    rst_i,
    start_i
);

// Ports
input clk_i;
input rst_i;
input start_i;


wire Flush;
assign Flush = BEQ_Detection.BranchTaken_o;


Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

MUX32 PC_Source(
    .data0_i    (Add_PC.data_o),
    .data1_i    (Add_Branch_PC.data_o),
    .select_i   (Flush),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (Hazard_Detection.PCWrite_o),
    .pc_i       (PC_Source.data_o),
    .pc_o       ()
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o),
    .instr_o    ()
);

PipelineRegIFID IFID(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .instr_i    (Instruction_Memory.instr_o),
    .pc_i       (PC.pc_o),
    .stall_i    (Hazard_Detection.Stall_o),
    .flush_i    (Flush),
    .instr_o    (),
    .pc_o       ()
);

Adder Add_Branch_PC(
    .data1_in   ($signed(ImmGen.data_o) <<< 1),
    .data2_in   (IFID.pc_o),
    .data_o     ()
);

Control Control(
    .NoOp_i     (Hazard_Detection.NoOp_o),
    .Op_i       (IFID.instr_o[6:0]),
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
    .RS1addr_i  (IFID.instr_o[19:15]),
    .RS2addr_i  (IFID.instr_o[24:20]),
    .RDaddr_i   (MEMWB.RDaddr_o),
    .RDdata_i   (MUX_RegWriteSrc.data_o),
    .RegWrite_i (MEMWB.RegWrite_o),
    .RS1data_o  (),
    .RS2data_o  ()
);

BEQ_Detection BEQ_Detection(
    .Branch_i       (Control.Branch_o),
    .RS1data_i      (Registers.RS1data_o),
    .RS2data_i      (Registers.RS2data_o),
    .BranchTaken_o  ()
);

Sign_Extend ImmGen(
    .data_i     (IFID.instr_o),
    .data_o     ()
);

PipelineRegIDEX IDEX(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .RegWrite_i (Control.RegWrite_o),
    .MemtoReg_i (Control.MemtoReg_o),
    .MemRead_i  (Control.MemRead_o),
    .MemWrite_i (Control.MemWrite_o),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUSrc_i   (Control.ALUSrc_o),
    .RS1data_i  (Registers.RS1data_o),
    .RS2data_i  (Registers.RS2data_o),
    .imm_i      (ImmGen.data_o),
    .instr_i    (IFID.instr_o),
    .RegWrite_o (),
    .MemtoReg_o (),
    .MemRead_o  (),
    .MemWrite_o (),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RS1data_o  (),
    .RS2data_o  (),
    .imm_o      (),
    .instr_o    ()
);

MUX32 MUX_ALUSrc(
    .data0_i    (MUX_Forward_B.data_o),
    .data1_i    (IDEX.imm_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (MUX_Forward_A.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({IDEX.instr_o[31:25], IDEX.instr_o[14:12]}),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);

PipelineRegEXMEM EXMEM(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (IDEX.RegWrite_o),
    .MemtoReg_i     (IDEX.MemtoReg_o),
    .MemRead_i      (IDEX.MemtoReg_o),
    .MemWrite_i     (IDEX.MemWrite_o),
    .ALUResult_i    (ALU.data_o),
    .RS2data_i      (MUX_Forward_B.data_o),
    .RDaddr_i       (IDEX.instr_o[11:7]),
    .ALUResult_o    (),
    .RS2data_o      (),
    .MemRead_o      (),
    .MemtoReg_o     (),
    .MemWrite_o     (),
    .RegWrite_o     (),
    .RDaddr_o       ()
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .addr_i     (EXMEM.ALUResult_o),
    .MemRead_i  (EXMEM.MemRead_o),
    .MemWrite_i (EXMEM.MemWrite_o),
    .data_i     (EXMEM.RS2data_o),
    .data_o     ()
);

PipelineRegMEMWB MEMWB(
    .clk_i          (clk_i),
    .rst_i          (rst_i),
    .RegWrite_i     (EXMEM.RegWrite_o),
    .MemtoReg_i     (EXMEM.MemtoReg_o),
    .ALUResult_i    (EXMEM.ALUResult_o),
    .Memdata_i      (Data_Memory.data_o),
    .RDaddr_i       (EXMEM.RDaddr_o),
    .RegWrite_o     (),
    .Memdata_o      (),
    .ALUResult_o    (),
    .MemtoReg_o     (),
    .RDaddr_o       ()
);

MUX32 MUX_RegWriteSrc(
    .data0_i    (MEMWB.ALUResult_o),
    .data1_i    (MEMWB.Memdata_o),
    .select_i   (MEMWB.MemtoReg_o),
    .data_o     ()
);

Hazard_Detection Hazard_Detection(
    .MemRead_i  (IDEX.MemRead_o),
    .RS1addr_i  (IFID.instr_o[19:15]),
    .RS2addr_i  (IFID.instr_o[24:20]),
    .RDaddr_i   (IDEX.instr_o[11:7]),
    .Stall_o    (),
    .NoOp_o     (),
    .PCWrite_o  ()
);

Forwarding_Unit Forwarding_Unit(
    .EXRS1_i        (IDEX.instr_o[19:15]),
    .EXRS2_i        (IDEX.instr_o[24:20]),
    .MEMRD_i        (EXMEM.RDaddr_o),
    .MEMRegWrite_i  (EXMEM.RegWrite_o),
    .WBRD_i         (MEMWB.RDaddr_o),
    .WBRegWrite_i   (MEMWB.RegWrite_o),
    .ForwardA_o     (),
    .ForwardB_o     ()
);

MUX32_4 MUX_Forward_A(
    .data00_i   (IDEX.RS1data_o),
    .data01_i   (MUX_RegWriteSrc.data_o),
    .data10_i   (EXMEM.ALUResult_o),
    .data11_i   (0),
    .select_i   (Forwarding_Unit.ForwardA_o),
    .data_o     ()
);

MUX32_4 MUX_Forward_B(
    .data00_i   (IDEX.RS2data_o),
    .data01_i   (MUX_RegWriteSrc.data_o),
    .data10_i   (EXMEM.ALUResult_o),
    .data11_i   (0),
    .select_i   (Forwarding_Unit.ForwardB_o),
    .data_o     ()
);

endmodule

