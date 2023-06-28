//localparam XLEN = 32;

module control(
    output logic    [3:0]   alu_op_o,
    output logic            reg_wr_o,
    output logic            sel_a_o,
    output logic            sel_b_o,
    output logic            rd_wr_o,//edited
    output logic    [2:0]   mask,   //edited
    output logic    [1:0]   wb_sel_o,
    output logic    [2:0]   br_type_o,
    output logic            cs_o,   //edited (added new signal)

    input  logic    [6:0]   opcode_i,
    input  logic    [6:0]   funct7_i,
    input  logic    [2:0]   funct3_i
    );

    logic   [1:0]   wr_en_o;
    logic   [2:0]   rd_en_o;

    always_comb begin
        case (opcode_i)
            //R-Type
            7'b0110011: begin 
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b0;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b01;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b000;
            case(funct3_i)
                3'b000: begin
                    alu_op_o = (funct7_i==7'b0000000)? 4'b0000:4'b0001;
                end
                3'b001: begin
                    alu_op_o = 4'b0111;
                end
                3'b010: begin
                    alu_op_o = 4'b0010;
                end
                3'b011: begin
                    alu_op_o = 4'b0011;
                end
                3'b100: begin
                    alu_op_o = 4'b0110;
                end
                3'b101: begin
                    alu_op_o = (funct7_i==7'b0000000)? 4'b1000:4'b1001;
                end
                3'b110: begin
                    alu_op_o = 4'b0101;
                end
                3'b111: begin
                    alu_op_o =  4'b0100;
                end
            endcase
            end
            //I-Type
            7'b0010011: begin
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b01;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b000;
            case(funct3_i)
                3'b000: begin
                    alu_op_o =  4'b0000; //addi
                end
                3'b001: begin
                    alu_op_o = 4'b0111;//slli
                end
                3'b010: begin
                    alu_op_o = 4'b0010;//slti
                end
                3'b011: begin
                    alu_op_o = 4'b0011;//sltiu
                end
                3'b100: begin
                    alu_op_o = 4'b0110;//xori
                end
                3'b101: begin
                    alu_op_o = (funct7_i==7'b0000000)? 4'b1000:4'b1001;//srli,srai
                end
                3'b110: begin
                    alu_op_o = 4'b0101;//ori
                end
                3'b111: begin
                    alu_op_o =  4'b0100;//andi
                end
            endcase
            end
            //L-Type
            7'b0000011: begin 
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b00;
            rd_wr_o     = 1'b1; //active high for load(read)
            alu_op_o    = 4'b0000;
            br_type_o   = 3'b000;
            cs_o        = 1'b0; //chip select: new acive low signal

            case(funct3_i)
                3'b000: begin
                    mask  =3'b010;                         
                end
                3'b001: begin                        
                    mask  =3'b001;
                end
                3'b010: begin
                    mask  =3'b000;//word                       
                end
                3'b100: begin
                    mask  =3'b100; 
                end
                3'b101: begin
                    mask  =3'b011;    
                end
            endcase         
            end
            //S-Type
            7'b0100011: begin 
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b00;
            rd_wr_o     = 1'b0; //Active low for store(write)
            alu_op_o    = 4'b0000;
            br_type_o   = 3'b000;
            cs_o        = 1'b0; //chip select: new acive low signal
            case(funct3_i)
                3'b000: begin
                    mask  =3'b010;                         
                end
                3'b001: begin                        
                    mask  =3'b001;
                end
                3'b010: begin
                    mask  =3'b000;//word    
                end                   
            endcase
            end
            //B-Type
            7'b1100011: begin 
            sel_a_o     = 1'b1;            // check this from datapath
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b0;
            wb_sel_o    = 2'b11;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            alu_op_o	=4'b0000;
            case(funct3_i)
                3'b000: begin   //beq
                    br_type_o = 3'b010;
                end
                3'b001: begin   //bne
                    br_type_o = 3'b001;
                end
                3'b100: begin   //blt
                    br_type_o = 3'b100;
                end
                3'b101: begin   //bge
                    br_type_o = 3'b101;
                end
                3'b110: begin   //bltu
                    br_type_o = 3'b110;
                end
                3'b111: begin  //bgeu
                    br_type_o = 3'b111;            
                end
                default:br_type_o = 3'b000;
            endcase
            end
            //U-Type
            7'b0110111: begin 
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b01;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b000;
            alu_op_o    = 4'b1010; // ??????check1000
            end
            //aupic
            7'b0010111: begin 
            sel_a_o     = 1'b1;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b10;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b011;
            alu_op_o    = 4'b0000; // ??????check1000
            end

            //J-Type
            7'b1101111: begin 
            sel_a_o     = 1'b1;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b10;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b011;
            alu_op_o    = 4'b0000; // ??????check1000
            end

            //jalr case
            7'b1100111: begin 
            sel_a_o     = 1'b0;
            sel_b_o     = 1'b1;
            reg_wr_o    = 1'b1;
            wb_sel_o    = 2'b10;
            wr_en_o     = 2'b00;
            rd_en_o     = 3'b000;
            br_type_o   = 3'b011;
            alu_op_o    = 4'b0000; // ??????check1000
            end

            
        endcase
    end
endmodule
