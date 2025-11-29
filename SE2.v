module SE2(
    input  [15:0] imm_in,     // 16-bit immediate
    output [31:0] imm_out     // 32-bit sign-extended + shifted output
);
    // Sign extender for immediate values going to Load/Store or PC 
    // offset, since all these are addresses and as given, they have to be multiples of 4.
    assign imm_out = {{14{imm_in[15]}}, imm_in, 2'b00};
endmodule
