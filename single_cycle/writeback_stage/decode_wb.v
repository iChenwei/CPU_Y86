// 重构decode
`include "define.v"
module decode_wb (

    input wire          clk_i;       //  时钟信号
    input wire          cnd;         //  状态码
    input wire  [ 3:0]  icode_i;     //  指令功能码
    input wire  [63:0]  rA_i;        //  rA寄存器编号
    input wire  [63:0]  rB_i;        //  rB寄存器编号

    input wire  [63:0]  valM_i;      //  从内存中读出的内容
    input wire  [63:0]  valE_i;      //  ALU计算结果

    output wire [63:0]  valA_o;      //  从寄存器文件中读取内容
    output wire [63:0]  valB_o;      //  从寄存器文件中读取内容
);

reg [63:0] regfile[14:0];  // 15个寄存器

// decode_stage
reg [3:0] srcA, srcB;       // 读 寄存器文件的地址
reg [3:0] dstE, dstM;       // 写 寄存器文件的地址
always @(*) begin
    case (icode_i) 
        `IHALT : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;  
        end

        `INOP : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end

        `ICMOVQ : 
        begin
            srcA = rA_i;
            srcB = rB_i;
            dstE = rB_i;
            dstM = 4'hF;
        end

        `IIRMOVQ : 
        begin
            srcA = rA_i;
            srcB = rB_i;
            dstE = rB_i;
            dstM = 4'hF;
        end

        `IRMMOVQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
            dstE = 4'hF;
            dstM = 4'hF;
        end

        `IMRMOVQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
            dstE = 4'hF;
            dstM = rA_i;
        end

        `IOPQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
            dstE = rB_i;
            dstM = 4'hF;
        end

        `IJXX : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end

        `ICALL : 
        begin
            srcA = 4'hF;
            srcB = 4'h4;    // rsp = 4
            dstE = 4'h4;
            dstM = 4'hF;
        end

        `IRET :
        begin
            srcA = 4'h4;
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = 4'hF;
        end

        `IPUSHQ :
        begin
            srcA = rA_i;
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = 4'hF;
        end

        `IPOPQ :
        begin
            srcA = 4'h4;
            srcB = 4'h4;
            dstE = 4'h4;
            dstM = rA_i;
        end

        default:
        begin
            srcA = 4'hF;
            srcB = 4'hF;
            dstE = 4'hF;
            dstM = 4'hF;
        end
    endcase       
end

assign valA_o = (srcA == 4'HF) ? 64'b0 : regfile[srcA];
assign valB_o = (srcB == 4'HF) ? 64'b0 : regfile[srcB];

// writeback_stage
always @(posedge clk_i) begin
    case(icode_i)
        `ICMOVQ : begin
            regfile[dstE] <= valE_i;
        end
        
        `IIRMOVQ : begin
            regfile[dstE] <= valE_i;
        end

        `IRMMOVQ : begin
            regfile[dstE] <= valE_i;
        end

        `IMRMOVQ : begin
            regfile[dstM] <= valM_i;
        end

        `IOPQ : begin
            regfile[dstE] <= valE_i;
        end 

        `ICALL : begin
            regfile[dstE] <= valE_i;
        end

        `IRET : begin
            regfile[dstE] <= valE_i;
        end 

        `IPUSHQ : begin
            regfile[dstE] <=  valE_i;
        end

        `IPOPQ : begin
            regfile[dstE] <= valE_i;
            regfile[dstM] <= valM_i;
        end
    endcase
end

endmodule