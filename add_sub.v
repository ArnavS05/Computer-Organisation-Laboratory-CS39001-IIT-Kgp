module add_sub(input [31:0] X, input [31:0] Y, input [2:0] func, output [31:0] C);
    // func[0] decides 1 or Y
    // func[1] decides addition or subt
    
    //Func[2:0] codes:
    // Add/Addi: 010
    // Sub/Subi: 011
    // Inc: 000
    // Dec: 001
    wire [31:0] y_in;
    assign y_in = func[1] ? Y : 32'b1;  // choose inc-dec or add-sub
    
    wire [31:0] out1,out2;
    
    RCA add(X, y_in, 1'b0, out1);
    RCA subt(X, y_in, 1'b1, out2);
    
    assign C = func[0] ? out2 : out1;   // choose add-inc or sub-dec 
endmodule