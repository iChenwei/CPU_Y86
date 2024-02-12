`include "ram.v"
`include "define.v"

// access_memory
module memory_pipe(
    input wire clk_i,
    input wire [ 3:0]  M_icode_i, 
    input wire [63:0]  M_valE_i,    // addr
    input wire [63:0]  M_valA_i,    // data
    input wire [ 2:0]  M_stat_i,

    output wire[63:0]  m_valM_o,   // read data from ram
    output wire        m_dmem_error_o
);

reg m_r_en, m_w_re;
wire mm_dmem_error_o;

reg [63:0]  m_addr;
reg [63:0]  m_data;
// for -> read & wirte
always @(*) begin
    case (icode_i) 
        `INOP : begin
            m_r_en <= 1'b0;
            m_w_en <= 1'b0;         
        end

        `IHALT : begin  
            m_r_en <= 1'b0;
            m_w_en <= 1'b0;
        end
        
        // 寄存器 写 寄存器
        `ICMOVQ : begin  
            m_r_en <=  1'b0;
            m_w_en <=  1'b0;
        end

        // 寄存器 写入 内存
        `IRMMOVQ : begin
            m_r_en  <=  1'b0;
            m_w_en  <=  1'b1;
            m_addr  <=  M_valE_i;
            m_data  <=  M_valA_i;
        end

        // 立即数 写入 寄存器
        `IIRMOVQ : begin
            r_en <= 1'b0;
            w_en <= 1'b0;
        end

        // 读内存
        `IMRMOVQ : begin
            m_r_en    <=  1'b1;
            m_w_en    <=  1'b0;
            m_addr  <=  M_valE_i;
        end

        `IOPQ : begin
            m_r_en <= 1'b0;
            m_w_en <= 1'b0;
        end

        `IJXX : begin
            m_r_en <= 1'b0;
            m_w_en <= 1'b0;
        end

        `ICALL : begin
            m_r_en  <=  1'b0;
            m_w_en  <=  1'b1;
            m_addr  <=  M_valE_i;
            m_data  <=  M_valA_i;
        end

        `IRET : begin
            m_r_en  <=  1'b1;
            m_w_en  <=  1'b0;
            m_addr  <=  M_valA_i;
        end

        `IPUSHQ : begin
            m_r_en  <=  1'b0;
            m_w_en  <=  1'b1;
            m_addr  <=  M_valE_i;
            m_data  <=  M_valA_i;
        end

        `IPOPQ : begin
            m_r_en  <=  1'b1;
            m_w_en  <=  1'b0;
            m_addr  <=  M_valA_i;
        end
    endcase    
end
// access_ram
ram memory(
    .clk_i(clk_i),
    .m_r_en(m_r_en),
    .m_w_en(m_w_en),
    .m_addr_i(m_addr),
    .m_wdata_i(M_valA_i),
    .m_rdata_o(m_valM_o),
    .mm_dmem_error_o(mm_dmem_error_o)
);
endmodule