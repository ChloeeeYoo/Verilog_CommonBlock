module ShiftWithRound2 #(
  parameter BITWIDTH=16
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-3:0] dout
);
  wire [BITWIDTH-3:0] shifted_value = din[BITWIDTH-1:2];
  wire [BITWIDTH-3:0] rounding = {{(BITWIDTH-3){1'b0}}, din[1]};
  assign dout = shifted_value + rounding;
endmodule

module ShiftWithRound3 #(
  parameter BITWIDTH=16
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-4:0] dout
);
  wire [BITWIDTH-3:0] shifted_value = din[BITWIDTH-1:3];
  wire [BITWIDTH-3:0] rounding = {{(BITWIDTH-4){1'b0}}, din[2]};
  assign dout = shifted_value + rounding;
endmodule

module ShiftWithRound6 #(
  parameter BITWIDTH=16
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-7:0] dout
);
  wire [BITWIDTH-7:0] shifted_value = din[BITWIDTH-1:6];
  wire [BITWIDTH-7:0] rounding = {{(BITWIDTH-7){1'b0}}, din[5]};
  assign dout = shifted_value + rounding;
endmodule

module ShiftWithRound8 #(
  parameter BITWIDTH=16
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-9:0] dout
);
  wire [BITWIDTH-9:0] shifted_value = din[BITWIDTH-1:8];
  wire [BITWIDTH-9:0] rounding = {{(BITWIDTH-9){1'b0}}, din[7]};
  assign dout = shifted_value + rounding; // ignore overflow
endmodule

module ShiftWithRound10 #(
  parameter BITWIDTH=16
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-11:0] dout
);
  wire [BITWIDTH-11:0] shifted_value = din[BITWIDTH-1:10];
  wire [BITWIDTH-11:0] rounding = {{(BITWIDTH-11){1'b0}}, din[9]};
  assign dout = shifted_value + rounding;
endmodule

module ShiftWithRound16 #(
  parameter BITWIDTH=32
)(
  input wire [BITWIDTH-1:0] din,
  output wire [BITWIDTH-1:0] dout
);
  wire [BITWIDTH-17:0] shifted_value = din[BITWIDTH-1:16];
  wire [BITWIDTH-17:0] rounding = {{(BITWIDTH-17){1'b0}}, din[15]};
endmodule

module SignedSaturate #(
	parameter IN_WIDTH=14,
	parameter OUT_WIDTH=10
)(
	input wire [IN_WIDTH-1:0] din,
	output wire [OUT_WIDTH-1:0] dout
);
	assign dout = (&din[IN_WIDTH-1:OUT_WIDTH]) | ~(|din[IN_WIDTH-1:OUT_WIDTH]) ? 
		din[OUT_WIDTH-1:0] : 
		{din[IN_WIDTH-1], {(OUT_WIDTH-1){~din[IN_WIDTH-1]}}};
endmodule

module UnsignedSaturate #(
	parameter IN_WIDTH=14,
	parameter OUT_WIDTH=10
)(
	input wire [IN_WIDTH-1:0] din,
	output wire [OUT_WIDTH-1:0] dout
);
	assign dout = ~(|din[IN_WIDTH-1:OUT_WIDTH]) ? 
		din[OUT_WIDTH-1:0] :
		{(OUT_WIDTH){1'b0}};
endmodule

module UnsignedShiftRound #(
	parameter DWIDTH=16,
	parameter SHIFT=6
)(
	input wire [DWIDTH-1:0] din,
	output wire [DWIDTH-SHIFT-1:0] dout
);
	wire [DWIDTH-SHIFT:0] temp = {1'b0, din[DWIDTH-1:SHIFT]} + {{(DWIDTH-SHIFT){1'b0}}, din[SHIFT-1]};
	assign dout = temp[DWIDTH-SHIFT] ? {(DWIDTH-SHIFT){1'b1}} : temp[DWIDTH-SHIFT-1:0];

endmodule

module SignedRoundSaturate #(
  parameter IN_WLEN=16,
  parameter OUT_WLEN=12,
  parameter IN_FLEN=4
)(
  input wire [IN_WLEN-1:0] din,
  output wire [OUT_WLEN-1:0] dout
);
  // first apply rounding then saturation
  // rounding: IN_WLEN-bit -> (IN_WLEN-IN_FLEN)-bit
  // saturation: (IN_WLEN-IN_FLEN) -> (OUT_WLEN)
  localparam CLIP_LEN = (IN_WLEN-IN_FLEN)-OUT_WLEN;
  generate
    if (CLIP_LEN < 0) begin
      Raise InvalidParameterError();
    end
  endgenerate

  wire rounding;
  wire [IN_WLEN-IN_FLEN:0] y_round;
  generate
  if (IN_FLEN == 0) begin
    assign rounding = 1'b0;
    assign y_round = {din[IN_WLEN-1], din[IN_WLEN-1:IN_FLEN]};
  end
  else if (IN_FLEN == 1) begin
    assign rounding = (din[IN_FLEN] & din[IN_FLEN-1]);
    assign y_round = {din[IN_WLEN-1], din[IN_WLEN-1:IN_FLEN]} + {{(IN_WLEN-IN_FLEN-1){1'b0}}, rounding};
  end
  else begin
    assign rounding = (din[IN_FLEN] & din[IN_FLEN-1] & ~(|din[IN_FLEN-2:0])) | (din[IN_FLEN-1] & (|din[IN_FLEN-2:0]));
    assign y_round = {din[IN_WLEN-1], din[IN_WLEN-1:IN_FLEN]} + {{(IN_WLEN-IN_FLEN-1){1'b0}}, rounding};
  end
  endgenerate

  SignedSaturate #(IN_WLEN-IN_FLEN+1, OUT_WLEN) CLIP (y_round, dout);
endmodule

module UnsignedRoundSaturate #(
  parameter IN_WLEN=16,
  parameter OUT_WLEN=12,
  parameter IN_FLEN=4
)(
  input wire [IN_WLEN-1:0] din,
  output wire [OUT_WLEN-1:0] dout
);
  // first apply rounding then saturation
  // rounding: IN_WLEN-bit -> (IN_WLEN-IN_FLEN)-bit
  // saturation: (IN_WLEN-IN_FLEN) -> (OUT_WLEN)
  localparam CLIP_LEN = (IN_WLEN-IN_FLEN)-OUT_WLEN;
  generate
    if (CLIP_LEN < 0) begin
      Raise InvalidParameterError();
    end
  endgenerate

  wire rounding;
  wire [IN_WLEN-IN_FLEN:0] y_round;
  generate
  if (IN_FLEN == 0) begin
    assign rounding = 1'b0;
    assign y_round = {1'b0, din[IN_WLEN-1:IN_FLEN]};
  end
  else if (IN_FLEN == 1) begin
    assign rounding = (din[IN_FLEN] & din[IN_FLEN-1]);
    assign y_round = {1'b0, din[IN_WLEN-1:IN_FLEN]} + {{(IN_WLEN-IN_FLEN-1){1'b0}}, rounding};
  end
  else begin
    assign rounding = (din[IN_FLEN] & din[IN_FLEN-1] & ~(|din[IN_FLEN-2:0])) | (din[IN_FLEN-1] & (|din[IN_FLEN-2:0]));
    assign y_round = {1'b0, din[IN_WLEN-1:IN_FLEN]} + {{(IN_WLEN-IN_FLEN-1){1'b0}}, rounding};
  end
  endgenerate

  assign dout = (|y_round[IN_WLEN-IN_FLEN:OUT_WLEN]) ? {(OUT_WLEN){1'b1}} : y_round[OUT_WLEN-1:0];
endmodule
