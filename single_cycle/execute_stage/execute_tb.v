`timescale 1ps/1ps
`include "execute.v"
`include "define.v"

module execute_tb();

    // 输入reg类型
    reg clk_i;
    reg rst_n_i;
    reg  [ 3:0]  icode_i;
    reg  [ 3:0]  ifunc_i;
    reg signed [63:0]  valC_i;
    reg signed [63:0]  valA_i;
    reg signed [63:0]  valB_i;

    // 输出wire类型
    wire signed [63:0] valE_o;

    wire Cnd_o;

    execute exec(
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .icode_i(icode_i),
        .ifunc_i(ifunc_i),
        .valC_i(valC_i),
        .valA_i(valA_i),
        .valB_i(valB_i),
        .valE_o(valE_o),
        .Cnd_o(Cnd_o)
    );

// add 60
// sub 61
// and 62
// xor 63
initial begin
    //  addq %rdx, %rbx
    /*    60_23
        icode is 6   ifunc is 0
        ccc <-- 000
        valE = 300
    */
    rst_n_i = 1;
    icode_i = 6;
    ifunc_i = 0;
    valA_i = 200;
    valB_i = 100;
    valC_i = 0;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    // je dest  == 73_00
    /* 
        cnd = 0
    */
    rst_n_i = 1; 
    icode_i = 7;
    ifunc_i  = 3;
    valA_i  = 0; 
    valB_i  = 0;
    valC_i = 40;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    // "61_23" subq %rdx,%rbx 
    // %rbx <-- 0x0 CC <-- 100 
    rst_n_i = 1; 
    icode_i = 6;
    ifunc_i  = 1;
    valA_i  = 200; 
    valB_i  = 200;
    valC_i  = 0;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    //"73_00"je dest #jump   
    rst_n_i = 1; 
    icode_i = 7;
    ifunc_i  = 3;
    valA_i  = 0; 
    valB_i  = 0;
    valC_i  = 40;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    // "30_f2_00_01_00_00_00_00_00_00" 
    //irmovq $0x100,%rbx 
    //%rbx <-- 0x100      
    rst_n_i = 0; 
    icode_i = 4'h3;
    ifunc_i  = 0;
    valA_i  = 10;
    valB_i  = 20;
    valC_i  = 100;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    //"a0_2f" 
    //pushq %rbx
    rst_n_i = 1; 
    icode_i = 4'ha;
    ifunc_i  = 0;
    valA_i  = 0;
    valB_i  = 208;
    valC_i  = 0;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );
// =====
//"73_00"je dest # Not taken 
    rst_n_i = 1; 
    icode_i = 7;
    ifunc_i  = 3;
    valA_i  = 0; 
    valB_i  = 0;
    valC_i  = 40;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );


    //"73_00"je dest #jump   
    rst_n_i = 1; 
    icode_i = 7;
    ifunc_i  = 3;
    valA_i  = 0; 
    valB_i  = 0;
    valC_i  = 40;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );


    //24_12 rrmovq <--  0x60 
    rst_n_i = 1; 
    icode_i = 2;
    ifunc_i  = 4;
    valA_i  = 60; 
    valB_i  = 50;
    valC_i  = 0;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

    //20_12 cmovne <--  0x20
    rst_n_i = 1; 
    icode_i = 2;
    ifunc_i  = 0;
    valA_i  = 20; 
    valB_i  = 40;
    valC_i  = 0;
    #10 clk_i = 1;  
    #10 clk_i = ~clk_i;
    $display("icode=%h\t, ifunc=%h\t, valA=%d\t, valB=%d\t, valC=%d\t, valE=%d\t, Cnd=%d\t", 
        icode_i, ifunc_i, valA_i, valB_i, valC_i, valE_o, Cnd_o
    );

end

endmodule