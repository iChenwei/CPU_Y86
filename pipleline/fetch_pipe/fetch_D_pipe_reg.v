`include "define.v"
// 利用D触发器实现fetch_stage —— decode_stage之间的寄存器
module fetch_D_pipe_reg(
    input wire  clk_i,

    input wire  D_stall_i,       //  流水线阻塞
    input wire  D_bubble_i,       //  插入气泡

    input wire [ 2:0]  f_stat_i,
    input wire [63:0]  f_pc_i,
    input wire [ 3:0]  f_icode_i,
    input wire [ 3:0]  f_ifunc_i,
    input wire [ 3:0]  f_rA_i,
    input wire [ 3:0]  f_rB_i,
    input wire [63:0]  f_valC_i,
    input wire [63:0]  f_valP_i,

    output reg [ 2:0]  D_stat_o,
    output reg [63:0]  D_pc_o,
    output reg [ 3:0]  D_icode_o,
    output reg [ 3:0]  D_ifunc_o,
    output reg [ 3:0]  D_rA_o,
    output reg [ 3:0]  D_rB_o,
    output reg [63:0]  D_valC_o,
    output reg [63:0]  D_valP_o
);

// 触发器
always @(posedge clk_i) begin
    if(D_bubble_i) begin // 插入气泡
        D_stat_o  <=  3'h0;
        D_pc_o    <=  64'b0;
        D_icode_o <=  `INOP;
        D_ifunc_o <=  4'b0;
        D_rA_o    <=  `RNONE;
        D_rB_o    <=  `RNONE;
        D_valC_o  <=  64'b0;
        D_valP_o  <=  64'b0;
    end
    else if (~D_stall_i) begin  // 非阻塞_正常触发
        D_stat_o  <=  f_stat_i;
        D_pc_o    <=  f_pc_i;
        D_icode_o <=  f_icode_i;
        D_ifunc_o <=  f_ifunc_i;
        D_rA_o    <=  f_rA_i;
        D_rB_o    <=  f_rB_i;
        D_valC_o  <=  f_valC_i;
        D_valP_o  <=  f_valP_i;
    end
end
endmodule