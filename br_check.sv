//localparam XLEN = 32;

module br_check(
    output logic            br_taken_c,

    input  logic    [31:0]  rs1_i,
    input  logic    [31:0]  rs2_i,
    input  logic    [2:0]   br_type_c
    );



    logic		[31:0]		blt_chk;
    logic unsigned	[32:0]	blt_chk1;

 
    
    assign blt_chk=rs1_i-rs2_i;
    assign blt_chk1=$unsigned(rs1_i)-$unsigned(rs2_i);
        

    always_comb begin

        case(br_type_c)
            //beq
            3'b010: begin br_taken_c = (blt_chk==0) ? 1'b1: 1'b0;end
            //bne
            3'b001: begin br_taken_c = (blt_chk!=0) ? 1'b1: 1'b0;end
            //blt
            3'b100: begin br_taken_c = (blt_chk[31] == 1'b1) ? 1'b1: 1'b0;end
            //bge
            3'b101: begin br_taken_c = (blt_chk[31] == 1'b0) ? 1'b1: 1'b0;end
            //bltu
            3'b110: begin br_taken_c = (blt_chk1[32]==1'b1) ? 1'b1: 1'b0;end
            //bgeu
            3'b111: begin br_taken_c = (blt_chk1[32]==1'b0) ? 1'b1: 1'b0;end
            //Default value for reset
            3'b000: br_taken_c = 1'b0;
            3'b011: br_taken_c = 1'b1;
            default:br_taken_c = 1'b0;
        endcase
    end

endmodule
