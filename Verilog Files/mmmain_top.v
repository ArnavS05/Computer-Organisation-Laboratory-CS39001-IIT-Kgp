`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.10.2025 14:50:49
// Design Name: 
// Module Name: mmmain_top
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


module mmmain_top(
input clk, rst, sel,
output [15:0] LED
);  
     // LED handling
     reg [31:0]full_LED;

     //   all control signals
     wire halt;               // for halt
     wire branch_imm;         // branching instr
     wire imm;               // from opcode, imm or not
     wire [7:0] opcode;
     wire [1:0] choose_al_mem_mov;  //00: alu, 01:cmov/mov , 10: mem
     assign choose_al_mem_mov = opcode[6:5];
//     wire pc_en;
//     wire ir_en;
     reg rw=1'b0;
     reg endd=1'b0;
     reg mem_rst = 1'b0;
     reg mem_en;     // Used for Load/Store
     reg [3:0]mem_w_en;     // Used for Store
     
    wire [31:0]Alu_out;
    wire [31:0]r1_out,r2_out;
    reg clk2=1'b0;
    wire clk1;
    assign clk1=clk2;
    
    always @(posedge clk) clk2 <= ~clk2;

    // regs used as intermediates
    reg [31:0]PC;
    wire [31:0]IR;
    wire [3:0]R1,R2,R3;
    wire [31:0] imm_val;
    assign opcode = IR[31:24];
    assign R1 = IR[23:20];
    assign R2 = IR[19:16];
    assign R3 = IR[15:12];
    
    SE1 imm_extend(IR[15:0],imm_val);   // sign_extended
    
    // elements
    instr_cache I1(.clka(clk1),   //1            // instruction mem intatntiation
        .addra(PC),
        .douta(IR)
    );
    wire [3:0]sel_arg2;
    assign sel_arg2 = imm ? R1 : R3;   //2
    wire [31:0]w_in;
    reg_bank RR(R2,sel_arg2,R1,rw, w_in, rst, r1_out, r2_out); // needs check #####
    
    wire [31:0]sel_imm_R;
    assign sel_imm_R = imm ? imm_val : r2_out;  //3
    ALU main_alu(opcode, r1_out, sel_imm_R, Alu_out);
    
    compare C(r1_out,r2_out,eq,gt,lt);
    // checking if last bit of opcode is 1 to decide bw move and cmov
    wire [31:0]cmp_out;
    assign cmp_out = (lt | (opcode[0]==0)) ? r1_out : r2_out;
    
    
    wire [31:0]imm_mem;
    SE2 imm_extend_mem(IR[15:0], imm_mem); 
    wire [31:0] addr;
    mem_offset_adder MOD(r1_out, imm_mem, addr);
    wire [31:0] data;   //Output from memory
    blk_mem_gen_0 data_cache(  
        .clka(clk1),
        .rsta(mem_rst),
        .ena(mem_en),
        .wea(mem_w_en),
        .addra(addr),    // Since we are addressing words
        .dina(r2_out),
        .douta(data)
    );
    
    wire [31:0] t1;
    assign t1 = choose_al_mem_mov[0] ? cmp_out : Alu_out;
    assign w_in = choose_al_mem_mov[1] ? data : t1;
    
    // PC wala part
    wire [31:0]tt1,tt2;
    assign tt1 = branch_imm ? imm_mem : 32'd4;
    assign tt2 = halt ? 32'd0 : tt1; 
    
    wire [31:0]pc_new;     // new pc_value to be used later
    RCA pc_adder(PC,tt2,1'b0,pc_new);
    
    
    // Control Unit
    assign imm = opcode[7];
    branching bb(opcode, r1_out, branch_imm);
    assign halt = (opcode[6:3]==4'b1111);
    
    
    reg [2:0]state = 3'b0;
    
    always @(posedge clk1) begin
        if (rst) begin
            PC <= 32'b0;
            rw <= 1'b0;
            state <= 2'b0;
            endd <= 1'b0;
            mem_w_en <= 4'h0;
            mem_en <= 1'b0;
        end
        else begin
            if (endd == 1'b1) begin
                state <= 2'b0;
                endd <= 1'b0;
                rw <= 1'b0;
                PC <= pc_new;
                mem_w_en <= 4'h0;
                mem_en <= 1'b0;
            end
            else begin    
                if (state==2'd0) begin
                    state <= state+1;      // Waiting for instruction to be read
                end
                else if (state==2'd1) begin
                    if (opcode[6:4] == 3'b111) begin   // NOP or HALT
                        endd <= 1'b1;
                    end
                    else if (opcode[6:3] == 4'b0101) begin   // Branching
                        endd <= 1'b1;
                    end
                    // Do nothing in case of ALU type or MOVE/CMOV instructions
                    else if (opcode[6:3] == 4'b1000) begin   // Load/Store
                        mem_en <= 1'b1;
                        if (opcode[0]==1'b1) begin
                            mem_w_en <= 4'b1111;    // Store
                            full_LED <= r2_out;       // To display whatever is stored
                        end
                    end
                    state <= state+1;
                end
                else if (state==2'd2) begin
                    // Waiting more memory operations
                    state <= state+1;
                end
                else if (state==2'd3) begin
                    if (opcode[6:0]!= 7'b1000001) rw <= 1'b1;   // Write to Reg file if not store
                    state <= state+1;
                    endd <= 1'b1;
                end
            end
        end
    end
    
    assign LED = sel ? full_LED[31:16] : full_LED[15:0];
    
endmodule
