

module decoder(
    output logic    [6:0]   opcode_o,
    output logic    [6:0]   funct7_o,
    output logic    [2:0]   funct3_o,
    output logic    [4:0]   rs1_o,
    output logic    [4:0]   rs2_o,
    output logic    [4:0]   rd_o,
    output logic    [11:0]  imm_o,
    output logic    [19:0]  u_imm_o,

    input  logic    [31:0]  instr_i
    );

    always_comb begin
        opcode_o = instr_i[6:0];
        case (opcode_o)
            //R-Type
            7'b0110011: begin 
                rd_o        = instr_i[11:7]; 
                rs1_o       = instr_i[19:15];
                rs2_o       = instr_i[24:20];    
                funct3_o    = instr_i[14:12];
                funct7_o    = instr_i[31:25];
            end
            //I-Type
            7'b0010011 : begin 
                rd_o        = instr_i[11:7]; 
                rs1_o       = instr_i[19:15];
                imm_o       = instr_i[31:20];    
                funct3_o    = instr_i[14:12];
            end
            7'b0000011: begin 
                rd_o        = instr_i[11:7]; 
                rs1_o       = instr_i[19:15];
                imm_o       = instr_i[31:20];    
                funct3_o    = instr_i[14:12];
            end
            
            //S-Type
            7'b0100011: begin 
                rd_o        = instr_i[24:20]; 
                rs1_o       = instr_i[19:15];
                imm_o       = {instr_i[31:25],instr_i[11:7]};    
                funct3_o    = instr_i[14:12];
            end
            //B-Type
            7'b1100011: begin 
                rs1_o       = instr_i[19:15];
                rs2_o       = instr_i[24:20];
                imm_o     = {instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8]};   
                funct3_o    = instr_i[14:12];
            end
            //U-Type
            7'b0110111: begin 
                rd_o        = instr_i[11:7];
                u_imm_o     = instr_i[31:12];   
            end
            7'b0010111: begin 
                rd_o        = instr_i[11:7];
                u_imm_o     = instr_i[31:12];   
            end
            //J-Type
            7'b1101111: begin 
                rd_o        = instr_i[11:7];
                u_imm_o     = {instr_i[31],instr_i[19:12],instr_i[20],instr_i[30:21]};   
            end
            //jalr
            7'b1100111:begin 
                rs1_o       = instr_i[19:15];
                rd_o        = instr_i[11:7];
                imm_o       = instr_i[31:20];     
                funct3_o    = instr_i[14:12];
            end
        endcase
    end
endmodule



