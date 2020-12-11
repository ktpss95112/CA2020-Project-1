`ifndef CONTROL_V
`define CONTROL_V

`include "const.v"

module Control (
    NoOp_i,
    Op_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o
);

input           NoOp_i;
input   [6:0]   Op_i;

output reg          RegWrite_o;
output reg          MemtoReg_o;
output reg          MemRead_o;
output reg          MemWrite_o;
output reg  [1:0]   ALUOp_o;
output reg          ALUSrc_o;
output reg          Branch_o;

always @(Op_i, NoOp_i) begin
    if (NoOp_i) begin
        RegWrite_o  <= 1'b0;
        MemtoReg_o  <= 1'b0;
        MemRead_o   <= 1'b0;
        MemWrite_o  <= 1'b0;
        ALUOp_o     <= 2'b0;
        ALUSrc_o    <= 1'b0;
        Branch_o    <= 1'b0;
    end

    else begin
        case (Op_i)
            `OPCODE_R_TYPE: begin
                RegWrite_o  <= 1'b1;
                MemtoReg_o  <= 1'b0;
                MemRead_o   <= 1'b0;
                MemWrite_o  <= 1'b0;
                ALUOp_o     <= 2'b01;
                ALUSrc_o    <= 1'b0;
                Branch_o    <= 1'b0;
            end

            `OPCODE_I_TYPE: begin
                RegWrite_o  <= 1'b1;
                MemtoReg_o  <= 1'b0;
                MemRead_o   <= 1'b0;
                MemWrite_o  <= 1'b0;
                ALUOp_o     <= 2'b00;
                ALUSrc_o    <= 1'b1;
                Branch_o    <= 1'b0;
            end

            `OPCODE_LOAD: begin
                RegWrite_o  <= 1'b1;
                MemtoReg_o  <= 1'b1;
                MemRead_o   <= 1'b1;
                MemWrite_o  <= 1'b0;
                ALUOp_o     <= 2'b00;
                ALUSrc_o    <= 1'b1;
                Branch_o    <= 1'b0;
            end

            `OPCODE_STORE: begin
                RegWrite_o  <= 1'b0;
                MemtoReg_o  <= 1'b0;
                MemRead_o   <= 1'b0;
                MemWrite_o  <= 1'b1;
                ALUOp_o     <= 2'b01;
                ALUSrc_o    <= 1'b1;
                Branch_o    <= 1'b0;
            end

            `OPCODE_BRANCH: begin
                RegWrite_o  <= 1'b0;
                MemtoReg_o  <= 1'b0;
                MemRead_o   <= 1'b0;
                MemWrite_o  <= 1'b0;
                ALUOp_o     <= 2'b11;
                ALUSrc_o    <= 1'b0;
                Branch_o    <= 1'b1;
            end

           default: begin
               RegWrite_o  <= 1'b0;
               MemtoReg_o  <= 1'b0;
               MemRead_o   <= 1'b0;
               MemWrite_o  <= 1'b0;
               ALUOp_o     <= 2'b0;
               ALUSrc_o    <= 1'b0;
               Branch_o    <= 1'b0;
           end

        endcase
    end
end

endmodule

`endif
