module top_module_for_load_store(
    input rst,
    input exe,
    input sel, 
    input LS,    // 0: Load, 1: Store
    input [3:0]R1,  // Destination/Source reg
    input [3:0]R2,  // Address reg
    input [5:0]imm,  // immediate offset
    input clk,
    output wire [15:0]LED
    );
    wire [31:0]imm_out;
    SE2 se ( {{10{imm[5]}}, imm}, imm_out );
    reg rw=1'b0;  // Read: 0, Write: 1
    wire [31:0]r1_out;
    wire [31:0]r2_out;
    wire [31:0]data;
    reg_bank RR(R2,R1,R1,rw, data,rst, r1_out, r2_out);
    
    reg [1:0]state = 3'd0;
    reg mem_rst = 1'b0;
    reg mem_en = 1'b0;
    reg [3:0]mem_w_en = 4'h0;
    wire [31:0] addr;
    mem_offset_adder MOD(r1_out, imm_out, addr);
    // Since word size is 4 bytes, we will remove right 2 bits and add two sign bits on left
    blk_mem_gen_0 memory(  
        .clka(clk),
        .rsta(mem_rst),
        .ena(mem_en),
        .wea(mem_w_en),
        .addra(addr),    // Since we are addressing words
        .dina(r2_out),
        .douta(data)
    );
                        
                        
    
    //FSM
    always @(posedge exe) begin
        state <= 2'd0;
        mem_w_en <= 4'h0;
    end
    always @(posedge clk) begin
        if (rst) begin  // Since synchronous reset
            state<=2'd0;
            mem_rst<=1'b1;
            mem_w_en <= 4'h0;
        end
        if (exe && state==2'b00) begin
            state <= 2'd1;
            mem_rst<=1'b0;
        end
        else if (state==2'd1) begin
            rw<=1'b0;
            state <= 2'd2;
        end
        else if (state==2'd2) begin
            mem_en <= 1'b1;
            if (LS==1'b1) begin
                mem_w_en<=4'b1111;
            end
            state <= 2'd3;
        end
        else if (state==2'd3) begin
            mem_w_en=4'h0;
            mem_en <= 1'b0;
            if(LS == 1'b0) begin
                rw <= 1'b1;
            end
        end
    end
    
    wire [15:0]x1,x2;
    assign x1 = LS ? r2_out[15:0] : data[15:0]; 
    assign x2 = LS ? r2_out[31:16] : data[31:16]; 
    assign LED = sel ? x2 : x1;
endmodule
