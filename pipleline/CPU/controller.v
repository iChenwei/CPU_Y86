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

// 取指阶段
// 是否对F进行暂停
assign  F_stall_o = (((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) &&     
                      (E_dstE_i == d_srcA_i || E_dstM_i == d_srcB_i)) ||                   // 出现 load/use冒险 -- 触发条件
                    (D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET));      // ret指令 -- 触发条件

// 译码阶段
// 是否对D进行暂停
assign D_stall_o = (E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) &&      // load/use冒险 -- 触发条件
                   (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i);

// 是否对D插入气泡
assign D_bubble_o = ((E_icode_i == `IJXX) && (~e_Cnd_i)) ||                                     // 分支预测错误 -- 触发
                     (~((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                       (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i) &&                        // load/use冒险 -- 未触发
                       (D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET)));      // ret指令 -- 触发

// 执行阶段
// 是否对E插入气泡
assign E_bubble_o = (((E_icode_i == `IJXX) && (~e_Cnd_i)) ||                // 分支预测错误 -- 触发
                     ((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) &&     // 加载/使用冒险 -- 触发
                      (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i)));     

assign set_cc_o = ((E_icode_i == `IOPQ) &&                                            // 当前指令是算数指令（只有算数指令才会设置CC
                   (m_stat_i != `SADR && m_stat_i != `SINS && m_stat_i != `SHLT) &&   //  前面一条指令无异常
                   (W_stat_i != `SADR && W_stat_i != `SINS && W_stat_i != `SHLT));    //  前面第二条指令无异常

// 访存阶段
// 通过插入气泡解决指令异常
assign M_bubble_o = ((m_stat_i == `SADR || m_stat_i == `SINS || m_stat_i == `SHLT) |   
                     (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT));

// 写回阶段
// 通过暂停写回阶段解决异常
assign W_stall_o = (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT);

endmodule