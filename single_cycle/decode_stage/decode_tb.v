wire [ 3:0]  icode_i;
wire [79:0]  rA_i;
wire [79:0]  rB_i;
wire [63:0]  valA_o;
wire [63:0]  valB_o;
wire [63:0]  valC_o;
wire         instr_valid_o;
wire         imem_error_o;

fetch fetch_module(
    .PC_i(PC_i);
    .icode_o(icode_o);
    .ifunc_o(ifunc_o);
    .rA_o();
    .rB_o();
    .valC_o(valC_o);
    .valP_o(valP_o);
    .instr_valid_o(instr_valid_o);
    .imem_error_o(imem_error_o);
);

decode decode_module(
    .icode_i(icode_i);
    .rA_i(rA_o);
    .rB_i(rB_o);
    .valA_o(valA_o);
    .valB_o(valB_o);
);