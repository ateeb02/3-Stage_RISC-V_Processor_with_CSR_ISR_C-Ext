//localparam XLEN = 32;

module reg_file(
    output logic    [31:0]  rdata_1_o,
    output logic    [31:0]  rdata_2_o,

    input  logic    [31:0]  wdata_o,
    input  logic    [4:0]   raddr_1_i,
    input  logic    [4:0]   raddr_2_i,
    input  logic    [4:0]   waddr_i,
    input  logic            reg_wr_c,
    input  logic            clk,
    input  logic            reset
    );

    logic     [31:0]  register    [32];
   
	always_ff @(posedge clk)begin
		if (reg_wr_c) 
			register[waddr_i] = wdata_o;
		
	end
	assign rdata_1_o = (raddr_1_i != 0) ? register[raddr_1_i] : 0;
	assign rdata_2_o = (raddr_2_i != 0) ? register[raddr_2_i] : 0;
 


    
endmodule
