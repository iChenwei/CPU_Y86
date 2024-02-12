// 读写
module ram(
    input wire clk_i,
    
    // IO使能信号线
    input wire m_r_en,
    input wire m_w_en,

    input wire  [63:0]  m_addr_i,
    input wire  [63:0]  m_wdata_i,
    
    output wire [63:0]  m_rdata_o,
    output wire         mm_dmem_error_o
);

reg [7:0] mem[0:1023];
// 判断
assign dmeme_error_o = (m_addr_i > 1023);

// 读
assign m_rdata_o = (m_r_en == 1'b1) ? ({mem[m_addr_i + 7], mem[m_addr_i + 6],
                                       mem[m_addr_i + 5], mem[m_addr_i + 4],
                                       mem[m_addr_i + 3], mem[m_addr_i + 2],
                                       mem[m_addr_i + 1], mem[m_addr_i + 0]}) : 64'b0;
// 写
always @(posedge clk_i) begin
    if(m_w_en) begin
        {mem[m_addr_i + 7], mem[m_addr_i + 6], 
         mem[m_addr_i + 5], mem[m_addr_i + 4],
         mem[m_addr_i + 3], mem[m_addr_i + 2], 
         mem[m_addr_i + 1], mem[m_addr_i + 0]} <= m_wdata_i;
    end
end

// 存储单元 & 位宽
reg [7:0] mem[0:1023];

// 未来可以改成从txt文件中读取数据
initial begin
    mem[0]  =  8'H00;
    mem[1]  =  8'H01;
    mem[2]  =  8'H02;
    mem[3]  =  8'H03;
    mem[4]  =  8'H04;
    mem[5]  =  8'H05;
    mem[6]  =  8'H06;
    mem[7]  =  8'H07;
    mem[8]  =  8'H08;
    mem[9]  =  8'H09;
    mem[10] =  8'H0A;
    mem[11] =  8'H0B;
    mem[12] =  8'H0C;
    mem[13] =  8'H0D;
    mem[14] =  8'H0E;
    mem[15] =  8'H0F;
end

endmodule