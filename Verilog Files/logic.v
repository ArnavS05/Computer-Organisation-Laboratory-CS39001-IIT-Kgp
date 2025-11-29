module logic(input [31:0] X, input [31:0] Y, input [2:0] func, output [31:0] C);
    wire [31:0] andd,orr,xorr,nott,norr;
    wire [31:0] temp1,temp2,temp3;
    
    //Func[2:0] codes:
    // Not: 100
    // And/Andi: 000
    // Or/Ori: 001
    // Nor/Nori: 010
    // Xor/Xori: 011
    
    assign nott = ~X;
    assign andd = X & Y;
    assign orr = X | Y;
    assign norr = ~orr;
    assign xorr = X ^ Y;
    
    assign temp1 = func[0] ? orr : andd; // muxes
    assign temp2 = func[0] ? xorr : norr;// muxes
    
    assign temp3 = func[1] ? temp2 : temp1;// muxes
    
    assign C = func[2] ? nott : temp3;// muxes
endmodule
