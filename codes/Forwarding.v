module Forwarding_Unit (
    EXRs1_i,
    EXRs2_i,
    MEMRd_i,
    MEMRegWrite_i,
    WBRd_i,
    WBRegWrite_i,
    ForwardA_o,
    ForwardB_o,
);

input      [4:0]  EXRs1_i;
input      [4:0]  EXRs2_i;
input      [4:0]  MEMRd_i;
input             MEMRegWrite_i;
input      [4:0]  WBRd_i,
input             WBRegWrite_i;

output reg [31:0] ForwardA_o;
output reg [31:0] ForwardB_o;

always@(EXRs1_i, EXRs2_i, MEMRd_i, MEMRegWrite_i, WBRd_i, WBRegWrite_i) begin
    // EX hazard
    if (MEMRegWrite_i && MEMRd_i != 5'b00000 && MEMRd_i == EXRs1_i)
        ForwardA_o = 2'b10;
    else
        ForwardA_o = 2'b00;

    if (MEMRegWrite_i && MEMRd_i != 5'b00000 && MEMRd_i == EXRs2_i)
        ForwardB_o = 2'b10;
    else
        ForwardB_o = 2'b00;
    
    // MEM hazard
    if (WBRegWrite_i && WBRd_i != 5'b00000
        && !(MEMRegWrite_i && MEMRd_i != 5'b00000 && MEMRd_i == EXRs1_i)
        && (WBRd_i == EXRs1_i))
        ForwardA_o = 2'b01;
    else
        ForwardA_o = 2'b00;

    if (WBRegWrite_i && WBRd_i != 5'b00000
        && !(MEMRegWrite_i && MEMRd_i != 5'b00000 && MEMRd_i == EXRs2_i)
        && (WBRd_i == EXRs2_i))
        ForwardB_o = 2'b01;
    else
        ForwardB_o = 2'b00;
end

endmodule

module MUXForward (
    select_i,
    MEMALUResult_i,
    WBWriteData_i,
    EXReadData_i,
    result_o
);

input      [1:0]   select_i;
input      [31:0]  MEMALUResult_i;
input      [31:0]  WBWriteData_i;
input      [31:0]  EXReadData_i;
output reg [31:0]  result_o;

always@(select_i, MEMALUResult_i, WBWriteData_i, EXReadData_i) begin
    case (select_i)
        2'b00: result_o = EXReadData_i;
        2'b01: result_o = WBWriteData_i;
        2'b10: result_o = MEMALUResult_i;
    endcase
end

endmodule

endmodule
