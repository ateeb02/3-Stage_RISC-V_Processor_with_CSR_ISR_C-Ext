//localparam XLEN = 32;

module processor_main(
    input  logic                clk,
    input  logic                reset,
    output logic                rando
    );
    
    logic           [31:0]      pc;
    logic           [31:0]      pc_incr;
    logic           [31:0]      instruction;

    logic           [31:0]      rdata_1;
    logic           [31:0]      rdata_2;

    logic           [6:0]       opcode;
    logic           [6:0]       funct7;
    logic           [2:0]       funct3;
    logic           [4:0]       rs1;
    logic           [4:0]       rs2;
    logic           [4:0]       rd;
    logic           [11:0]      imm;
    logic           [19:0]      u_imm;

    logic           [31:0]      alu_imm;

    logic           [3:0]       alu_op_e;
    logic                       reg_wr_e;
    logic                       sel_a_e;
    logic                       sel_b_e;
    logic           [1:0]       wb_sel_e;
    logic           [2:0]       br_type_e;

    logic           [2:0]       mask_e;
    logic                       rd_wr_e;
    logic                       cs_e;
    
    logic                       br_taken_e;

    logic           [31:0]      alu_in_a;
    logic           [31:0]      alu_in_b;

    logic           [31:0]      alu_out;

    logic           [31:0]      data_out;

    logic           [31:0]      wb_out;

    //pipeline stage 1
    logic     [31:0]  instr_s1_e;
    logic     [31:0]  pc_s1_e;

    //pipeline stage 2
    logic     [31:0]  pc_s2_o;
    logic     [31:0]  alu_s2_o;
    logic     [4:0]   rd_s2_o;
    //controller 
    logic             reg_wr_o;
    logic             wr_en_o;
    logic             rd_en_o;
    logic     [1:0]   wb_sel_o; 
    //stalling unit

    logic      [1:0]    forward;  
    logic               flush_s1,stall_s1,stall_s2;
    logic      [31:0]   alu_in_a_mux,alu_in_b_mux;




    always_comb begin
    	if(reset)
    		pc_incr=0;
    	else begin		
    		
    	case (br_taken_e)
            		1'b0: pc_incr = pc+4;
            		1'b1: pc_incr = alu_out;
        endcase
    	     end
    	end

//forwarding mux
    always_comb begin
               
        case (forward[1])
            1'b0: alu_in_a_mux = rdata_1;
            1'b1: alu_in_a_mux = alu_s2_o;
        endcase
        
        
        case (forward[0])
            1'b0: alu_in_b_mux = rdata_2;
            1'b1: alu_in_b_mux = alu_s2_o;
        endcase
        
         
        case (sel_a_e)
            1'b0: alu_in_a = alu_in_a_mux;//rdata_1; 
            1'b1: alu_in_a = pc_s1_e;
        endcase
        
        
        case (sel_b_e)
            1'b0: alu_in_b = alu_in_b_mux;//rdata_2;
            1'b1: alu_in_b = alu_imm;
        endcase
        
    end   


    
    PC PC(pc, pc_incr, alu_out, br_taken_e, clk, reset);

    inst_mem inst_mem(instruction, pc);
    //stage 1
    pipeline_stage_1 pipeline_stage_1(clk,
    flush_s1,reset,//stall bit
    instruction,pc,instr_s1_e,pc_s1_e);

    decoder decoder(opcode, funct7, funct3, rs1, rs2, rd, imm, u_imm, instr_s1_e);

    reg_file reg_file(rdata_1, rdata_2, wb_out, rs1, rs2, rd_s2_o, reg_wr_o, clk, reset);

    imm_gen imm_gen(alu_imm, opcode, imm, u_imm);

    control control(alu_op_e, reg_wr_e, sel_a_e,
                    sel_b_e, rd_wr_e, mask_e, 
                    wb_sel_e, br_type_e, cs_e, 
                    opcode, funct7, funct3);

    stall_unit stalling(rd_s2_o,rs1,rs2,reg_wr_o,br_taken_e,opcode,
                flush_s1,   //flushing
                stall_s1,stall_s2,forward);

    ALU ALU(alu_in_a, alu_in_b, alu_op_e, alu_out);
    br_check br_check1(br_taken_e, alu_in_a_mux, alu_in_b_mux, br_type_e);
    logic wr_en_i;
    //stage 2
    pipeline_stage_2 pipeline_stage_2(clk,
    reset,//stall bit
    pc_s1_e,alu_out,rd,
    //controller inputs
    reg_wr_e,wr_en_i,rd_wr_e,wb_sel_e,  
    //outputs  
    pc_s2_o,alu_s2_o,rd_s2_o,
    //controller outputs
    reg_wr_o,wr_en_o,rd_en_o,wb_sel_o);   

    data_mem data_mem1(data_out, rdata_2, alu_s2_o, mask_e, rd_en_o, cs_e);

    writeback writeback1(wb_out, pc_s2_o, alu_s2_o, data_out, wb_sel_o);
    assign rando =sel_a_e;
endmodule

