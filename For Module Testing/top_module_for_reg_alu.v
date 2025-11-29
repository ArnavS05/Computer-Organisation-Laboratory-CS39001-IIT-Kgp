`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.10.2025 15:12:31
// Design Name: 
// Module Name: top_module_for_reg_alu
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


module top_module_for_reg_alu(
input [3:0] rx,
input[3:0] ry,
input[3:0]rz,
input [2:0]opc,
input clk, sel,
output reg[15:0] LED
);
    reg [7:0]full_opc;
    reg [31:0] w_in;
    wire [31:0]r1_out;
    wire [31:0]r2_out;
    wire [31:0]alu_out;
    reg_bank RR(ry,rz,rx,clk, alu_out,1'b0, r1_out, r2_out);
    // rw is clk because wewill use half cycle to read, other half to write
    ALU aa(full_opc, r1_out, r2_out, alu_out);
    always @(opc) begin
        case(opc)
            3'd0: full_opc = 8'b0000010;  //ADD
            3'd1: full_opc = 8'b0000011;  //SUB
            3'd2: full_opc = 8'b0001000;  //AND
            3'd3: full_opc = 8'b0001010;  //NOR
            3'd4: full_opc = 8'b0010100;  //SL
            3'd5: full_opc = 8'b0010001;  //SRA
            3'd6: full_opc = 8'b0011000;  //SLT
            3'd7: full_opc = 8'b0011001;  //SGT
        endcase
    end
    always @(sel or alu_out) begin
        if(sel) LED = alu_out[15:0];
        else LED = alu_out[31:16];
    end
endmodule
