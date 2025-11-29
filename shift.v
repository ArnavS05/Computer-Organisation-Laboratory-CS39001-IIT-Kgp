module shift(input [31:0] X, input [31:0] Y, input [2:0] func, output [31:0] C);
    wire [31:0] SL,SRL,SRA,LUI,HAM;
    wire [31:0] temp1,temp2,temp3;
    
    //Func[2:0] codes:
    // SL/SLI: 100
    // SRL/SRLI: 000
    // SRA/SRAI: 001
    // LUI: 010
    // HAM: 011
    
    assign SL = X<<Y;
    assign SRL = X>>Y;
    assign SRA = X>>>Y;
    assign LUI = Y<<16;
    hamming h(X, HAM);
    
    assign temp1 = func[0] ? SRA : SRL; // muxes
    assign temp2 = func[0] ? HAM : LUI;// muxes
    
    assign temp3 = func[1] ? temp2 : temp1;// muxes
    
    assign C = func[2] ? SL : temp3;// muxes
endmodule