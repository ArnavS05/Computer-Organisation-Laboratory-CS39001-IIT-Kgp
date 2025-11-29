module compare(input [31:0] A, input [31:0] B, output eq, output gt, output lt);
    reg eqr, gtr, ltr;
    always @(*) begin
        if(A<B) begin
            eqr <= 0;
            gtr <= 0;
            ltr <= 1;
        end
        if(A>B) begin
            eqr <= 0;
            ltr <= 0;
            gtr <= 1;
        end
        if(A==B) begin
            eqr <= 1;
            ltr <= 0;
            gtr <= 0;
        end
    end
    assign eq = eqr;
    assign lt = ltr;
    assign gt = gtr;
endmodule