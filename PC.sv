//localparam XLEN = 32;

module PC(
    output logic    [31:0]  PC_o, 

    input  logic    [31:0]  PC_i, 
    input  logic    [31:0]  alu_out,
    input  logic            br_taken_c,
    input  logic            clk,
    input  logic            reset
    );
        
    always_ff @ (posedge clk,posedge reset) begin
        if (reset) begin
            PC_o <= 0;
        end
        else begin
            PC_o <= PC_i;
        end
    end

endmodule
