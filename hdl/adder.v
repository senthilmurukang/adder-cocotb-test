// Adder DUT
`timescale 1ns/1ps

module adder(
    input [3:0] A,
    input [3:0] B,
    output [3:0] sum,
    output carry
);
    assign sum = A + B;
    assign carry = (A[3] & B[3]) | (A[3] & ~sum[3]) | (B[3] & ~sum[3]);
endmodule