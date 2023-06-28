module stall_unit(input logic       [4:0]   rd_wb,
                  input logic       [4:0]   rs1_i,
                  input logic       [4:0]   rs2_i,
                  input logic               reg_wr_s2,br_taken,
                  input logic       [6:0]   opcode_i,
                  output logic              flush_s1,   //flushing
                  output logic              stall_s1,
                  output logic              stall_s2,
                  output logic      [1:0]   forward                
);

//forwarding

logic [1:0] you_can_always_check;// havent implemented for all types
always_comb begin
    case(rd_wb)
    5'b00000:forward=2'b00;

    default:begin
        case(you_can_always_check)
        2'b00:begin
            
            case(rs1_i)
                rd_wb:forward[1]=1'b1;
                default:forward[1]=1'b0;
            endcase
            case(rs2_i)
                rd_wb:forward[0]=1'b1;
                default:forward[0]=1'b0;    
            endcase  
        end
        2'b01:forward=2'b00;  
        2'b11:begin
            case(rs1_i)
                rd_wb:forward[1]=1'b1;
                default:forward[1]=1'b0;
            endcase
            forward[0]=1'b0;
        end
        endcase
        end
    endcase
    
end

//stalling 
always_comb begin
    case(opcode_i)
    //R-Type
    7'b0110011:
        begin
        flush_s1=1'b0;
        you_can_always_check=2'b00;
        //stall_s2=1b'1
        end
    //I-Type
    7'b0010011:
        begin
        flush_s1=1'b0;
        you_can_always_check=2'b11;
        //stall_s2=1b'1
        end
    //L-Type
    7'b0000011:
        begin
        flush_s1=1'b0;
        you_can_always_check=2'b11;
        //stall_s2=1b'1
        end
    //S-Type
    7'b0100011:
        begin
        flush_s1=1'b0;
        you_can_always_check=2'b11;
        //stall_s2=1b'1
        end

    //B-type
    7'b1100011:
        begin
        flush_s1=(br_taken)?1'b1:1'b0;
        you_can_always_check=2'b00;
        //stall_s2=1b'1
        end
    //aupic
    7'b0010111:
        begin
        flush_s1=(br_taken)?1'b1:1'b0;
        //you_can_always_check=2'b01;
        //stall_s2=1b'1
        end
        //Jtype
    7'b1101111:
        begin
        flush_s1=(br_taken)?1'b1:1'b0;
        you_can_always_check=2'b00;
        //stall_s2=1b'1
        end
    //jalr
    7'b1100111:
        begin
        flush_s1=(br_taken)?1'b1:1'b0;
        //you_can_always_check=2'b01;
        //stall_s2=1b'1
        end

    default:
        begin
        flush_s1=1'b0;
        you_can_always_check=2'b00;
        end
    endcase
end
endmodule