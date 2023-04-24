`include "cpu.svh"

module ir_decode 
    (
        input logic [31:0] inst,
        output logic [5:0] opcode,
        output logic [4:0] rs,
        output logic [4:0] rt,
        output logic [4:0] rd,
        output logic [4:0] shamt,
        output logic [5:0] funct,
        output logic [15:0] imm,
        output logic [25:0] addr
    );
    assign opcode = inst[31:26];
    
    always_comb begin
    if (opcode == 6'b000000)            // R type
        begin
            rs = inst[25:21];
            rt = inst[20:16];
            rd = inst[15:11];
            shamt = inst[10:6];
            funct = inst[5:0];
        end
    else if (opcode == (6'b000010 || 6'b000011 ))       //J type
        begin
            addr = inst[25:0];
        end
    else                            // I type
        begin
            rs = inst[25:21];
            rt = inst[20:16];
            imm = inst[15:0];
        end
   end  

endmodule