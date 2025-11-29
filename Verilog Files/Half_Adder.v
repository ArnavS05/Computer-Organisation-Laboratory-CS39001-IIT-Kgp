module Half_Adder(sum, C, A, B);
    output sum, C;
    input A, B;
    and g1(C, A, B);
    xor g2(sum, A, B);
endmodule
