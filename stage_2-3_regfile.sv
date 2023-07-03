module pipeline_stage_2(
    input logic             clk,
    input logic             reset,             
    input logic     [31:0]  pc_s2_i,
    input logic     [31:0]  alu_s2_i,
    input logic     [4:0]   rd_s2_i,
    //controller inputs
    input logic             reg_wr_i,
    input logic             cs_i,
    input logic             rd_en_i,
    input logic     [1:0]   wb_sel_i,    


    output logic    [31:0]  pc_s2_o,
    output logic    [31:0]  alu_s2_o,
    output logic    [4:0]   rd_s2_o,
    //controller outputs
    output logic            reg_wr_o,
    output logic            cs_o,
    output logic            rd_en_o,
    output logic    [1:0]   wb_sel_o      

);
logic halo,holo;
assign halo=1'b0;
always_ff @(posedge clk)begin
    if (reset)begin 
        holo<= ~halo;
    end

    else begin

        pc_s2_o<=pc_s2_i;
        
        rd_s2_o<=rd_s2_i;
        //control signals
        
        cs_o<=cs_i;
        rd_en_o<=rd_en_i;
        wb_sel_o<=wb_sel_i;
    end

end
always_ff @(negedge clk ) begin
    reg_wr_o<=reg_wr_i;
    alu_s2_o<=alu_s2_i;    
end


endmodule