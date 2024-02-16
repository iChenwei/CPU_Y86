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
/*
- valP和valA合并，根据指令的不同，从而选择 valA 还是 valP
- d_srcA_i ： 译码阶段，读寄存器的寄存器id
- e_dstE_i ： 执行阶段ALU计算结果valE，将要写入的目的寄存器id
    -- d_srcA_i == e_dstE_i 时，译码阶段将要读取的寄存器id，和写回ALU计算结果对应的寄存器id相同 ==> 发生数据相关冒险
        将ALU计算结果valE进行前递即可
*/

/*
优先级： 
    - 执行阶段 >> 访存阶段 >> 写回阶段 （阶段越靠前）   
    - 同一个时钟得到的结果 >> 下一个时钟得到的结果 （时钟越靠前）
    ==>  e_valE >> m_valM  （执行阶段 >> 访存阶段  && 同一个始终周期得到的结果）
    ==>  M_valE >> W_valM  （不同阶段，同一个时钟）
    ==>  W_valE （不同时钟，下一个时钟，依赖M_valE）
    ==>  e_valE >> m_valM >> M_valE >> W_valM >> W_valE

*/
assign fwdA_valA_o = ((D_icode_i == `ICALL || D_icode_i == `IJXX) ? D_valP_i :
                      (d_srcA_i == e_dstE_i) ? e_valE_i :
                      (d_srcA_i == M_dstM_i) ? m_valM_i :
                      (d_srcA_i == M_dstE_i) ? M_valE_i : 
                      (d_srcA_i == W_dstM_i) ? W_valM_i :
                      (d_srcA_i == W_dstE_i) ? W_valE_i : d_rvalA_i);
endmodule