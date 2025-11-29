module SE1(
    input  [15:0] imm_in,     // 16-bit immediate
    output [31:0] imm_out     // 32-bit sign-extended output
);
    // Sign extender for immediate values going to ALU
    assign imm_out = {{16{imm_in[15]}}, imm_in};
endmodule

