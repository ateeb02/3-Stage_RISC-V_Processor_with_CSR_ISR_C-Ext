//localparam XLEN = 32;

module adder (
    input  logic    [31:0]  word_a, 
    input  logic 	[31:0]  word_b, 
    input  logic            carry_i, 

    output logic    [31:0]  result
    );    

    assign result = word_a + word_b + carry_i;
endmodule            

module ALU(
    input  logic 	   [31:0]      rs1,
    input  logic 	   [31:0]      rs2,
    input  logic           [3:0]      alu_op,

    output logic 	   [31:0]      rd
    );

    logic                                  carry;
    logic        	   [31:0]           rs2_i,rs1_i,rd_a; 
    
    always_comb begin
        case (alu_op)
            //1.ADD
            4'b0000: begin carry = 1'b0; rs2_i = rs2;  rd=rd_a;   		end
            //2.SUB
            4'b0001: begin carry = 1'b1; rs2_i = ~rs2;  rd=rd_a;   		end
            //3.SLT
            4'b0010: begin rd = (rs1 < rs2) ? 1 : 0;                            end
            //4.SLTU
            4'b0011: begin rd = ($unsigned(rs1) < $unsigned(rs2)) ? 1 : 0;      end
            //5.AND
            4'b0100: begin rd = rs1 & rs2;                                      end
            //6.OR
            4'b0101: begin rd = rs1 | rs2;                                      end
            //7.XOR
            4'b0110: begin rd = rs1 ^ rs2;                                      end
            //8.SLL
            4'b0111: begin rd = rs1 << rs2;                                     end
            //9.SRL
            4'b1000: begin rd = rs1 >> rs2;                                     end
            //10.SRA
            4'b1001: begin rd = rs1 >>> rs2;                                    end
            //bypass
            4'b1010: begin rd = rs2;                                            end
        endcase
    end

    adder Adder(.word_a(rs1), 
                .word_b(rs2_i), 
                .carry_i(carry), 

                .result(rd_a)
                );
                
endmodule
