module mem_offset_adder(
    input [31:0] A,
    input [31:0] B,
    output [31:0] addr
);
    // Adding given offset to given reg's value
    RCA add(A, B, 1'b0, addr);  
endmodule
