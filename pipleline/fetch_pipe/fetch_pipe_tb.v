`include "define.v"
`include "fetch_pipe.v"
`include "fetch_D_pipe_reg.v"

`timescale 1ns/100ps

module fetch_pipe_tb;

// fetch stage signal
reg          clk;
wire [63:0]  f_PC;
wire [ 3:0]  f_icode;
wire [ 3:0]  f_ifunc;
wire [ 3:0]  f_rA;
wire [ 3:0]  f_rB;
wire [63:0]  f_valC;
wire [63:0]  f_valP;
wire [63:0]  f_predPC;
wire [ 2:0]  f_stat;

wire         D_stall;
wire         D_bubble;
wire [ 2:0]  D_stat;
wire [63:0]  D_PC;
wire [ 3:0]  D_icode;
wire [ 3:0]  D_ifunc;
wire [ 3:0]  D_rA;
wire [ 3:0]  D_rB;
wire [63:0]  D_valC;
wire [63:0]  D_valP;

// 引入 module
fetch_pipe  fetch(
    .PC_i(f_PC),
    .icode_o(f_icode),
    .ifunc_o(f_ifunc),
    .rA_o(f_rA),
    .rB_o(f_rB),
    .valC_o(f_valC),
    .valP_o(f_valP),
    .predPC_o(f_predPC),
    .stat_o(f_stat)
);

fetch_D_pipe_reg  dreg(
    .clk_i(clk),
    .D_stall_i(D_stall),
    .D_bubble_i(D_bubble),

    .f_stat_i(f_stat),
    .f_icode_i(f_icode),
    .f_pc_i(f_PC),
    .f_ifunc_i(f_ifunc),
    .f_rA_i(f_rA),
    .f_rB_i(f_rB),
    .f_valC_i(f_valC),
    .f_valP_i(f_valP),

    
    .D_stat_o(D_stat),
    .D_pc_o(D_PC),
    .D_icode_o(D_icode),
    .D_ifunc_o(D_ifunc),
    .D_rA_o(D_rA),
    .D_rB_o(D_rB),
    .D_valC_o(D_valC),
    .D_valP_o(D_valP)
);

// 初始化
assign  f_PC     = 0;
assign  D_stall  = 0;
assign  D_bubble = 0;

initial begin
    clk = 0;
end

always begin
    #5 clk = ~clk;
end

initial begin
    forever @(posedge clk) #2 begin
    $display(
        "f_PC=%d,  f_icode=%h,  f_ifunc=%h,  f_rA=%h, f_rB=%h,  f_valC=%h,  f_valP=%h,  f_predPC=%d  \n",
        f_PC, f_icode, f_ifunc, f_rA, f_rB, f_valC, f_valP, f_predPC
    );
    $display(
        "D_stall=%h,  D_bubble=%h\n",
        D_stall, D_bubble
    );

    $display(
        "D_PC=%d,  D_icode=%h,  D_ifunc=%h,  D_rA=%h, D_rB=%h,  D_valC=%h,  D_valP=%h \n",
        D_PC, D_icode, D_ifunc, D_rA, D_rB, D_valC, D_valP
    end
end

initial begin
    #20 $stop;
end
endmodule
