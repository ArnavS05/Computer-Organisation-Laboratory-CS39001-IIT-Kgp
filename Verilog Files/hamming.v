module popcount2(input [1:0] A, output [1:0] B);
    Half_Adder h0(B[0], B[1], A[0], A[1]);
endmodule

module popcount4(input [3:0] A, output [2:0] B);
    wire [1:0] lo, hi;

    popcount2 p0(A[1:0], lo);
    popcount2 p1(A[3:2], hi);

    RCA #(.N(3)) Add({1'b0, lo}, {1'b0, hi}, 1'b0, B);
endmodule

module popcount8(input [7:0] A, output [3:0] B);
    wire [2:0] lo, hi;

    popcount4 p0(A[3:0], lo);
    popcount4 p1(A[7:4], hi);

    RCA #(.N(4)) Add({1'b0, lo}, {1'b0, hi}, 1'b0, B);
endmodule

module popcount16(input [15:0] A, output [4:0] B);
    wire [3:0] lo, hi;

    popcount8 p0(A[7:0], lo);
    popcount8 p1(A[15:8], hi);

    RCA #(.N(5)) Add({1'b0, lo}, {1'b0, hi}, 1'b0, B);
endmodule


module popcount32(input [31:0] A, output [5:0] B);
    wire [4:0] lo, hi;

    popcount16 p0(A[15:0], lo);
    popcount16 p1(A[31:16], hi);

    RCA #(.N(6)) Add({1'b0, lo}, {1'b0, hi}, 1'b0, B);
endmodule

module hamming(input [31:0] A, output [31:0] B);
    wire [5:0] count;
    popcount32 pc(A, count);
    assign B = {26'b0, count};
endmodule
