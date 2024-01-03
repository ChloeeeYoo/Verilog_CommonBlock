module DivBlock #(
  parameter XWIDTH = 8,
  parameter DWIDTH = 4 // X = DQ + R
)(
  // unsigned division
  input wire [XWIDTH-1:0] dividend,
  input wire [DWIDTH-1:0] divisor,
  output wire q,
  output wire [XWIDTH-2:0] remainder
);
  localparam QWIDTH = XWIDTH-DWIDTH;
  wire [XWIDTH-1:0] divisor_shft = {1'b0,divisor, {(QWIDTH-1){1'b0}}};
  wire [XWIDTH:0] diff = {1'b0, dividend} - {1'b0, divisor_shft};
  assign q = diff[XWIDTH] ? 1'b0 : 1'b1;
  assign remainder = diff[XWIDTH] ? dividend[XWIDTH-1:0] : diff[XWIDTH-2:0];
endmodule


// example divider
// X; dividend is 8bit, D; divisor is 3bit, Q; quotient is 6bit
module Div_8_3_STAGE6 (
  input wire clk,
  input wire reset,
  input wire [7:0] dividend,
  input wire [2:0] divisor,
  input wire valid_in,
  output wire [5:0] quotient,
  output wire valid_out
);
  wire q_d0, q_q0;
  wire [7:0] remainder_d0, remainder_q0;
  wire [2:0] divisor_q0;
  wire valid_q0;
  DivBlock #(9, 3) DIV0 (
    .dividend({1'b0, dividend}),
    .divisor(divisor),
    .q(q_d0),
    .remainder(remainder_d0)
  );

  PipeReg #(1+8+3+1) PR0 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d0, remainder_d0, divisor, valid_in}),
    .Q({q_q0, remainder_q0, divisor_q0, valid_q0})
  );

  wire [1:0] q_d1, q_q1;
  assign q_d1[1:1] = q_q0;
  wire [6:0] remainder_d1, remainder_q1;
  wire [2:0] divisor_q1;
  wire valid_q1;
  DivBlock #(8, 3) DIV1 (
    .dividend(remainder_q0),
    .divisor(divisor_q0),
    .q(q_d1[0]),
    .remainder(remainder_d1)
  );

  PipeReg #(2+7+3+1) PR1 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d1, remainder_d1, divisor_q0, valid_q0}),
    .Q({q_q1, remainder_q1, divisor_q1, valid_q1})
  );

  wire [2:0] q_d2, q_q2;
  assign q_d2[2:1] = q_q1;
  wire [5:0] remainder_d2, remainder_q2;
  wire [2:0] divisor_q2;
  wire valid_q2;
  DivBlock #(7, 3) DIV2 (
    .dividend(remainder_q1),
    .divisor(divisor_q1),
    .q(q_d2[0]),
    .remainder(remainder_d2)
  );

  PipeReg #(3+6+3+1) PR2 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d2, remainder_d2, divisor_q1, valid_q1}),
    .Q({q_q2, remainder_q2, divisor_q2, valid_q2})
  );

  wire [3:0] q_d3, q_q3;
  assign q_d3[3:1] = q_q2;
  wire [4:0] remainder_d3, remainder_q3;
  wire [2:0] divisor_q3;
  wire valid_q3;
  DivBlock #(6, 3) DIV3 (
    .dividend(remainder_q2),
    .divisor(divisor_q2),
    .q(q_d3[0]),
    .remainder(remainder_d3)
  );

  PipeReg #(4+5+3+1) PR3 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d3, remainder_d3, divisor_q2, valid_q2}),
    .Q({q_q3, remainder_q3, divisor_q3, valid_q3})
  );

  wire [4:0] q_d4, q_q4;
  assign q_d4[4:1] = q_q3;
  wire [3:0] remainder_d4, remainder_q4;
  wire [2:0] divisor_q4;
  wire valid_q4;
  DivBlock #(5, 3) DIV4 (
    .dividend(remainder_q3),
    .divisor(divisor_q3),
    .q(q_d4[0]),
    .remainder(remainder_d4)
  );

  PipeReg #(5+4+3+1) PR4 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d4, remainder_d4, divisor_q3, valid_q3}),
    .Q({q_q4, remainder_q4, divisor_q4, valid_q4})
  );

  wire [5:0] q_d5, q_q5;
  assign q_d5[5:1] = q_q4;
  wire [2:0] remainder_d5, remainder_q5;
  wire [2:0] divisor_q5;
  wire valid_q5;
  DivBlock #(4, 3) DIV5 (
    .dividend(remainder_q4),
    .divisor(divisor_q4),
    .q(q_d5[0]),
    .remainder(remainder_d5)
  );

  PipeReg #(6+3+3+1) PR5 (
    .CLK(clk),
    .RST(reset),
    .EN(1'b1),
    .D({q_d5, remainder_d5, divisor_q4, valid_q4}),
    .Q({q_q5, remainder_q5, divisor_q5, valid_q5})
  );

  assign quotient = q_q5;
  assign valid_out = valid_q5;
endmodule

