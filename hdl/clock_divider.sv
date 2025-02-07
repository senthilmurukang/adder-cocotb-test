module clock_divider(
    input  logic clk,
    input  logic rst,
    input logic [15:0] highCount,
    input logic [15:0] lowCount,
    input logic [15:0] delayCount,
    output logic divClk,
    output logic preRise,
    output logic preFall
);
   ClockDivider clock_divider (
      .clk(clk),
      .rst(rst),
      .highCount(highCount),
      .lowCount(lowCount),
      .delayCount(delayCount),
      .divClk(divClk),
      .preRise(preRise),
      .preFall(preFall));
endmodule