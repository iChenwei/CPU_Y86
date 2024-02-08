`include "define.v"
//`include "regfile_pipe.v"
module decode_pipe(
    input wire clk_i,
    input wire  [ 3:0]  D_icode_i,
    input wire  [ 3:0]  D_ifunc_i,
    input wire  [ 3:0]  D_rA_i,
    input wire  [ 3:0]  D_rB_i,
    input wire  [63:0]  D_valC_i,

    output wire [ 3:0]  d_srcA_o,
    output wire [ 3:0]  d_srcB_o,
    output wire [63:0]  d_valA_o,
    output wire [63:0]  d_valB_o
);

assign d_srcA_o = (D_icode_i == `ICMOVQ  ||  D_icode_i == `IRMMOVQ || 
               D_icode_i == `IOPQ    ||  D_icode_i == `IPUSHQ) ? D_rA_i : 
              (D_icode_i == `IPOPQ   ||  D_icode_i == `IRET  ) ? `RRSP  : `RNONE;

assign d_srcB_o = (D_icode_i == `IOPQ || D_icode_i == `IRMMOVQ || D_icode_i == `IMRMOVQ) ? D_rB_i :
              (D_icode_i == `ICALL || D_icode_i == `IPUSHQ || D_icode_i == `IRET) ? `RRSP : `RNONE;

// 寄存器文件
reg [63:0] regfile[0:14];

assign d_valA_o = (d_srcA_o == 4'hF) ? 64'b0 : regfile[d_srcA_o];
assign d_valB_o = (d_srcB_o == 4'hF) ? 64'b0 : regfile[d_srcB_o];

initial begin
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