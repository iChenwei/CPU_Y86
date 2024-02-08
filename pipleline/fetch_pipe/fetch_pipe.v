`include "define.v"
`include "instruction_memory.v"

module fetch_pipe(
    // input 
    input wire   [63:0]  PC_i,
    // output 
    output wire  [ 3:0]  icode_o,
    output wire  [ 3:0]  ifunc_o,
    output wire  [ 3:0]  rA_o,
    output wire  [ 3:0]  rB_o,
    output wire  [63:0]  valC_o,
    output wire  [63:0]  valP_o,
    output wire  [63:0]  predPC_o,
    output wire  [ 2:0]  stat_o
);

wire [79:0]  instr;         // 指令
wire         imem_error;    // 访问指令寄存器错误，
wire         instr_valid;   // 指令为空

// 指令存储器
instruction_memory instr_mem(
    .raddr_i(PC_i),
    .instr_o(instr),
    .imem_error_o(imem_error)
);

// 指令分析 -- 获取指令类型字段 和 指令功能字段
assign icode_o = instr[7:4];
assign ifunc_o = instr[3:0];

//          -- 分析指令类型字段 == 判断当前指令是否具有 寄存器字段 和 常数字段
assign  need_regids  =  (icode_o == `ICMOVQ)  || (icode_o == `IIRMOVQ) || 
                        (icode_o == `IRMMOVQ) || (icode_o == `IMRMOVQ) || 
                        (icode_o == `IOPQ)    || (icode_o == `ICMOVQ)  ||
                        (icode_o == `IPUSHQ)  || (icode_o == `IPOPQ);
assign  need_valC    =  (icode_o == `IIRMOVQ) || (icode_o == `IRMMOVQ) || 
                        (icode_o == `IMRMOVQ) || (icode_o == `IJXX)    ||
                        (icode_o == `ICALL);

// 获取寄存器字段 15:8
assign rA_o = need_regids ? instr[15:12] : 4'HF;
assign rB_o = need_regids ? instr[11: 8] : 4'HF;

// 获取常数字段 79:16  71:8
assign valC_o = need_valC ? instr[79:16] : instr[71:8];

// 获取下一个指令地址字段
assign valP_o = 1 + need_regids + 8 * need_valC;

// assign stat_o = imem_error          ?  `SADR : 
//                 (!instr_valid)      ?  `SINS : 
//                 (icode_o == `IHALT) ?  `SHLT :
//                                        `SAOK ;

// 预测下一条指令的地址 -- 当前可预测的指令有限 == 除了jxx call直接给出地址字段valC，其他都是valP
assign predPC_o = (icode_o == `IJXX || icode_o == `ICALL) ? valC_o : valP_o ;
endmodule