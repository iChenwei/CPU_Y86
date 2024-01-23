`include "define.v"
// icode
`define    IHALT        4'H0
`define    INOP         4'H1
`define    ICMOVQ       4'H2
`define    IIRMOVQ      4'H3
`define    IRMMOVQ      4'H4
`define    IMRMOVQ      4'H5
`define    IOPQ         4'H6
`define    IJXX         4'H7
`define    ICALL        4'H8
`define    IRET         4'H9
`define    IPUSHQ       4'HA
`define    IPOPQ        4'HB

// ifunc
`define    FADDL        4'H0
`define    FSUBL        4'H1
`define    FANDL        4'H2
`define    FXORL        4'H3

// module
module fetch (
    // input signal 
    input wire [63:0]  PC_i, // 64位机器
    // output signal
    output wire [3:0]  icode_o, // 指令功能字段
    output wire [3:0]  ifunc_o,  // 指令功字段-具体功能
    output wire [3:0]  rA_o,    // 寄存器A
    output wire [3:0]  rB_o,     // 寄存器B
    output wire [63:0] valC_o,  // 常数
    output wire [63:0] valP_o,  // 下一条指令的起始地址
    output wire        instr_valid_o,   // 指令是否有效
    output wire        imem_error_o     // 访存错误
);
    
    reg [7:0] instr_mem[0:1023];    // 指令存储器 1024 * 8

    wire[79:0]  instr;              // 指令
    wire        need_regids;        // 指令中是否有寄存器字段
    wire        need_valC;          // 指令中是否有常数字段

    // 取指令地址是否有效
    assign imem_error_o = (PC_i > 1023);

    // 逆序获取指令（立即数按照小端法存储，字节逆序方式，两次逆序可以获得正确的立即数）
    assign instr = {
        instr_mem[PC_i + 9], instr_mem[PC_i + 8], instr_mem[PC_i + 7],
        instr_mem[PC_i + 6], instr_mem[PC_i + 5], instr_mem[PC_i + 4],
        instr_mem[PC_i + 3], instr_mem[PC_i + 2], instr_mem[PC_i + 1],
        instr_mem[PC_i + 0]
    };

    // 指令寄存器初始化
    initial 
    begin
        // irmovq $0x8,  %r8
        //  30_f8_08_00_00_00_00_00_00_00
        instr_mem[0] = 8'h30;
        instr_mem[1] = 8'hf8;
        instr_mem[2] = 8'h08;
        instr_mem[3] = 8'h00;
        instr_mem[4] = 8'h00;
        instr_mem[5] = 8'h00;
        instr_mem[6] = 8'h00;
        instr_mem[7] = 8'h00;
        instr_mem[8] = 8'h00;
        instr_mem[9] = 8'h00;

        //  irmovq 0x21, %rbx
        //  30_f3_15_00_00_00_00_00_00_00
        instr_mem[10] = 8'h30;
        instr_mem[11] = 8'hf3;
        instr_mem[12] = 8'h15;
        instr_mem[13] = 8'h00;
        instr_mem[14] = 8'h00;
        instr_mem[15] = 8'h00;
        instr_mem[16] = 8'h00;
        instr_mem[17] = 8'h00;
        instr_mem[18] = 8'h00;
        instr_mem[19] = 8'h00;
    end


    // 指令操作码op字段分割
    assign icode_o = instr[7:4];
    assign ifunc_o = instr[3:0];

    // 指令有效检查（通过icode进行判断）
    assign instr_valid_o = (icode_o < 4'hC);

    // 该条指令是否存在寄存器字段（利用icode进行判断）
    assign need_regids = (icode_o == `ICMOVQ)  || (icode_o == `IIRMOVQ) || 
                         (icode_o == `IRMMOVQ) || (icode_o == `IMRMOVQ) ||
                         (icode_o == `IOPQ)    || (icode_o == `IPUSHQ)  ||
                         (icode_o == `IPOPQ); 

    // 该条指令中是否存在常数字段（利用icode进行判断）
    assign need_valC = (icode_o == `IIRMOVQ) || (icode_o == `IRMMOVQ) ||
                       (icode_o == `IRMMOVQ) || (icode_o == `IJXX)    ||
                       (icode_o == `ICALL);

    // 两个寄存器输出，若存在各占4位，共占1个字节
    assign rA_o = need_regids  ?  instr[15:12] : 4'HF;
    assign rB_o = need_regids  ?  instr[11: 8] : 4'HF;

    // 常数部分
    assign valC_o = need_regids  ?  instr[79:16] : instr[71:8];

    // 计算下一条指令的地址
    assign valP_o = PC_i + 1 + 8 * need_valC + need_regids;
endmodule