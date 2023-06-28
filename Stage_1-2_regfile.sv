module pipeline_stage_1(
    input logic             clk,
    input logic             flush_s1,reset,
    input logic     [31:0]  instr_s1_i,
    input logic     [31:0]  pc_s1_i,
    output logic    [31:0]  instr_s1_o,
    output logic    [31:0]  pc_s1_o
);
//no effect on control unit
logic   [31:0]  temp,temp1;

//assign pc_s1_o=temp;


always_ff @(negedge clk)begin
    if(~reset)begin
        /*if(pc_s1_i!=(pc_s1_o+4))begin
            instr_s1_o<=32'h13;
            pc_s1_o<=pc_s1_i;
        end
        else*/
        begin
            pc_s1_o<=pc_s1_i;
            instr_s1_o<=instr_s1_i;
        end
    
    end
end
endmodule