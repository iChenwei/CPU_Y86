`include "define.v"

module execute_pipe(
    input wire  clk_i,
    input wire  rst_n_i,
    input wire [3:0]  icode_i,
    input wire [3:0]  ifunc_i,
    input wire [3:0]  E_dstE_i,

    input wire signed [63:0]  valA_i,
    input wire signed [63:0]  valB_i,
    input wire signed [63:0]  valC_i,

    // input wire        [ 2:0]  m_stat_i,
    // input wire        [ 2:0]  W_stat_i,

    output wire signed [63:0]  valE_o,
    output wire signed [ 3:0]  dstE_o,
    output wire                e_Cnd_o
);

// 操作数 和 运算符的确定
wire [63:0]  aluA, aluB;
wire [ 3:0]  alu_fun;

// 确定操作数
assign aluA = (icode_i == `IRRMOVQ || icode_i == `IOPQ)    ? valA_i :  
              (icode_i == `IIRMOVQ || icode_i == `IRMMOVQ) ? valC_i : 
              (icode_i == `ICALL   || icode_i == `IPUSHQ)  ? -8     : 
              (icode_i == `IRET    || icode_i == `IPOPQ)   ? 8      :  0;

assign aluB = (icode_i == `IRMMOVQ || icode_i == `IMRMOVQ || 
               icode_i == `IOPQ    || icode_i == `ICALL   || 
               icode_i == `IPUSHQ  || icode_i == `IRET    || 
               icode_i == `IPOPQ)  ?  valB_i : 
              (icode_i == `IRRMOVQ || icode_i == `IIRMOVQ) ? 0 : 0;

assign alu_fun = (icode_i == `IOPQ) ? ifunc_i : `ALUADD;  // 确定运算符

// 条件码寄存器
reg [ 2:0]  new_cc;   // zf sf of

always @(*) begin
    if(~rst_n_i) begin
        new_cc[2] = 1;  // zf = 1
        new_cc[1] = 0;  // sf
        new_cc[0] = 0;  // of
    end
    else if(alu_fun == `FADDL) begin
        new_cc[2] = (valE_o == 0) ? 1 : 0;   // zf  零标志位
        new_cc[1] = valE_o[63];              // sf  符号标志位  -- 有符号数的最高位
        // of  溢出标志位 -- 加法溢出/减法溢出
        new_cc[0] = (alu_fun == `ALUADD) ? 
                    (aluA[63] == aluB[63]) && (aluA[63] != valE_o[63]) :   // 输入同号 且 符号不同于结果
                    (alu_fun == `ALUSUB) ?
                    (~aluA[63] == aluB[63]) && (aluB[63] != valE_o[63]) : 0;  // 输入不同号 且 结果不同
    end
end

wire   set_cc;
assign set_cc = (icode_i == `IOPQ) ? 1 : 0;

// 条件码寄存器
reg [2:0] cc;       
always @(posedge clk_i) begin   // 由于需要存储数据，所以用时序逻辑来实现
    if(~rst_n_i)                // 复位
        cc <= 3'b100;       
    else if(set_cc)             // 设置
        cc <= new_cc;
end

wire zf, sf, of;
assign zf = cc[2];
assign sf = cc[1];
assign of = cc[0];
assign e_Cnd_o = 
    (ifunc_i == `C_YES) |
    (ifunc_i == `C_LE & ((sf ^ of) | zf)) |         // <= 
    (ifunc_i == `C_L  & (sf ^ of)) |                // <
    (ifunc_i == `C_E  & zf)  |                      // ==
    (ifunc_i == `C_NE & ~zf) |                      // !=
    (ifunc_i == `C_GE & ~(sf ^ of)) |               // >=
    (ifunc_i == `C_G  & (~(sf ^ of) & ~zf));        // >
endmodule