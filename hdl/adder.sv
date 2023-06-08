// Adder DUT
`timescale 1ns/1ps

module adder(
    input logic [3:0] A,
    input logic [3:0] B,
    output logic [3:0] sum,
    output logic carry
  );
  assign sum = A + B;
  assign carry = (A[3] & B[3]) | (A[3] & ~sum[3]) | (B[3] & ~sum[3]);
endmodule
