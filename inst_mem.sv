//localparam XLEN = 32;

module inst_mem(
    output logic    [31:0]  instr_o, 
    input  logic    [31:0]  addr_i
    );

    reg     [7:0]   RAM    [64];
    initial $readmemh("/home/muhammad-hamza/Desktop/CA/instruction.mem", RAM);

    always_comb 
        begin
        instr_o = {
            RAM[addr_i+0],
            RAM[addr_i+1],
            RAM[addr_i+2],
            RAM[addr_i+3]
            };
        end

endmodule
