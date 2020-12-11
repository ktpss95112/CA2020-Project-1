`ifndef HAZARD_DETECTION_V
`define HAZARD_DETECTION_V

module Hazard_Detection (
    MemRead_i,
    RS1addr_i,
    RS2addr_i,
    RDaddr_i,
    Stall_o,
    NoOp_o,
    PCWrite_o
);

input           MemRead_i;
input   [4:0]   RS1addr_i;
input   [4:0]   RS2addr_i;
input   [4:0]   RDaddr_i;

output          Stall_o;
output          NoOp_o;
output          PCWrite_o;

assign Stall_o = (MemRead_i && (RDaddr_i == RS1addr_i || RDaddr_i == RS2addr_i));
assign NoOp_o = Stall_o;
assign PCWrite_o = ~Stall_o;

endmodule

`endif
