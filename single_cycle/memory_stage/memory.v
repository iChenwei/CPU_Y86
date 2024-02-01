`include "define.v"

// 访存_阶段（大模块）
module memory (
    input wire         clk_i,   // 时钟信号，时序逻辑，用于内存“写”（“读”可以保留）
    
    input wire  [ 3:0] icode_i,  // 实现读写控制      
    
    input wire  [63:0] valE_i,   // 地址信号，alu --> valE 
    
    input wire  [63:0] valA_i,   // 写数据，write data --> memory
    input wire  [63:0] valP_i,   // call、push等指令使用

    output wire [63:0] valM_o,   // 读出数据，read data from memory -> data

    output wire  dmem_error_o   // 访存错误信息提示（调试）
);
    
reg r_en;               // 读使能信号
reg w_en;               // 写使能信号
reg [63:0] mem_addr;    // 内存地址信号 
reg [63:0] mem_data;    // 内存数据信号
// 非阻塞赋值 <=（并行 -- 几个操作需要的数据同时进行）
// 根据指令决定对内存的操作
always @(*) begin
    case (icode_i) 
        `INOP : begin
            r_en <= 1'b0;
            w_en <= 1'b0;         
        end

        `IHALT : begin  
            r_en <= 1'b0;
            w_en <= 1'b0;
        end
        
        // 寄存器 写 寄存器
        `ICMOVQ : begin  
            r_en <=  1'b0;
            w_en <=  1'b0;
        end

        // 寄存器 写入 内存
        `IRMMOVQ : begin
            r_en      <=  1'b0;
            w_en      <=  1'b1;
            mem_addr  <=  valE_i;
            mem_data  <=  valA_i;
        end

        // 立即数 写入 寄存器
        `IIRMOVQ : begin
            r_en <= 1'b0;
            w_en <= 1'b0;
        end

        // 读内存
        `IMRMOVQ : begin
            r_en      <=  1'b1;
            w_en      <=  1'b0;
            mem_addr  <=  valE_i;
        end

        `IOPQ : begin
            r_en <= 1'b0;
            w_en <= 1'b0;
        end

        `IJXX : begin
            r_en <= 1'b0;
            w_en <= 1'b0;
        end

        `ICALL : begin
            r_en      <=  1'b0;
            w_en      <=  1'b1;
            mem_addr  <=  valE_i;
            mem_data  <=  valP_i;
        end

        `IRET : begin
            r_en      <=  1'b1;
            w_en      <=  1'b0;
            mem_addr  <=  valA_i;
        end

        `IPUSHQ : begin
            r_en      <=  1'b0;
            w_en      <=  1'b1;
            mem_addr  <=  valE_i;
            mem_data  <=  valA_i;
        end

        `IPOPQ : begin
            r_en      <=  1'b1;
            w_en      <=  1'b0;
            mem_addr  <=  valA_i;
        end
    endcase    
end

ram mem(
    .clk_i(clk_i),
    .r_en(r_en),
    .w_en(w_en),
    .addr_i(mem_addr),
    .wdata_i(mem_data),
    .rdata_o(valM_o),
    .dmem_error_o(dmem_error_o)
);

endmodule


// 内存模块（子模块）
module ram(
    input wire          clk_i,   // 时序逻辑

    input wire          r_en,
    input wire          w_en,
    input wire  [63:0]  addr_i,
    input wire  [63:0]  wdata_i,

    output wire [63:0]  rdata_o,
    output wire dmem_error_o
);

// 内存 8 * 1024 ==> 1024个存储单元，每个存储单元存放1个字节的内容
reg [7:0] mem[0:1023];

assign dmem_error_o = (addr_i > 1023) ? 1 : 0;

// 读数据 -- 一次读取64位数据 / 8个字节数据
assign rdata_o = (r_en == 1'b1) ? ({mem[addr_i + 7], mem[addr_i + 6],
                                    mem[addr_i + 5], mem[addr_i + 4],
                                    mem[addr_i + 3], mem[addr_i + 2],
                                    mem[addr_i + 1], mem[addr_i + 0]}) : 64'b0;

// 写数据 -- 一次写入64位数据 / 8个字节数据
always @(posedge clk_i) begin
    if(w_en) begin
        {mem[addr_i + 7], mem[addr_i + 6],
         mem[addr_i + 5], mem[addr_i + 4],
         mem[addr_i + 3], mem[addr_i + 2], 
         mem[addr_i + 1], mem[addr_i + 0]} <= wdata_i;
    end
end

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