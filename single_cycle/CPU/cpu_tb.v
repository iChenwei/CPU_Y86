// timescale  时间单位/时间精度
// 时间单位 - time_unit
// 时间精度 - time_precision 
// 时间单位和时间精度只能是 1、10、100 ； s、ms、us、ps和fs；时间精度必须小于或等于时间单位
//  #10  ==> 10 * time_unit  
/* `timescale 10ns / 100ps
    1. 10ns，代表：仿真时间单位
        #10，代表：10*10ns = 100ns

    2. 100ps，代表：仿真时间精度
        #10.01，代表 10.01 * 10ns = 100.1ns = 100ns + 100ps

        #10.001，代表 10.001 * 10ns = 100.01ns 
                由于 0.01ns = 10ps而精度是100ps，那么10ps由于【精度不够】表示不出来，四舍五入被舍弃，所以100.01ns = 100ns
*/
`timescale 1ns/1ps

`include "define.v"
`include "decode_wb.v"
`include "fetch.v"
`include "execute.v"
`include "memory.v"
`include "writeback.v"
`include "updatePC.v"

// reg  激励信号
// wire 待观察的信号
module cpu_tb ();

reg           clk;
reg           rst_n;
wire          cnd;
reg   [63:0]  PC;            // instr_addr
wire  [63:0]  npc;           // new_instr_addr
wire  [ 3:0]  icode;         // instr_no
wire  [ 3:0]  ifunc;         // instr_func
wire  [63:0]  valC;          // instr_const
wire  [63:0]  valP;          // instr_next_addr

wire  [ 3:0]  rA;            // regfile_no
wire  [ 3:0]  rB;            // regfile_no
wire  [63:0]  valA;          // regfile[rA]
wire  [63:0]  valB;          // regfile[rB]

wire  [63:0]  valE_exe;      // alu -> memory_access_address
wire  [63:0]  valM_mem;      // memory_access_data
wire  [63:0]  valE_wb;       // memory_wb_data
wire  [63:0]  valM_wb;       // memory_wb_data

wire  [ 3:0]  stat;
wire          instr_valid;
wire          imem_error;
wire          dmem_error;

// 取指令阶段 -- 更新fetch.v 中 instr_mem[]
fetch fetch_stage(
    // input
    .PC_i(PC),
    // output
    .icode_o(icode),
    .ifunc_o(ifunc),
    .rA_o(rA),
    .rB_o(rB),
    .valC_o(valC),
    .valP_o(valP),
    .instr_valid_o(instr_valid),
    .imem_error_o(imem_error)
);

// 译码（取数）阶段
decode_wb decode_wb_stage(
    .clk_i(clk),
    .icode_i(icode),
    .rA_i(rA),
    .rB_i(rB),
    .valM_i(valM_wb),
    .valE_i(valE_wb),
    .valA_o(valA),
    .valB_o(valB)
);

// 执行阶段
execute execute_stage(
    .clk_i(clk),
    .rst_n_i(rst_n),
    .icode_i(icode),
    .ifunc_i(ifunc),
    .valA_i(valA),
    .valB_i(valB),
    .valC_i(valC),
    .valE_o(valE_exe),
    .Cnd_o(cnd)
);

// 访存阶段
memory memorry_stage(
    .clk_i(clk),
    .icode_i(icode),
    .valE_i(valE_exe),
    .valA_i(valA),
    .valP_i(valP),
    .valM_o(valM_mem),
    .dmem_error_o(dmem_error)
);

// 写回阶段
writeback writeback_stage(
    .icode_i(icode),
    .valE_i(valE_exe),
    .valM_i(valM_mem),
    .instr_valid_i(instr_valid),
    .imem_error_i(imem_error),
    .dmem_error_i(dmem_error),
    .valE_o(valE_wb),
    .valM_o(valM_wb),
    .stat_o(stat)
);

// 更新PC阶段
updatePC updatePC_stage(
    .icode_i(icode),
    .cnd_i(cnd),
    .valC_i(valC),
    .valM_i(valM_wb),
    .valP_i(valP),
    .PC_o(npc)
);

// 数据初始化（只执行一次）
initial begin
    clk   = 0;
    PC    = 0;
    rst_n = 1;
end

always begin
    #20 clk = ~clk;
end

initial 
    forever @(posedge clk) #2 PC = npc;

initial begin
    forever @(posedge clk) #3 begin
    $display(
        "PC=%d\t, icode=%h\t, ifunc=%h\t, rA=%h\t, rB=%h\t, valC=%h\t, valP=%h\n 
         valA=%h\t, valB=%h\t, valE_exe=%h\t, valM_mem=%h\t, valE_wb=%h\t, valM_wb=%h\t, npc=%h\n",
        PC, icode, ifunc, rA, rB, valC, valP, 
        valA, valB, valE_exe, valM_mem, 
        valE_wb, valM_wb, npc
    );
    end
end

initial begin
    #500 $stop;
end

endmodule
