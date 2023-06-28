//localparam XLEN = 32;

module data_mem(
    output logic    [31:0]  data_o, 
    input  logic    [31:0]  data_i,
    input  logic    [31:0]  addr_i,

    input  logic    [2:0]   mask_c,
    input  logic            rd_wr_c,
    input  logic            cs_c
    );

    reg     [31:0]  ROM    [16];
    logic   [31:0]  data,data1;
    initial $readmemh("/home/muhammad-hamza/Desktop/CA/data.mem", ROM);

    always_comb begin
        if (cs_c == 1'b0 && rd_wr_c == 1'b1) begin
            data = ROM[addr_i]; 
            case(mask_c)
                3'b000: begin
                    data_o = data[31:0]; 
                end
                3'b001: begin
                    data_o = data[15:0];
                end
                3'b010: begin
                    data_o = data[7:0];
                end
                3'b100: begin
                    data_o = $unsigned(data[15:0]);
                end
                3'b101: begin
                    data_o = $unsigned(data[7:0]);
                end
            endcase
        end

        if (cs_c == 1'b0 && rd_wr_c == 1'b0) begin
            data1 = data_i;
            case(mask_c)
                3'b000: begin
                    ROM[addr_i] = data1[31:0];
                end
                3'b001: begin
                    ROM[addr_i] = {{16{data1[15]}},data1[15:0]};
                end
                3'b010: begin
                    ROM[addr_i] = {{24{data1[7]}},data1[7:0]};
                end
            endcase
        end
    end
endmodule
