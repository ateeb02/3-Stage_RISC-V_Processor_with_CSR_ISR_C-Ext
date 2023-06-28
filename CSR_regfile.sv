
module reg_file1(
    output logic    [31:0]  rdata_1_o,
    output logic    [31:0]  rdata_2_o,

    input  logic    [31:0]  wdata_o,
    input  logic    [4:0]       raddr_1_i,
    input  logic    [4:0]       raddr_2_i,
    input  logic    [4:0]       waddr_i,
    input  logic                reg_wr_c,
    input  logic                clk,
    input  logic                reset
    );

    reg     [31:0]  register    [32];


    always_ff @ (posedge clk,negedge reset) begin
        if (reset) begin
            PC_o <= 0;
        end
        else begin
            PC_o <= PC_i;
        end
    end
    
 
    
endmodule