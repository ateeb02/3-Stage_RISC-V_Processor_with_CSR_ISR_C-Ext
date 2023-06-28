//localparam XLEN = 32;

module imm_gen(
    output logic    [31:0]  imm_o,

    input  logic    [6:0]   opcode,
    input  logic    [11:0]  imm_i,
    input  logic    [19:0]  uimm_i
    );

    always_comb begin
        case (opcode)
            // I-type & S-Type instructions
            7'b0010011:begin
                imm_o = {{20{imm_i[11]}}, imm_i};
            end 
            7'b0000011:begin
                imm_o = {{20{imm_i[11]}}, imm_i};
            end 
            7'b0100011: begin
                imm_o = {{20{imm_i[11]}}, imm_i};
            end
            // B-type instructions
            7'b1100011: begin
                imm_o = {{19{imm_i[11]}}, imm_i,1'b0};
            end
            // J-type instructions
            7'b1101111: begin
                imm_o = {{11{uimm_i[19]}}, uimm_i, 1'b0};
            end
            7'b1100111: begin
                imm_o = {{20{imm_i[11]}}, imm_i};
            end
            // U-type instructions
            7'b0010111:begin
                imm_o = {uimm_i, 12'b000000000000};
            end
            7'b0110111: begin
                imm_o = {uimm_i, 12'b000000000000};
            end
        endcase
    end
endmodule
