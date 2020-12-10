`ifndef PIPELINE_REGISTERS_V
`define PIPELINE_REGISTERS_V

module PipelineRegIFID (
    clk_i,
    rst_i,
    instr_i,
    instr_o,
);

input               clk_i;
input               rst_i;
input      [31:0]   instr_i;

output reg [31:0]   instr_o;

always@(posedge clk_i or posedge rst_i) begin
    if(rst_i) begin
        instr_o <= 32'b0;
    end
    else begin
        instr_o <= instr_i;
    end
end

endmodule

// module PipelineRegIDEX (
// );

// endmodule

// module PipelineRegEXMEM (
// );

// endmodule

// module PipelineRegMEMWB (
// );

// endmodule

`endif
