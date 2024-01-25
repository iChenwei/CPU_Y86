`timescale 1ns / 1ps
`include "define.v"
`include "fetch.v"
`include "decode.v"

module decode_tb;

// fetch_stage
reg [63:0] PC_i;

wire [3:0]      icode_o;
wire [3:0]      ifunc_o;
wire [3:0]      rA_o;
wire [3:0]      rB_o;
wire [63:0]     valC_o;
wire [63:0]     valP_o;
wire            instr_valid_o;
wire            imem_error_o;

// decode_stage
wire [3:0]  icode_i;
wire [3:0]  rA_i;
wire [3:0]  rB_i;
wire [63:0] valA_o;
wire [63:0] valB_o;

// 两个模块连接（中间部分）
assign rA_i = rA_o;
assign rB_i = rB_o;
assign icode_i = icode_o;

fetch fetch_module(
    .PC_i(PC_i),
    .icode_o(icode_o),
    .ifunc_o(ifunc_o),
    .rA_o(rA_o),
    .rB_o(rB_o),
    .valC_o(valC_o),
    .valP_o(valP_o),
    .instr_valid_o(instr_valid_o),
    .imem_error_o(imem_error_o)  
);

decode decode_module(
    .icode_i(icode_i),
    .rA_i(rA_i),
    .rB_i(rB_i),
    .valA_o(valA_o),
    .valB_o(valB_o)
);

initial 
begin
    PC_i = 0;
    #10 PC_i = 10;
    #10 PC_i = 20;
    #10 PC_i = 22;
    #10 PC_i = 32;
    #10 PC_i = 42;
    #10 PC_i = 44;
    #10 PC_i = 46;
    #10 PC_i = 55;
    #10 PC_i = 64;
    #10 PC_i = 65;
    #10 PC_i = 66;
    #10 PC_i = 265;
    #10 PC_i = 1024;
end

initial
    $monitor("PC=%d\t, icode=%h\t, ifunc=%h\t, rA=%h\t, rB=%h\t, valA=%h\t, valB=%h\t, valP=%h\t",
        PC_i, icode_o, ifunc_o, rA_o, rB_o, valA_o, valB_o, valP_o);
endmodule
