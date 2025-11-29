`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 14:43:01
// Design Name: 
// Module Name: shift
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ALU(input [7:0]opcode, input  [31:0] A, input  [31:0] B, output [31:0] C);
    // Rightmost 3 bits of opcode are func
    wire [31:0] C1,C2,C3,C4;
    add_sub AS(A, B, opcode[2:0], C1);
    logic L(A, B, opcode[2:0], C2);
    compare_set CS(A, B, opcode[2:0], C3);
    shift SS(A, B, opcode[2:0], C4);
    
    wire [31:0] t1,t2;
    
    assign t1 = opcode[3] ? C2 : C1;
    assign t2 = opcode[3] ? C3 : C4;
    
    assign C = opcode[4] ? t2 : t1;
endmodule