`timescale 1ns/1ps
`include "define.v"
`include "decode_wb.v"
`include "writeback.v"

module decode_wb_tb();

// reg_input
reg  clk_i;
reg  cnd;
reg  [ 3:0]  icode_i;
reg  [63:0]  rA_i;
reg  [63:0]  rB_i;
reg  [63:0]  valM_i;
reg  [63:0]  valE_i;

// wire_output
wire  [63:0]  valA_o;
wire  [63:0]  valB_o;


initial begin
    clk_i = 0;
end
always begin
    #20 clk_i = ~clk_i;
end
initial begin
    #500 $stop;
end


initial begin

    cnd = 0;
    icode_i = `IOPQ;
    rA_i   = 0;
    rB_i   = 1;
    valM_i = 2;
    valE_i = 3;
    $display(
        "icode=%h\t, valM=%h\t, valE=%h\t",
        icode_i, valM_i, valE_i
    );

    cnd = 0;
    icode_i = `IPOPQ;
    rA_i   = 4;
    rB_i   = 5;
    valM_i = 6;
    valE_i = 7;
    $display(
        "icode=%h\t, valM=%h\t, valE=%h\t",
        icode_i, valM_i, valE_i
    );

end

endmodule