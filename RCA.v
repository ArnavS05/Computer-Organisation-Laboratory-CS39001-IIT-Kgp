module RCA#(parameter N=32) (input  [N-1:0] A, input  [N-1:0] B, input  sub, output [N-1:0] sum);
  // sub=0 for add, sub=1 for subtract
  wire [N-1:0] B_xor;       // B XOR (for subtraction)
  wire [N-1:0] carry;

  genvar i;
  generate
    for (i = 0; i < N; i = i + 1) begin : bit_adder
      assign B_xor[i] = B[i] ^ sub;

      if (i == 0) begin
        Full_Adder FA (sum[i], carry[i], A[i], B_xor[i], sub);
      end else begin
        Full_Adder FA (sum[i], carry[i], A[i], B_xor[i], carry[i-1]);
      end
    end
  endgenerate
endmodule