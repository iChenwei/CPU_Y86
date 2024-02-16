`include "define.v"

module fwd(
    // in
    input wire [63:0] d_rvalB_i,
    input wire [ 3:0] d_srcB_i,

    input wire [63:0] W_valE_i,
    input wire [ 3:0] W_dstE_i,
    input wire [63:0] W_valM_i,
    input wire [ 3:0] W_dstM_i,

    input wire [63:0] m_valM_i,
    input wire [ 3:0] M_dstM_i,
    input wire [63:0] M_valE_i,
    input wire [ 3:0] M_dstE_i,

    input wire [63:0] e_valE_i,
    input wire [ 3:0] e_dstE_i,

    // out
    output wire [63:0] fwdB_valB_o
);

assign fwdB_valB_o = (d_srcB_i == e_dstE_i) ? e_valE_i :
                     (d_srcB_i == M_dstM_i) ? m_valM_i :
                     (d_srcB_i == M_dstE_i) ? M_valE_i : 
                     (d_srcB_i == W_dstM_i) ? W_valM_i : 
                     (d_srcB_i == W_dstE_i) ? W_valE_i : d_rvalB_i;

endmodule