`include "define.v"
`include "execute_M_pipe_reg.v"
`include "execute_pipe.v"

`timescale 1ns/100ps

module execute_pipe_tb;

reg clk;
reg rst_n;
// execute_stage signal
wire [ 2:0] E_stat;
wire [63:0] E_pc;
wire        [ 3:0]  E_icode;
wire        [ 3:0]  E_ifunc;
wire signed [63:0]  E_valA;
wire signed [63:0]  E_valB;
wire signed [63:0]  E_valC;
wire        [ 3:0]  E_dstE;
wire        [ 3:0]  E_dstM;
wire        [ 3:0]  E_srcA;
wire        [ 3:0]  E_srcB;
// wire     [ 2:0]  m_stat;
// wire     [ 2:0]  W_stat;

wire signed [63:0]  e_valE;
wire signed [ 3:0]  e_dstE;
wire                e_Cnd;


// M_reg signal
wire  M_stall;
wire  M_bubble;
wire [ 2:0]  M_stat;
wire [ 3:0]  M_pc;
wire [ 3:0]  M_icode;
wire [ 3:0]  M_ifunc;
wire [63:0]  M_valE;
wire [63:0]  M_valA;
wire [ 3:0]  M_dstE;
wire [ 3:0]  M_dstM;
wire         M_Cnd;

execute_pipe execute_stage(
    .clk_i(clk),
    .rst_n_i(rst_n),
    
    .icode_i(E_icode),
    .ifunc_i(E_ifunc),
    .E_dstE_i(E_dstE),
    .valA_i(E_valA),
    .valB_i(E_valB),
    .valC_i(E_valC),

    .valE_o(e_valE),
    .dstE_o(e_dstE),
    .e_Cnd_o(e_Cnd)
);

execute_M_pipe_reg mreg(
    .clk_i(clk),
    .M_stall_i(M_stall),
    .M_bubble_i(M_bubble),
    .e_stat_i(E_stat),
    .e_pc_i(E_pc),
    .e_icode_i(E_icode),
    .e_ifunc_i(E_ifunc),
    .e_Cnd_i(e_cnd),
    .e_valE_i(e_valE),
    .e_valA_i(E_valA),
    .e_dstE_i(e_dstE),
    .e_dstM_i(E_dstM),
    
    .M_stat_o(E_stat),
    .M_pc_o(M_pc),
    .M_icode_o(M_icode),
    .M_ifunc_o(M_ifunc),
    .M_Cnd_o(M_Cnd),
    .M_valE_o(M_valE),
    .M_valA_o(M_valA),
    .M_dstE_o(M_dstE),
    .M_dstM_o(M_dstM)
);

initial begin
    clk   = 0;
    rst_n = 1;
end

//Illegal output port connection to reg type.

assign M_bubble = 0;
assign M_stall  = 0;
assign E_stat = 3'b0;
assign E_pc = 0;

assign E_icode = 3;
assign E_ifunc = 0;
assign E_valA  = 0;
assign E_valC  = 64'd100;
assign E_dstE = 1;
assign E_dstM = 2;
assign E_srcA = 3;
assign E_srcB = 4;

initial begin
    #1 clk = ~clk;    
end

initial begin
    forever @(posedge clk) #1 begin
        $display(
            "M_stall=%h,  M_bubble=%h\n",
            M_stall, M_bubble
        );
        $display(
            "M_stat=%h,  M_pc=%h,  M_icode=%h,  M_Cnd=%h,  M_valE=%h,  M_valA=%h,  M_dstE=%h, M_dstM=%h \n",
            M_stat, M_pc, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM
        );
        // $display(


        // );

    end
end

initial begin
    #10  $stop;
end
endmodule