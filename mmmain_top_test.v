`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.10.2025 15:29:56
// Design Name: 
// Module Name: mmmain_top_test
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


module mmmain_top_test();
    reg clk=1'b0;
    reg rst=1'b1;
    reg sel = 1'b0;
    wire [15:0] led;
    always begin
        #10 clk = ~clk;
    end
    initial begin
        rst = 1'b1;
        #100;
        rst = 1'b0;
    end
    mmmain_top MM(clk, rst, sel,led);
endmodule
