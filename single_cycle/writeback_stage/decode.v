`include "define.v"

module decode (
    input wire  [ 3: 0]  icode_i,
    input wire  [63: 0]  rA_i,
    input wire  [63: 0]  rB_i,

    // wb_stage
    input wire           clk_i;
    input wire  [63: 0]  valM_i;
    input wire  [63: 0]  valE_i;

    // out
    output wire [63: 0]  valA_o,
    output wire [63: 0]  valB_o
);

// icode 决定 srcA 和 srcB
reg [3:0] srcA, srcB;
always @(*) 
begin 
    case (icode_i) 
        `IHALT : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;  
        end

        `INOP : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;
        end

        `ICMOVQ : 
        begin
            srcA = rA_i;
            srcB = rB_i;
        end

        `IIRMOVQ : 
        begin
            srcA = rA_i;
            srcB = rB_i;
        end

        `IRMMOVQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
        end

        `IMRMOVQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
        end

        `IOPQ :
        begin
            srcA = rA_i;
            srcB = rB_i;
        end

        `IJXX : 
        begin
            srcA = 4'hF;
            srcB = 4'hF;
        end

        `ICALL : 
        begin
            srcA = 4'hF;
            srcB = 4'h4;    // rsp = 4
        end

        `IRET :
        begin
            srcA = 4'h4;
            srcB = 4'h4;
        end

        `IPUSHQ :
        begin
            srcA = rA_i;
            srcB = 4'h4;
        end

        `IPOPQ :
        begin
            srcA = 4'h4;
            srcB = 4'h4;
        end

        default:
        begin
            srcA = 4'hF;
            srcB = 4'hF;
        end
    endcase       
end

// 获取寄存器文件中的数据
reg [63:0] regfile[14:0];

assign valA_o = (srcA == 4'hF) ? 64'b0 : regfile[srcA];
assign valB_o = (srcB == 4'hF) ? 64'b0 : regfile[srcB];

// writeback_stage

always @(posedge clk_i) begin
    
end

// 初始化寄存器文件
initial 
begin
    regfile[0]  = 64'd0;      //  编号为0的寄存器中，存放的数据为0
    regfile[1]  = 64'd1;    
    regfile[2]  = 64'd2;    
    regfile[3]  = 64'd3;    
    regfile[4]  = 64'd4;    
    regfile[5]  = 64'd5;    
    regfile[6]  = 64'd6;    
    regfile[7]  = 64'd7;    
    regfile[8]  = 64'd8;    
    regfile[9]  = 64'd9;    
    regfile[10] = 64'd10;    
    regfile[11] = 64'd11;    
    regfile[12] = 64'd12;    
    regfile[13] = 64'd13;    
    regfile[14] = 64'd14;    
end

endmodule