module Full_Adder(sum, C_out, A, B, C_in);
    output sum, C_out;
    input A, B, C_in;
    wire sum1, carry1, carry2;
    Half_Adder h1(sum1, carry1, A, B);
    Half_Adder h2(sum, carry2, sum1, C_in);
    or g1(C_out, carry1, carry2);
endmodule