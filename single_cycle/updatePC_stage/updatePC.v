`include "define.v"

module updatePC (
    input wire [ 3:0]  icode_i,
    input wire         cnd_i,
    input wire [63:0]  valC_i,
    input wire [63:0]  valM_i,
    input wire [63:0]  valP_i,

    output reg[63:0]  PC_o
);

// 根据icode判断何种方式更新PC
always @(*) begin
    case (icode_i)
        `IHALT : begin
            PC_o = valP_i;
        end
        `INOP : begin
            PC_o = valP_i;
        end
        `ICMOVQ : begin
            PC_o = valP_i;
        end
        `IIRMOVQ : begin
            PC_o = valP_i;
        end
        `IRMMOVQ : begin
            PC_o = valP_i;
        end
        `IMRMOVQ : begin
            PC_o = valP_i;
        end
        `IOPQ : begin
            PC_o = valP_i;
        end
        `IJXX : begin
            PC_o = cnd_i ? valC_i : valP_i;
        end
        `ICALL : begin
            PC_o = valC_i;
        end
        `IRET : begin
            PC_o = valM_i;
        end
        `IPUSHQ : begin
            PC_o = valP_i;
        end
        `IPOPQ : begin
            PC_o = valP_i;
        end
    endcase 
end

endmodule