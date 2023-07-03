//localparam XLEN = 32;

module PC(
    output logic    [31:0]  PC_o, 

    input  logic    [31:0]  PC_i, 
    input  logic    [31:0]  PC_realign_i,
    input  logic    [31:0]  alu_out,
    
    input  logic            stall_i,
    input  logic            pc_half_i,
    input  logic            br_taken_i,
    
    input  logic            clk,
    input  logic            reset
    );
        
    always_ff @ (posedge clk, posedge reset) begin
        if (reset) begin
            PC_o <= 0;
        end
        else if (stall_i) begin
            PC_o <= PC_i;
        end
        else if (br_taken_i) begin
            PC_o <= alu_out;
        end 
        else begin
            case (pc_half_i)
                1'b0:   PC_o <= PC_i + 4;
                1'b1:   PC_o <= PC_i + 2;
                default:PC_o <= PC_i + 4;
            endcase
        end
    end

endmodule
