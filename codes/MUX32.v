`ifndef MUX32_V
`define MUX32_V

module MUX32 (
    data0_i,
    data1_i,
    select_i,
    data_o
);

input   [31:0]  data0_i;
input   [31:0]  data1_i;
input           select_i;
output  [31:0]  data_o;

assign data_o = (select_i == 0) ? data0_i : data1_i;

endmodule

`endif
