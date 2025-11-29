module compare_set(input [31:0] X, input [31:0] Y, input [2:0] func, output [31:0] C);
    wire eq,gt,lt;
    
    //Func[2:0] codes:
    // SLT/SLTI: 000
    // SGT/SGTI: 001
    
    compare c1(.A(X),.B(Y),.eq(eq),.gt(gt),.lt(lt));
    wire temp1;
    assign temp1 = func[0] ? gt : lt;
    
    assign C = temp1 ? 1 : 0;
endmodule
