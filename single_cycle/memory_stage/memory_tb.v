`timescale 1ns/1ps
`include "define.v"
`include "memory.v"

module memory_tb();
// I/O
reg clk_i;
reg [ 3:0] icode_i;
reg [63:0] valA_i;
reg [63:0] valE_i;
reg [63:0] valP_i;

wire [63:0] valM_o;
wire dmem_error_o;

memory mem_module(
    .clk_i(clk_i),
    .icode_i(icode_i),
    .valE_i(valE_i),
    .valA_i(valA_i),
    .valP_i(valP_i),
    .valM_o(valM_o),
    .dmem_error_o(dmem_error_o)
);

// 时钟信号
//initial clk_i = 1;
//always #10 clk_i = ~clk_i;

// 初始化
initial begin
    // 读相关
    // mrmovq D(rB), rA   --- mrmovq (%rdi) %r10
    // 50_a7_00_00_00_00_00_00_00_00
    // valM <- M[valE]
    icode_i = 5;
    valA_i  = 10;
    valE_i  = 2;
    valP_i  = 0;
    #10 clk_i = 1;
    #10 clk_i = ~clk_i;
    $display(
        // valM = a
        "icode=%h\t, valA=%h\t, valE=%h\t, valP=%h\t, valM=%h\t, dmem_error=%b\n",
        icode_i, valA_i, valE_i, valP_i, valM_o, dmem_error_o
    );

    // 写相关
    // rmmovq rA, D(rB) --- 
    icode_i = 4;
    valA_i  = 128;
    valE_i  = 0;
    valP_i  = 0;
    #10 clk_i = 1;
    #10 clk_i = ~clk_i;
    $display(
        "icode=%h\t, valA=%h\t, valE=%h\t, valP=%h\t, valM=%h\t, dmem_error=%b\n",
        icode_i, valA_i, valE_i, valP_i, valM_o, dmem_error_o
    );

end

endmodule

/*
`timescale 1ns/1ps
`include "define.v"
`include "memory.v"

module memory_tb();
  // I/O
  reg clk_i;
  reg [ 3:0] icode_i;
  reg [63:0] valA_i;
  reg [63:0] valE_i;
  reg [63:0] valP_i;

  wire [63:0] valM_o;
  wire dmem_error_o;

  // Instantiate the memory module
  memory mem_module(
      .clk_i(clk_i),
      .icode_i(icode_i),
      .valE_i(valE_i),
      .valA_i(valA_i),
      .valP_i(valP_i),
      .valM_o(valM_o),
      .dmem_error_o(dmem_error_o)
  );

  // Clock generation
  initial begin
      clk_i = 1;
      forever #5 clk_i = ~clk_i;
  end

  // Test cases
  initial begin
      // Read-related test case
      icode_i = `IMRMOVQ;
      valA_i  = 8'h0A;
      valE_i  = 64'h0000000000000002;
      valP_i  = 64'h0000000000000000;
      #50;  // Allow some cycles for the memory operation to complete
      $display("Read Test Case: valM=%h, dmem_error=%b", valM_o, dmem_error_o);

      // Write-related test case
      icode_i = `IRMMOVQ;
      valA_i  = 64'h0000000000000002;
      valE_i  = 8'h0;
      valP_i  = 64'h0000000000000000;
      #50;  // Allow some cycles for the memory operation to complete
      $display("Write Test Case: valM=%h, dmem_error=%b", valM_o, dmem_error_o);

      // Add more test cases as needed
  end

  // Stop simulation after all test cases
  initial #500 $stop;
endmodule
*/