module execute (
    input wire clk_i,                 // 条件码寄存器CC，触发器实现的时钟
    input wire rst_n_i,               // 状态寄存器，信号0时成立的复位信号

    input wire [3:0] icode_i,        // 来自取指令阶段
    input wire [3:0] ifunc_i,          // 来自取指令阶段

    input wire signed[63:0]  valA_i,  // 来自译码取数阶段的寄存器文件regfile中，有符号数
    input wire signed[63:0]  valB_i,  // 来自译码取数阶段的寄存器文件regfile中，有符号数
    input wire signed[63:0]  valC_i,  // 来自取指令阶段的常数指令字段

    output reg signed[63:0]  valE_o,  // 执行阶段的输出，ALU的计算结果

    output wire Con_o                 //  执行阶段的输出，跳转判断
);

// 获取 ALU 的两个输入
reg [63:0] aluA, aluB;
always @(*) begin
    case (icode_i)
        
        `ICMOVQ : begin
            aluA = valA_i;
            aluB = 0;
        end

        `IIRMOVQ : begin
            aluA = valC_i;
            aluB = 0;
        end

        `IRMMOVQ : begin    
            aluA = valC_i;
            aluB = valB_i;
        end

        `IMRMOVQ : begin
            aluA = valC_i;
            aluB = valB_i;    
        end

        `IOPQ : begin
            aluA = valA_i;
            aluB = valB_i;            
        end

        `ICALL : begin
            aluA = -8;
            aluB = valB_i;
        end

        `IRET : begin
            aluA = 8;
        end

        `IPUSHQ : begin
            aluA = -8;
        end

        `IPOPQ : begin
            aluA = 8;
        end
        default : begin
            aluA = 0;
        end
    endcase
end

// ALU执行运算操作
reg [3:0] alu_fun;
always @(*) begin
    if (icode_i == `IOPQ) begin
        alu_fun = ifunc_i;
    end
    else begin
        alu_fun = `ALUADD;
    end
end

always @(*) begin
    case (alu_fun)
        `ALUADD : begin
            valE_o = aluA + aluB;
        end

        `ALUSUB : begin
            valE_o = aluB - aluA;
        end

        `ALUAND : begin
            valE_o = aluB & aluA;
        end

        `ALUXOR : begin
            valE_o = aluB ^ aluA;
        end
    endcase
end

// 条件码寄存器
reg [2:0] new_cc;
always @(*) begin
    if(~rst_n_i) begin
        new_cc[2] = 1;  // zf = 1;
        new_cc[1] = 0;
        new_cc[0] = 0;
    end
    else if (alu_fun == `FADDL) begin
        new_cc[2] = (valE_o == 0) ? 1 : 0;  // zf  零标志位
        new_cc[1] = valE_o[63];             // sf   符号标志位 -- 有符号数的最高位

        // of  溢出标志位 -- 加法溢出/减法溢出
        new_cc[0] = (alu_fun == `ALUADD) ? 
                    (aluA[63] == aluB[63]) && (aluA[63] != valE_o[63]) :   // 输入同号 且 符号不同于结果
                    (alu_fun == `ALUSUB) ?
                    (~aluA[63] == aluB[63]) && (aluA[63] != aluB[63]) : 0;  // 输入不同号 且 结果不同
    end
end

assign set_cc = (icode_i == `IOPQ) ? 1 : 0;

always @(posedge clk_i) begin
    if(~rst_n_i) 
        cc <= 3'b100;    // zf sf of
    else
        cc <= new_cc;
end

assign Cnd_o = 
    (ifunc_i == `C_YES) |
    (ifunc_i == `C_LE & ((sf ^ of) | zf)) |         // <= 
    (ifunc_i == `C_L  & (sf ^ of)) |                // <
    (ifunc_i == `C_E  & zf)  |                      // ==
    (ifunc_i == `C_NE & ~zf) |                      // !=
    (ifunc_i == `C_GE & ~(sf ^ of)) |               // >=
    (ifunc_i == `C_G  & (~(sf ^ of) & ~zf));        // >
endmodule

