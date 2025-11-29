module reg_bank(
input [3:0]r1,
input [3:0]r2,
input [3:0]r3,
input rw,  // bit decides read(0) or write(1)
input [31:0]w_in,
input reset,
output [31:0]r1_out, 
output [31:0]r2_out
);
    reg [31:0] out1, out2;
integer bank[15:0];
    initial begin
        bank[0]  = 0;   //R0 is 0
        
        // Random hardcoding
        bank[1]  = 4;
        bank[2]  = 8;
        bank[3]  = 12;
        bank[4]  = 16;
        bank[5]  = 20;
        bank[6]  = 24;
        bank[7]  = 28;
        bank[8]  = 32;
        bank[9]  = 36;
        bank[10] = 40;
        bank[11] = 44;
        bank[12] = 48;
        bank[13] = 52;
        bank[14] = 56;
        bank[15] = 60;
    end
    always @(r1 or r2 or r3 or w_in or rw) begin
        if(rw== 1'b0) begin
            out1 <= bank[r1];
            out2 <= bank[r2];
        end
        else begin
            bank[r3] <= w_in;
        end
    end
    
//    always @(reset) begin
//         bank[0]  = 0;   //R0 is 0
        
//        // Random hardcoding
//        bank[1]  = 4;
//        bank[2]  = 8;
//        bank[3]  = 12;
//        bank[4]  = 16;
//        bank[5]  = 20;
//        bank[6]  = 24;
//        bank[7]  = 28;
//        bank[8]  = 32;
//        bank[9]  = 36;
//        bank[10] = 40;
//        bank[11] = 44;
//        bank[12] = 48;
//        bank[13] = 52;
//        bank[14] = 56;
//        bank[15] = 60;
//    end   
    assign r1_out = out1;
    assign r2_out = out2;
endmodule

