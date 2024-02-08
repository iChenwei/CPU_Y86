module regfile_pipe (
    input wire  [ 3:0]  d_srcA_i,
    input wire  [ 3:0]  d_srcB_i,

    output wire [63:0]  d_valA_o,
    output wire [63:0]  d_valB_o
);
 
reg [63:0] regfile[0:14];

assign d_valA_o = (d_srcA_i == 4'hF) ? 64'b0 : regfile[d_srcA_i];
assign d_valB_o = (d_srcB_i == 4'hF) ? 64'b0 : regfile[d_srcB_i];

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