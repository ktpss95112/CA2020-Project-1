`ifndef FORWARDING_V
`define FORWARDING_V

module Forwarding_Unit (
    EXRS1_i,
    EXRS2_i,
    MEMRD_i,
    MEMRegWrite_i,
    WBRD_i,
    WBRegWrite_i,
    ForwardA_o,
    ForwardB_o
);

input       [4:0]   EXRS1_i;
input       [4:0]   EXRS2_i;
input       [4:0]   MEMRD_i;
input               MEMRegWrite_i;
input       [4:0]   WBRD_i;
input               WBRegWrite_i;

output reg  [1:0]   ForwardA_o;
output reg  [1:0]   ForwardB_o;

// first part: RS1 for ALU
always @(EXRS1_i, MEMRD_i, MEMRegWrite_i, WBRD_i, WBRegWrite_i) begin
    if ((EXRS1_i != 0) && MEMRegWrite_i && (MEMRD_i == EXRS1_i)) begin
        // EX hazard
        ForwardA_o = 2'b10;
    end
    else if ((EXRS1_i != 0) && WBRegWrite_i && (WBRD_i == EXRS1_i)) begin
        // MEM hazard
        ForwardA_o = 2'b01;
    end
    else begin
        // no hazard
        ForwardA_o = 2'b00;
    end
end

// second part: RS2 for ALU
always @(EXRS2_i, MEMRD_i, MEMRegWrite_i, WBRD_i, WBRegWrite_i) begin
    if ((EXRS2_i != 0) && MEMRegWrite_i && (MEMRD_i == EXRS2_i)) begin
        // EX hazard
        ForwardB_o = 2'b10;
    end
    else if ((EXRS2_i != 0) && WBRegWrite_i && (WBRD_i == EXRS2_i)) begin
        // MEM hazard
        ForwardB_o = 2'b01;
    end
    else begin
        // no hazard
        ForwardB_o = 2'b00;
    end
end

endmodule

`endif
