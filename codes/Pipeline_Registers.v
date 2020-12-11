`ifndef PIPELINE_REGISTERS_V
`define PIPELINE_REGISTERS_V

module PipelineRegIFID (
    clk_i,
    rst_i,
    instr_i,
    pc_i,
    stall_i,
    flush_i,
    instr_o,
    pc_o
);

input               clk_i;
input               rst_i;
input      [31:0]   instr_i;
input      [31:0]   pc_i;
input               stall_i;
input               flush_i;

output reg [31:0]   instr_o;
output reg [31:0]   pc_o;

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        instr_o <= 32'b0;
        pc_o    <= 32'b0;
    end
    else if (stall_i) begin

    end
    else if (flush_i) begin
        instr_o <= 32'b0;
        pc_o    <= 32'b0;
    end
    else begin
        instr_o <= instr_i;
        pc_o    <= pc_i;
    end
end

endmodule

module PipelineRegIDEX (
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    imm_i,
    instr_i,

    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    imm_o,
    instr_o
);

input                         clk_i;
input                         rst_i;
input                         RegWrite_i;
input                         MemtoReg_i;
input                         MemRead_i;
input                         MemWrite_i;
input           [1:0]         ALUOp_i;
input                         ALUSrc_i;
input           [31:0]        RS1data_i;
input           [31:0]        RS2data_i;
input           [31:0]        imm_i;
input           [31:0]        instr_i;
input           [4:0]         RS1addr_i;
input           [4:0]         RS2addr_i;

output reg                    RegWrite_o;
output reg                    MemtoReg_o;
output reg                    MemRead_o;
output reg                    MemWrite_o;
output reg      [1:0]         ALUOp_o;
output reg                    ALUSrc_o;
output reg      [31:0]        RS1data_o;
output reg      [31:0]        RS2data_o;
output reg      [31:0]        instr_o;
output reg      [31:0]        imm_o;
output reg      [4:0]         RS1addr_o;
output reg      [4:0]         RS2addr_o;

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        RegWrite_o  <= 1'b0;
        MemtoReg_o  <= 1'b0;
        MemRead_o   <= 1'b0;
        MemWrite_o  <= 1'b0;
        ALUOp_o     <= 2'b0;
        ALUSrc_o    <= 1'b0;
        RS1data_o   <= 32'b0;
        RS2data_o   <= 32'b0;
        imm_o       <= 32'b0;
        instr_o     <= 32'b0;
        RS1addr_o   <= 5'b0;
        RS2addr_o   <= 5'b0;
    end
    else begin
        RegWrite_o  <= RegWrite_i;
        MemtoReg_o  <= MemtoReg_i;
        MemRead_o   <= MemRead_i;
        MemWrite_o  <= MemWrite_i;
        ALUOp_o     <= ALUOp_i;
        ALUSrc_o    <= ALUSrc_i;
        RS1data_o   <= RS1data_i;
        RS2data_o   <= RS2data_i;
        imm_o       <= imm_i;
        instr_o     <= instr_i;
        RS1addr_o   <= RS1addr_i;
        RS2addr_o   <= RS2addr_i;
    end
end

endmodule

module PipelineRegEXMEM (
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUResult_i,
    RS2data_i,
    RDaddr_i,

    ALUResult_o,
    RS2data_o,
    MemRead_o,
    MemtoReg_o,
    MemWrite_o,
    RegWrite_o,
    RDaddr_o
);

input                  clk_i;
input                  rst_i;
input                  start_i;
input       [31:0]     ALUResult_i;
input       [31:0]     RS2data_i;
input                  MemRead_i;
input                  MemtoReg_i;
input                  MemWrite_i;
input                  RegWrite_i;
input       [4:0]      RDaddr_i;

output reg  [31:0]     ALUResult_o;
output reg  [31:0]     RS2data_o;
output reg             MemRead_o;
output reg             MemtoReg_o;
output reg             MemWrite_o;
output reg             RegWrite_o;
output reg  [4:0]      RDaddr_o;

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        ALUResult_o     <=   32'b0;
        RS2data_o       <=   32'b0;
        MemRead_o       <=   1'b0;
        MemtoReg_o      <=   1'b0;
        MemWrite_o      <=   1'b0;
        RegWrite_o      <=   1'b0;
        RDaddr_o        <=   5'b0;
    end
    else begin
        ALUResult_o     <=   ALUResult_i;
        RS2data_o       <=   RS2data_i;
        MemRead_o       <=   MemRead_i;
        MemtoReg_o      <=   MemtoReg_i;
        MemWrite_o      <=   MemWrite_i;
        RegWrite_o      <=   RegWrite_i;
        RDaddr_o        <=   RDaddr_i;
    end
end

endmodule

module PipelineRegMEMWB (
    clk_i,
    rst_i,
    RegWrite_i,
    MemtoReg_i,
    ALUResult_i,
    Memdata_i,
    RDaddr_i,

    RegWrite_o,
    Memdata_o,
    ALUResult_o,
    MemtoReg_o,
    RDaddr_o
);

input                   clk_i;
input                   rst_i;
input                   RegWrite_i;
input                   MemtoReg_i;
input       [31:0]      ALUResult_i;
input       [31:0]      Memdata_i;
input       [4:0]       RDaddr_i;

output reg              RegWrite_o;
output reg  [31:0]      Memdata_o;
output reg  [31:0]      ALUResult_o;
output reg              MemtoReg_o;
output reg  [4:0]       RDaddr_o;

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        RegWrite_o      <=   1'b0;
        Memdata_o       <=   32'b0;
        ALUResult_o     <=   32'b0;
        MemtoReg_o      <=   1'b0;
        RDaddr_o        <=   5'b0;
    end
    else begin
        RegWrite_o      <=   RegWrite_i;
        Memdata_o       <=   Memdata_i;
        ALUResult_o     <=   ALUResult_i;
        MemtoReg_o      <=   MemtoReg_i;
        RDaddr_o        <=   RDaddr_i;
    end
end
endmodule

`endif
