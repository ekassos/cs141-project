`include "cpu.svh"


module control
    (
        input logic clk_100M, rst,
        input logic [5:0] opcode, funct,
        output logic IorD, BNe, MemWrite, IRWrite, PCWrite, Branch, ALUSrcA, RegWrite, RegDst, MemtoReg,
        output logic [1:0] ALUSrcB, PCSrc,
        output logic [3:0] ALUControl
    );

logic [1:0] ALUOp;
logic [3:0] state, next_state, ALUtemp;

localparam s0 = 4'b0000,
           s1 = 4'b0001,
           s2 = 4'b0010,
           s3 = 4'b0011,
           s4 = 4'b0100,
           s5 = 4'b0101,
           s6 = 4'b0110,
           s7 = 4'b0111,
           s8 = 4'b1000,
           s9 = 4'b1001,
           s10 = 4'b1010,
           s11 = 4'b1011,
           s12 = 4'b1100,
           s13 = 4'b1101,
           s14 = 4'b1110;

type_decode type_decoder (.funct(funct), .ALUOp(ALUOp), .alu_op(ALUtemp));

always_ff @(posedge clk_100M, posedge rst) begin
    if (rst) begin
        state <= s0;
    end
    else begin
        state <= next_state;   
    end
end

always_comb begin
    case (state)
        //fetch
        s0: begin
            IorD = 1'b0;
            IRWrite = 1'b1;
            RegDst = 1'b1;
            ALUSrcA = 1'b0;
            ALUSrcB = 2'b01;
            ALUOp = 2'b00;  
            PCSrc = 2'b00;                  
            PCWrite = 1'b1;
            next_state = s1;
        end

        // decode
        s1: begin
            ALUSrcA = 1'b0;
            ALUSrcB = 2'b11;
            if (opcode == `OP_LW || `OP_SW) begin
                next_state = s2;
            end
            else if (opcode == `OP_RTYPE) begin
                next_state = s6;
            end
            else if (opcode == `OP_BNE) begin
                next_state = s8;
            end
            else if (opcode == `OP_BEQ) begin
                next_state = s9;
            end
            else if (funct == `F_JR) begin
                next_state = s10;
            end
            else if (opcode == `OP_JAL) begin
                next_state = s11;
            end
            else if (opcode == (`OP_ANDI || `OP_ORI || `OP_XORI || `OP_SLTI || `OP_ADDI)) begin
                next_state = s12;
            end
            else if (opcode == `OP_J) begin
                next_state = s14;
            end
        end              

        // mem address
        s2: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b00;
            if (opcode == `OP_LW) begin
                next_state = s3;
            end
            else if (opcode == `OP_SW) begin
                next_state = s5;
            end
        end

        //mem read
        s3: begin
            IorD = 1'b1;
            next_state = s4;
        end

        // mem writeback
        s4: begin
            RegDst = 1'b0;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            next_state = s0;
        end

        //mem write
        s5: begin
            IorD = 1'b1;
            MemWrite = 1'b1;
            next_state = s4;
        end

        // execute
        s6: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b10;
            ALUControl = ALUtemp;
            next_state = s7;
        end

        // ALU writeaback
        s7: begin
            RegDst = 1'b1;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
            next_state = s0;
        end

        // branch if not equal
        s8: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b01;
            PCSrc = 2'b01;
            Branch = 1'b1;
            next_state = s0;
        end

        // branch not equal
        s9: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b00;
            ALUOp = 2'b01;
            PCSrc = 2'b01;
            BNe = 1'b1;
            next_state = s0;
        end

        // jump register
        s10: begin
            PCSrc = 2'b10;
            PCWrite = 1'b1;
            next_state = s0;
        end

        // jump and link
        s11: begin
            PCSrc = 2'b10;
            PCWrite = 1'b1;
            RegDst = 1'b1;
            MemtoReg = 1'b1;
            RegWrite = 1'b1;
            next_state = s0;
        end

        // execute
        s12: begin
            ALUSrcA = 1'b1;
            ALUSrcB = 2'b10;
            ALUOp = 2'b00;
            ALUControl = ALUtemp;
            next_state = s13;
        end

        // writeaback
        s13: begin
            RegDst = 1'b0;
            MemtoReg = 1'b0;
            RegWrite = 1'b1;
            next_state = s0;
        end

        // jump
        s14: begin
            PCSrc = 2'b10;
            PCWrite = 1'b1;
            next_state = s0;
        end

        default: begin
            MemWrite = 1'b0;
            IRWrite = 1'b0;
            PCWrite = 1'b0;
            RegWrite = 1'b0;
            next_state = s0;
            Branch = 1'b0;
            BNe = 1'b0;
        end
    
    endcase
end

endmodule

