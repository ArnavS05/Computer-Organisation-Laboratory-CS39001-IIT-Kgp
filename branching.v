module branching(input [7:0]opcode, input [31:0] data, output result);
    wire eq, gt, lt;
    compare C(data, 32'b0, eq, gt, lt);
    assign result = (opcode[6:3]==4'b0101) & ((opcode[2:0]==3'b000) | ((opcode[2:0]==3'b001) & (lt)) | ((opcode[2:0]==3'b010) & (gt)) | ((opcode[2:0]==3'b011) & (eq)));
endmodule
