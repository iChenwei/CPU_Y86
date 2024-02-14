`include "define.v"
/*
    设计目的：valA 和 valP 合并
*/
module sel_fwd(
    input wire [ 3:0] D_icode_i,
    input wire [63:0] D_valP_i,
    input wire [63:0] d_rvalA_i,
    input wire [ 3:0] d_srcA_i,

    input wire [63:0] W_valE_i,
    input wire [ 3:0] W_dstE_i,
    input wire [63:0] W_valM_i,
    input wire [ 3:0] W_dstM_i,
    
    input wire [63:0] m_valM_i,
    input wire [ 3:0] M_dstM_i,
    
    input wire [63:0] e_valE_i,
    input wire [ 3:0] e_dstE_i,

    output wire [63:0] fwdA_valA_o
);

// 优先级（隐含）
assign fwdA_valA_o = ((D_icode_i == `ICALL || D_icode_i == `IJXX) ? D_valP_i :
                      (d_srcA_i == e_dstE_i) ? e_valE_i :
                      (d_srcA_i == M_dstM_i) ? m_valM_i :
                      (d_srcA_i == W_dstM_i) ? M_valE_i :
                      (d_srcA_i == W_dstE_i) ? W_valE_i : d_rvalA_i);

endmodule