`ifndef SIGN_EXTEND_V
`define SIGN_EXTEND_V

module Sign_Extend (data_i, data_o);

input   [11:0] data_i;
output  [31:0] data_o;

assign data_o[11:0] = data_i;
assign data_o[31:12] = {20{data_i[11]}};

endmodule

`endif
