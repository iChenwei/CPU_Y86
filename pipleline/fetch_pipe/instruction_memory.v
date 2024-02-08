module instruction_memory(
    input  wire  [63:0]  raddr_i,
    output wire  [79:0]  instr_o,
    output wire          imem_error_o
);

// 指令存储器
reg [7:0]  instr_mem[0:1023];

// 合法判断：访问指令寄存器
assign imem_error_o = (raddr_i > 1023);

assign instr_o = {
    instr_mem[raddr_i + 9], instr_mem[raddr_i + 8], instr_mem[raddr_i + 7],
    instr_mem[raddr_i + 6], instr_mem[raddr_i + 5], instr_mem[raddr_i + 4],
    instr_mem[raddr_i + 3], instr_mem[raddr_i + 2], instr_mem[raddr_i + 1],
    instr_mem[raddr_i + 0]
};

initial begin
    //main:
        // irmovq $0x0, %rax
        // 30_f0_00_00_00_00_00_00_00_00  
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 0
        // valC  = 0     valP  = a
        // valA  = 0     valB  = 0
        // valE_exe = 0  valM_mem = 0
        // valE_wb = 0    valM_wb = 0
        // npc = a
        instr_mem[0]=8'b00110000; //3 0
        instr_mem[1]=8'b00000000; //F rB=0
        instr_mem[2]=8'b00000000;           
        instr_mem[3]=8'b00000000;           
        instr_mem[4]=8'b00000000;           
        instr_mem[5]=8'b00000000;           
        instr_mem[6]=8'b00000000;           
        instr_mem[7]=8'b00000000;           
        instr_mem[8]=8'b00000000;          
        instr_mem[9]=8'b00000000; //V=0  valC = 0
/*
        // irmovq $0x10, %rdx
        // 30_f2_10_00_00_00_00_00_00_00
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 2
        // valC  = 10     valP  = 14
        // valA  = 0     valB  = 2
        // valE_exe = 10  valM_mem = 0
        // valE_wb = 10    valM_wb = 0
        // npc = 14
        instr_mem[10]=8'b00110000; //3 0
        instr_mem[11]=8'b00000010; //F rB=2
        instr_mem[12]=8'b00010000;           
        instr_mem[13]=8'b00000000;           
        instr_mem[14]=8'b00000000;           
        instr_mem[15]=8'b00000000;           
        instr_mem[16]=8'b00000000;           
        instr_mem[17]=8'b00000000;           
        instr_mem[18]=8'b00000000;          
        instr_mem[19]=8'b00000000; //V=16

        //irmovq $0xc, %rbx
        // 30 f3 0c 00 00 00 00 00 00 00
        // icode = 3     ifunc = 0
        // rA    = 0      rB   = 3
        // valC  =      valP  = 
        // valA  =      valB  = 
        // valE_exe =   valM_mem = 
        // valE_wb =     valM_wb = 
        // npc = 
        instr_mem[20]=8'h30; //3 0
        instr_mem[21]=8'hf3; //F rB=3
        instr_mem[22]=8'h0c;            
        instr_mem[23]=8'h00;           
        instr_mem[24]=8'h00;           
        instr_mem[25]=8'h00;           
        instr_mem[26]=8'h00;           
        instr_mem[27]=8'h00;           
        instr_mem[28]=8'h00;          
        instr_mem[29]=8'h00; //V=12
        
        //jmp check
        // 70 27 00 00 00 00 00 00 00
        instr_mem[30]=8'h70; //7 fn
        instr_mem[31]=8'h27; //Dest
        instr_mem[32]=8'h00; //Dest
        instr_mem[33]=8'h00; //Dest
        instr_mem[34]=8'h00; //Dest
        instr_mem[35]=8'h00; //Dest
        instr_mem[36]=8'h00; //Dest
        instr_mem[37]=8'h00; //Dest
        instr_mem[38]=8'h00; //

        // check:
        // addq %rax, %rbx 
        // 6003
        instr_mem[39]=8'h60; //6 fn
        instr_mem[40]=8'h03; //rA=0 rB=3

        // je rbxres  
        // 737a00000000000000
        instr_mem[41]=8'h73; //7 fn=3
        instr_mem[42]=8'h7a; //Dest
        instr_mem[43]=8'h00; //Dest
        instr_mem[44]=8'h00; //Dest
        instr_mem[45]=8'h00; //Dest
        instr_mem[46]=8'h00; //Dest
        instr_mem[47]=8'h00; //Dest
        instr_mem[48]=8'h00; //Dest
        instr_mem[49]=8'h00; //
        // addq %rax, %rdx
        // 6002
        instr_mem[50]=8'h60; //6 fn
        instr_mem[51]=8'h02; //rA=0 rB=2
        // je rdxres 
        // 737d00000000000000 
        instr_mem[52]=8'h73; //7 fn=3
        instr_mem[53]=8'h7d; //Dest
        instr_mem[54]=8'h00; //Dest
        instr_mem[55]=8'h00; //Dest
        instr_mem[56]=8'h00; //Dest
        instr_mem[57]=8'h00; //Dest
        instr_mem[58]=8'h00; //Dest
        instr_mem[59]=8'h00; //Dest
        instr_mem[60]=8'h00; //Dest=125
        // jmp loop2 
        // 704600000000000000
        instr_mem[61]=8'h70; //7 fn=0
        instr_mem[62]=8'h46; //Dest
        instr_mem[63]=8'b00000000; //Dest
        instr_mem[64]=8'b00000000; //Dest
        instr_mem[65]=8'b00000000; //Dest
        instr_mem[66]=8'b00000000; //Dest
        instr_mem[67]=8'b00000000; //Dest
        instr_mem[68]=8'b00000000; //Dest
        instr_mem[69]=8'h00; //Dest

        // loop2:
        // rrmovq %rdx, %rsi 
        instr_mem[70]=8'b00100000; //2 fn=0
        instr_mem[71]=8'b00100110; //rA=2 rB=6
        // rrmovq %rbx, %rdi
        instr_mem[72]=8'b00100000; //2 fn=0
        instr_mem[73]=8'b00110111; //rA=3 rB=7
        // subq %rbx, %rsi
        instr_mem[74]=8'b01100001; //6 fn=1
        instr_mem[75]=8'b00110110; //rA=3 rB=6
        // jge ab1  
        instr_mem[76]=8'b01110001; //7 fn=5
        instr_mem[77]=8'h60; //Dest
        instr_mem[78]=8'b00000000; //Dest
        instr_mem[79]=8'b00000000; //Dest
        instr_mem[80]=8'b00000000; //Dest
        instr_mem[81]=8'b00000000; //Dest
        instr_mem[82]=8'b00000000; //Dest
        instr_mem[83]=8'b00000000; //Dest
        instr_mem[84]=8'h00; //Dest=96
        // subq %rdx, %rdi 
        instr_mem[85]=8'b01100001; //6 fn=1
        instr_mem[86]=8'b00100111; //rA=2 rB=7
        // jge ab2
        instr_mem[87]=8'b01110001; //7 fn=5
        instr_mem[88]=8'h6d; //Dest
        instr_mem[89]=8'b00000000; //Dest
        instr_mem[90]=8'b00000000; //Dest
        instr_mem[91]=8'b00000000; //Dest
        instr_mem[92]=8'b00000000; //Dest
        instr_mem[93]=8'b00000000; //Dest
        instr_mem[94]=8'b00000000; //Dest
        instr_mem[95]=8'h00; 

        // ab1:
        // rrmovq %rbx, %rdx
        instr_mem[96]=8'b00100000; //2 fn=0
        instr_mem[97]=8'b00110010; //rA=3 rB=2
        // rrmovq %rsi, %rbx
        instr_mem[98]=8'b00100000; //2 fn=0
        instr_mem[99]=8'b01100011; //rA=6 rB=3
        // jmp check
        instr_mem[100]=8'b01110000; //7 fn=0
        instr_mem[101]=8'h27; //Dest
        instr_mem[102]=8'b00000000; //Dest
        instr_mem[103]=8'b00000000; //Dest
        instr_mem[104]=8'b00000000; //Dest
        instr_mem[105]=8'b00000000; //Dest
        instr_mem[106]=8'b00000000; //Dest
        instr_mem[107]=8'b00000000; //Dest
        instr_mem[108]=8'h00; //Dest=39

        // ab2:
        // rrmovq %rbx, %rdx
        instr_mem[109]=8'b00100000; //2 fn=0
        instr_mem[110]=8'b00110010; //rA=3 rB=2
        // rrmovq %rdi, %rbx
        instr_mem[111]=8'b00100000; //2 fn=0
        instr_mem[112]=8'b01110011; //rA=7 rB=3
        // jmp check
        instr_mem[113]=8'b01110000; //7 fn=0
        instr_mem[114]=8'h27; //Dest
        instr_mem[115]=8'b00000000; //Dest
        instr_mem[116]=8'b00000000; //Dest
        instr_mem[117]=8'b00000000; //Dest
        instr_mem[118]=8'b00000000; //Dest
        instr_mem[119]=8'b00000000; //Dest
        instr_mem[120]=8'b00000000; //Dest
        instr_mem[121]=8'b00000000; //Dest=39

        // rbxres:
        // rrmovq %rdx, %rcx
        instr_mem[122]=8'b00100000; //2 fn=0
        instr_mem[123]=8'b00100001; //rA=2 rB=1
        // halt
        instr_mem[124]=8'b00000000;

        // rdxres:
        // rrmovq %rbx, %rcx
        instr_mem[125]=8'b00100000; //2 fn=0
        instr_mem[126]=8'b00110001; //rA=3 rB=1
        // halt
        instr_mem[127]=8'b00000000;
*/        
end

endmodule