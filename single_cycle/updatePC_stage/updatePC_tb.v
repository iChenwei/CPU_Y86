`timescale 1ps/1ps
`include "define.v"
`include "updatePC.v"

module updatePC_tb ();
    // input -> reg
    reg [3:0]   icode_i;
    reg         cnd_i;
    reg [63:0]  valC_i;
    reg [63:0]  valM_i;
    reg [63:0]  valP_i;

    // output -> wire
    wire [63:0] PC_o;

    updatePC updatePC_module(
        .icode_i(icode_i),
        .cnd_i(cnd_i),
        .valC_i(valC_i),
        .valM_i(valM_i),
        .valP_i(valP_i),
        .PC_o(PC_o)
    );
    
    reg clk;

    initial begin

        icode_i = `IJXX;
        cnd_i = 1;
        valC_i = 20;
        valM_i = 0;
        valP_i = 0;
        clk = 1; #10; 
        clk = ~clk; #10;
        $display(
            "icode=%h\t, cnd=%h\t, valC=%h\t, valM=%h\t, valP=%h\t, PC=%h\n",
            icode_i, cnd_i, valC_i, valM_i, valP_i, PC_o
       );

        icode_i = `IPUSHQ;
        cnd_i  = 0;
        valC_i = 0;
        valM_i = 0;
        valP_i = 2;
        clk = 1; #10; 
        clk = ~clk; #10;
        $display(
            "icode=%h\t, cnd=%h\t, valC=%h\t, valM=%h\t, valP=%h\t,PC=%h\n",
            icode_i, cnd_i, valC_i, valM_i, valP_i, PC_o
        );

    end
endmodule