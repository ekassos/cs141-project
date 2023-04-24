`include "cpu.svh"


module Itype_decode 
    (
        input logic [5:0] opcode,
        output logic [3:0] alu_op
    );

always_comb begin
    case (opcode)
        6'b001100: alu_op = `ALU_AND;
        6'b001101: alu_op = `ALU_OR;
        6'b001110: alu_op = `ALU_XOR;
        6'b001000: alu_op = `ALU_ADD;
        6'b001010: alu_op = `ALU_SLT;
    endcase 
end

endmodule