// 需要修改decode阶段
module writeback(
    input wire [ 3:0]  icode_i,
    input wire [63:0]  valE_i,
    input wire [63:0]  valM_i,

    input wire  instr_valid_i,
    input wire  imem_error_i,
    input wire  dmem_error_i,

    output wire [63:0]  valE_o,
    output wire [63:0]  valM_o,

    output wire [ 3:0]  stat_o
);

wire [63:0] valE_o, valM_o;
assign valE_o = valE_i;     // ALU的输出
assign valM_o = valM_i;     // Mem的输出

stat stat_module(
    .instr_valid_i(instr_valid_i),
    .imem_error_i(imem_error_i),
    .deme_error_i(deme_error_i),
    .stat_o(stat_o)
);
endmodule

module stat(
    input wire  instr_valid_i,
    input wire  imem_error_i,
    input wire  dmem_error_i
    output wire stat_o
);

endmodule