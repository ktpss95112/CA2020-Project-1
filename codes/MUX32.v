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

module MUX32_4 (
    data00_i,
    data01_i,
    data10_i,
    data11_i,
    select_i,
    data_o
);

input   [31:0]  data00_i;
input   [31:0]  data01_i;
input   [31:0]  data10_i;
input   [31:0]  data11_i;
input   [1:0]   select_i;
output  [31:0]  data_o;

assign data_o = (select_i == 2'b00) ? data00_i :
                (select_i == 2'b01) ? data01_i :
                (select_i == 2'b10) ? data10_i : data11_i;

endmodule

`endif
