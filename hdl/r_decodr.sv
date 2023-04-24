`include "cpu.svh"


module type_decode 
    (
        input logic [5:0] funct,
        input logic [1:0] ALUOp,
        output logic [3:0] alu_op
    );

always_comb begin
    case (ALUOp)
    2'b00: alu_op = `ALU_ADD;
    2'b01: alu_op = `ALU_SUB;
    2'b10: begin
        case (funct)
        6'b100100: alu_op = `ALU_AND;
        6'b100101: alu_op = `ALU_OR;
        6'b100110: alu_op = `ALU_XOR;
        6'b100111: alu_op = `ALU_NOR;
        6'b100000: alu_op = `ALU_ADD;
        6'b100010: alu_op = `ALU_SUB;
        6'b101010: alu_op = `ALU_SLT;
        6'b000010: alu_op = `ALU_SRL;
        6'b000000: alu_op = `ALU_SLL;
        6'b000011: alu_op = `ALU_SRA;
        6'b001100: alu_op = `ALU_AND;
        6'b001101: alu_op = `ALU_OR;
        6'b001110: alu_op = `ALU_XOR;
        6'b001000: alu_op = `ALU_ADD;
        6'b001010: alu_op = `ALU_SLT;
        endcase
    end
    endcase 
end

endmodule