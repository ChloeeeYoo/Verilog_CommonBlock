module MULT(
	input	wire	[15:0]	a,
	input	wire	[15:0]	b,
  output	wire	[15:0]	z    // quantization to 16 bit
);
  
	wire	[31:0]	a_sign_ex,b_sign_ex,RES;
	assign	a_sign_ex = {{16{a[15]}},a};
	assign	b_sign_ex = {{16{b[15]}},b};
	assign	RES = a_sign_ex*b_sign_ex;
  assign	z = RES[25:10];     // fraction bit: 10 bit
endmodule
