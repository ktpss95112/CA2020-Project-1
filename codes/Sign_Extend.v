`ifndef SIGN_EXTEND_V
`define SIGN_EXTEND_V

`include "const.v"

module Sign_Extend (
    data_i,
    data_o
);

input       [31:0]  data_i;
output reg  [31:0]  data_o;


always @(data_i) begin
    case (data_i[6:0])
        `OPCODE_I_TYPE,
        `OPCODE_LOAD: begin
            data_o[11:0]    <= data_i[31:20];
            data_o[31:12]   <= {20{data_i[31]}};
        end

        `OPCODE_STORE: begin
            data_o[11:0]    <= {data_i[31:25], data_i[11:7]};
            data_o[31:12]   <= {20{data_i[31]}};
        end

        `OPCODE_BRANCH: begin
            data_o[11:0]    <= {data_i[31], data_i[7], data_i[30:25], data_i[11:8]};
            data_o[31:12]   <= {20{data_i[31]}};
        end

        default: begin
            data_o[11:0]    <= 0;
        end
    endcase
end

endmodule

`endif
