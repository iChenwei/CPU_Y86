`include "define.v"

module controller(
    input wire [ 3:0] D_icode_i,
    input wire [ 3:0] d_srcA_i,
    input wire [ 3:0] d_srcB_i,
    
    input wire [ 3:0] E_icode_i,
    input wire [ 3:0] E_dstE_i,
    input wire        e_Cnd_i,
    
    input wire [ 3:0] M_icode_i,
    input wire [ 2:0] m_stat_i,

    input wire [ 2:0] W_stat_i,

    output wire F_stall_o,
    output wire D_bubble_o,
    output wire D_stall_o,
    output wire E_bubble_o,
    output wire set_cc_o,
    output wire M_bubble_o,
    output wire W_stall_o
);
// load/use hazard  
// ret
assign  F_stall_o = (((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                      (E_dstE_i == d_srcA_i || E_dstM_i == d_srcB_i)) || 
                    (D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET));
// load/use hazard
assign D_stall_o = (E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                   (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i);

assign D_bubble_o = ((E_icode_i == `IJXX) && (~e_Cnd_i)) || 
                     (~((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                       (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i) && 
                       (D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET)));

assign E_bubble_o = (((E_icode_i == `IJXX) && (~e_Cnd_i)) || 
                     ((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                      (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i)));

assign M_bubble_o = ((m_stat_i == `SADR || m_stat_i == `SINS || m_stat_i == `SHLT) | 
                     (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT));

assign W_stall_o = (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT);

endmodule