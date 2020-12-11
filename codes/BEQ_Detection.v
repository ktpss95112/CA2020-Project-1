`ifndef BEQ_DETECTION_V
`define BEQ_DETECTION_V

module BEQ_Detection (
    Branch_i,
    RS1data_i,
    RS2data_i,
    BranchTaken_o
);

input           Branch_i;
input   [31:0]  RS1data_i;
input   [31:0]  RS2data_i;

output          BranchTaken_o;

assign BranchTaken_o = (RS1data_i == RS2data_i) & Branch_i;

endmodule

`endif
