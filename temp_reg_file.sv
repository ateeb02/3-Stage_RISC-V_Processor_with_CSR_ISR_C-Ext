module reg_file(
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
    

    always_ff @ (posedge clk) begin
        register[0]<=32'h00000000;
        rdata_1_o <=    register    [raddr_1_i];
        rdata_2_o <=    register    [raddr_2_i];  
    end

    always_ff @ (negedge clk) begin
        
        if (reg_wr_c) begin
            register [waddr_i] <=  wdata_o;
            register[0]<=32'h00000000;
        end
    end
endmodule