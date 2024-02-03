`include "define.v"
// module
module fetch (
    // input signal 
    input wire [63:0]  PC_i,     // 64位机器
    // output signal
    output wire [3:0]  icode_o,  // 指令功能字段
    output wire [3:0]  ifunc_o,  // 指令功字段-具体功能
    output wire [3:0]  rA_o,     // 寄存器A
    output wire [3:0]  rB_o,     // 寄存器B
    output wire [63:0] valC_o,   // 常数
    output wire [63:0] valP_o,   // 下一条指令的起始地址
    output wire        instr_valid_o,   // 指令是否有效
    output wire        imem_error_o     // 访存错误
);
    // 等价 reg[7:0] instr_mem[1023:0] ，都表示[0~1023]，名称为instr_mem的数组
    reg [7:0] instr_mem[0:1023];    // 指令存储器 1024 * 8 

    wire[79:0]  instr;              // 指令
    wire        need_regids;        // 指令中是否有寄存器字段
    wire        need_valC;          // 指令中是否有常数字段

    // 取指令地址是否有效
    assign imem_error_o = (PC_i > 1023);


    // 读取首条指令（方式少取，按照最长指令长度读取指令）
    // 逆序获取指令（立即数按照小端法存储，字节逆序方式，两次逆序可以获得正确的立即数）
    assign instr = {
        instr_mem[PC_i + 9], instr_mem[PC_i + 8], instr_mem[PC_i + 7],
        instr_mem[PC_i + 6], instr_mem[PC_i + 5], instr_mem[PC_i + 4],
        instr_mem[PC_i + 3], instr_mem[PC_i + 2], instr_mem[PC_i + 1],
        instr_mem[PC_i + 0]
    };

    // 指令寄存器初始化（小端法存储，字节逆序）
    initial 
    begin
        //main:
        // irmovq $0x0, %rax
        // 30_f0_00_00_00_00_00_00_00_00  
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 0
        // valC  = 0     valP  = a
        // valA  = 0     valB  = 0
        // valE_exe = 0  valM_mem = 0
        // valE_wb = 0    valM_wb = 0
        // npc = a
        instr_mem[0]=8'b00110000; //3 0
        instr_mem[1]=8'b00000000; //F rB=0
        instr_mem[2]=8'b00000000;           
        instr_mem[3]=8'b00000000;           
        instr_mem[4]=8'b00000000;           
        instr_mem[5]=8'b00000000;           
        instr_mem[6]=8'b00000000;           
        instr_mem[7]=8'b00000000;           
        instr_mem[8]=8'b00000000;          
        instr_mem[9]=8'b00000000; //V=0  valC = 0
        // irmovq $0x10, %rdx
        // 30_f2_10_00_00_00_00_00_00_00
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 2
        // valC  = 10     valP  = 14
        // valA  = 0     valB  = 2
        // valE_exe = 10  valM_mem = 0
        // valE_wb = 10    valM_wb = 0
        // npc = 14
        instr_mem[10]=8'b00110000; //3 0
        instr_mem[11]=8'b00000010; //F rB=2
        instr_mem[12]=8'b00010000;           
        instr_mem[13]=8'b00000000;           
        instr_mem[14]=8'b00000000;           
        instr_mem[15]=8'b00000000;           
        instr_mem[16]=8'b00000000;           
        instr_mem[17]=8'b00000000;           
        instr_mem[18]=8'b00000000;          
        instr_mem[19]=8'b00000000; //V=16

        //irmovq $0xc, %rbx
        // 30 f3 0c 00 00 00 00 00 00 00
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 3
        // valC  =      valP  = 
        // valA  =      valB  = 
        // valE_exe =   valM_mem = 
        // valE_wb =     valM_wb = 
        // npc = 
        instr_mem[20]=8'h30; //3 0
        instr_mem[21]=8'hf3; //F rB=3
        instr_mem[22]=8'h0c;            
        instr_mem[23]=8'h00;           
        instr_mem[24]=8'h00;           
        instr_mem[25]=8'h00;           
        instr_mem[26]=8'h00;           
        instr_mem[27]=8'h00;           
        instr_mem[28]=8'h00;          
        instr_mem[29]=8'h00; //V=12
        
        //jmp check
        // 70 27 00 00 00 00 00 00 00
        instr_mem[30]=8'h70; //7 fn
        instr_mem[31]=8'h27; //Dest
        instr_mem[32]=8'h00; //Dest
        instr_mem[33]=8'h00; //Dest
        instr_mem[34]=8'h00; //Dest
        instr_mem[35]=8'h00; //Dest
        instr_mem[36]=8'h00; //Dest
        instr_mem[37]=8'h00; //Dest
        instr_mem[38]=8'h00; //

        // check:
        // addq %rax, %rbx 
        // 6003
        instr_mem[39]=8'h60; //6 fn
        instr_mem[40]=8'h03; //rA=0 rB=3

        // je rbxres  
        // 737a00000000000000
        instr_mem[41]=8'h73; //7 fn=3
        instr_mem[42]=8'h7a; //Dest
        instr_mem[43]=8'h00; //Dest
        instr_mem[44]=8'h00; //Dest
        instr_mem[45]=8'h00; //Dest
        instr_mem[46]=8'h00; //Dest
        instr_mem[47]=8'h00; //Dest
        instr_mem[48]=8'h00; //Dest
        instr_mem[49]=8'h00; //
        // addq %rax, %rdx
        // 6002
        instr_mem[50]=8'h60; //6 fn
        instr_mem[51]=8'h02; //rA=0 rB=2
        // je rdxres 
        // 737d00000000000000 
        instr_mem[52]=8'h73; //7 fn=3
        instr_mem[53]=8'h7d; //Dest
        instr_mem[54]=8'h00; //Dest
        instr_mem[55]=8'h00; //Dest
        instr_mem[56]=8'h00; //Dest
        instr_mem[57]=8'h00; //Dest
        instr_mem[58]=8'h00; //Dest
        instr_mem[59]=8'h00; //Dest
        instr_mem[60]=8'h00; //Dest=125
        // jmp loop2 
        // 704600000000000000
        instr_mem[61]=8'h70; //7 fn=0
        instr_mem[62]=8'h46; //Dest
        instr_mem[63]=8'b00000000; //Dest
        instr_mem[64]=8'b00000000; //Dest
        instr_mem[65]=8'b00000000; //Dest
        instr_mem[66]=8'b00000000; //Dest
        instr_mem[67]=8'b00000000; //Dest
        instr_mem[68]=8'b00000000; //Dest
        instr_mem[69]=8'h00; //Dest

        // loop2:
        // rrmovq %rdx, %rsi 
        instr_mem[70]=8'b00100000; //2 fn=0
        instr_mem[71]=8'b00100110; //rA=2 rB=6
        // rrmovq %rbx, %rdi
        instr_mem[72]=8'b00100000; //2 fn=0
        instr_mem[73]=8'b00110111; //rA=3 rB=7
        // subq %rbx, %rsi
        instr_mem[74]=8'b01100001; //6 fn=1
        instr_mem[75]=8'b00110110; //rA=3 rB=6
        // jge ab1  
        instr_mem[76]=8'b01110001; //7 fn=5
        instr_mem[77]=8'h60; //Dest
        instr_mem[78]=8'b00000000; //Dest
        instr_mem[79]=8'b00000000; //Dest
        instr_mem[80]=8'b00000000; //Dest
        instr_mem[81]=8'b00000000; //Dest
        instr_mem[82]=8'b00000000; //Dest
        instr_mem[83]=8'b00000000; //Dest
        instr_mem[84]=8'h00; //Dest=96
        // subq %rdx, %rdi 
        instr_mem[85]=8'b01100001; //6 fn=1
        instr_mem[86]=8'b00100111; //rA=2 rB=7
        // jge ab2
        instr_mem[87]=8'b01110001; //7 fn=5
        instr_mem[88]=8'h6d; //Dest
        instr_mem[89]=8'b00000000; //Dest
        instr_mem[90]=8'b00000000; //Dest
        instr_mem[91]=8'b00000000; //Dest
        instr_mem[92]=8'b00000000; //Dest
        instr_mem[93]=8'b00000000; //Dest
        instr_mem[94]=8'b00000000; //Dest
        instr_mem[95]=8'h00; 

        // ab1:
        // rrmovq %rbx, %rdx
        instr_mem[96]=8'b00100000; //2 fn=0
        instr_mem[97]=8'b00110010; //rA=3 rB=2
        // rrmovq %rsi, %rbx
        instr_mem[98]=8'b00100000; //2 fn=0
        instr_mem[99]=8'b01100011; //rA=6 rB=3
        // jmp check
        instr_mem[100]=8'b01110000; //7 fn=0
        instr_mem[101]=8'h27; //Dest
        instr_mem[102]=8'b00000000; //Dest
        instr_mem[103]=8'b00000000; //Dest
        instr_mem[104]=8'b00000000; //Dest
        instr_mem[105]=8'b00000000; //Dest
        instr_mem[106]=8'b00000000; //Dest
        instr_mem[107]=8'b00000000; //Dest
        instr_mem[108]=8'h00; //Dest=39

        // ab2:
        // rrmovq %rbx, %rdx
        instr_mem[109]=8'b00100000; //2 fn=0
        instr_mem[110]=8'b00110010; //rA=3 rB=2
        // rrmovq %rdi, %rbx
        instr_mem[111]=8'b00100000; //2 fn=0
        instr_mem[112]=8'b01110011; //rA=7 rB=3
        // jmp check
        instr_mem[113]=8'b01110000; //7 fn=0
        instr_mem[114]=8'h27; //Dest
        instr_mem[115]=8'b00000000; //Dest
        instr_mem[116]=8'b00000000; //Dest
        instr_mem[117]=8'b00000000; //Dest
        instr_mem[118]=8'b00000000; //Dest
        instr_mem[119]=8'b00000000; //Dest
        instr_mem[120]=8'b00000000; //Dest
        instr_mem[121]=8'b00000000; //Dest=39

        // rbxres:
        // rrmovq %rdx, %rcx
        instr_mem[122]=8'b00100000; //2 fn=0
        instr_mem[123]=8'b00100001; //rA=2 rB=1
        // halt
        instr_mem[124]=8'b00000000;

        // rdxres:
        // rrmovq %rbx, %rcx
        instr_mem[125]=8'b00100000; //2 fn=0
        instr_mem[126]=8'b00110001; //rA=3 rB=1
        // halt
        instr_mem[127]=8'b00000000;

// ================================
        // // irmovq $0x8,  %r8
        // //  30_f8_08_00_00_00_00_00_00_00
        // instr_mem[0] = 8'h30;
        // instr_mem[1] = 8'hf8;
        // instr_mem[2] = 8'h08;
        // instr_mem[3] = 8'h00;
        // instr_mem[4] = 8'h00;
        // instr_mem[5] = 8'h00;
        // instr_mem[6] = 8'h00;
        // instr_mem[7] = 8'h00;
        // instr_mem[8] = 8'h00;
        // instr_mem[9] = 8'h00;

        // //  irmovq 0x21, %rbx
        // //  30_f3_15_00_00_00_00_00_00_00
        // instr_mem[10] = 8'h30;
        // instr_mem[11] = 8'hf3;
        // instr_mem[12] = 8'h15;
        // instr_mem[13] = 8'h00;
        // instr_mem[14] = 8'h00;
        // instr_mem[15] = 8'h00;
        // instr_mem[16] = 8'h00;
        // instr_mem[17] = 8'h00;
        // instr_mem[18] = 8'h00;
        // instr_mem[19] = 8'h00;

        // // xorq  %rax, %rax
        // //  63_00
        // instr_mem[20] = 8'h63;
        // instr_mem[21] = 8'h00;
        
        // // andq  %rsi, %rsi
        // // 62_66
        // instr_mem[22] = 8'h62;
        // instr_mem[23] = 8'h66;

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