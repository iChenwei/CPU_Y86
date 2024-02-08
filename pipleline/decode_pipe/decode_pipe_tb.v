`timescale 1ns/100ps
`include "define.v"
`include "decode_pipe.v"
`include "decode_E_pipe_reg.v"
// `include "regfile_pipe.v"

module decode_pipe_tb;

reg clk;

wire [63:0]  D_pc;
wire [ 3:0]  D_icode;
wire [ 3:0]  D_ifunc;
wire [ 3:0]  D_rA;
wire [ 3:0]  D_rB;
wire [63:0]  D_valC;
wire [63:0]  d_valA;
wire [63:0]  d_valB;
wire [ 3:0]  d_srcA;
wire [ 3:0]  d_srcB;


wire         E_stall;
wire         E_bubble;
wire [63:0]  E_pc;
wire [ 3:0]  E_icode;
wire [ 3:0]  E_ifunc;
wire [63:0]  E_valC;
wire [63:0]  E_valA;
wire [63:0]  E_valB;
wire [ 3:0]  E_srcA;
wire [ 3:0]  E_srcB;

decode_pipe  decode_stage(
    .D_icode_i(D_icode),
    .D_ifunc_i(D_ifunc),
    .D_rA_i(D_rA),
    .D_rB_i(D_rB),
    .D_valC_i(D_valC),

    .d_srcA_o(d_srcA),
    .d_srcB_o(d_srcB),
    .d_valA_o(d_valA),
    .d_valB_o(d_valB)
);

decode_E_pipe_reg ereg(
    .clk_i(clk),
    .E_stall_i(E_stall),
    .E_bubble_i(E_bubble),
    .d_pc_i(D_pc),
    .d_icode_i(D_icode),
    .d_ifunc_i(D_ifunc),
    .d_rA_i(D_rA),
    .d_rB_i(D_rB),
    .d_valC_i(D_valC),
    //.d_valP_i(),
    .d_valA_i(d_valA),
    .d_valB_i(d_valB),
    .d_srcA_i(d_srcA),
    .d_srcB_i(d_srcB),

    .E_pc_o(E_pc),
    .E_icode_o(E_icode),
    .E_ifunc_o(E_ifunc),
    .E_valC_o(E_valC),
    .E_valA_o(E_valA),
    .E_valB_o(E_valB),
    .E_srcA_o(E_srcA),
    .E_srcB_o(E_srcB)
);

initial begin
    clk = 0;
end

assign E_bubble = 0;
assign E_stall = 0;

assign D_pc = 0;

assign D_icode = 3;
assign D_ifunc = 0;
assign D_rA = 4'hF;
assign D_rB = 0;
assign D_valC = 0;

initial begin
    #1 clk = ~clk;
end

initial begin
    forever @(posedge clk) #1 begin
        $display(
          "D_PC=%d,  D_icode=%h,  D_ifunc=%h,  D_rA=%h, D_rB=%h,  D_valC=%h,  D_valA=%h,  \n",
          D_pc, D_icode, D_ifunc, D_rA, D_rB, D_valC, d_valA, d_valB, d_srcA, d_srcB
        );
        $display(
            "E_stall=%h,  E_bubble=%h\n",
            E_stall, E_bubble
        );

        $display(
          "E_PC=%d,  E_icode=%h,  E_ifunc=%h,  E_valA=%h,  E_valC=%h,  E_srcA=%h,  E_srcB=%h\n",
           E_pc, E_icode, E_ifunc, E_valA, E_valC, E_srcA, E_srcB
        );
    end
end
endmodule