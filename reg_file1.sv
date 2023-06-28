//localparam XLEN = 32;

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



        
    always_ff @(posedge clk)begin
        if ((raddr_1_i|raddr_2_i)!=0)begin
            rdata_1_o <=    register    [raddr_1_i];
            rdata_2_o <=    register    [raddr_2_i];
            end
        else begin
            if ((raddr_1_i|raddr_2_i)==0)begin
                rdata_1_o <=    32'h00000000;
                rdata_2_o <=    32'h00000000;
                end
            else begin
                if(raddr_1_i==0)begin
                    rdata_1_o <=    32'h00000000;
                    rdata_2_o <=    register    [raddr_2_i];
                end
                else begin
                    rdata_1_o <=    register    [raddr_1_i];
                    rdata_2_o <=    32'h00000000;
                end
            end

            end     
    end
   
    always_ff @(posedge clk)begin
        
    if(reg_wr_c)begin
        if (waddr_i!=0)
            register [waddr_i] <=  wdata_o;
    end
            
    end
    
    
 
    
endmodule
