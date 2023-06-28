//localparam XLEN = 32;

module writeback(
    output logic    [31:0]  mux_o,

    input  logic    [31:0]  PC_i,
    input  logic    [31:0]  alu_i,
    input  logic    [31:0]  rdata_i,

    input  logic    [1:0]   wb_sel_c
    );
    always_comb begin
        case(wb_sel_c)
            2'b00: mux_o = rdata_i;
            2'b01: mux_o = alu_i;
            2'b10: mux_o = PC_i+4;
            default:mux_o=32'bx;        
        endcase
    end
endmodule
