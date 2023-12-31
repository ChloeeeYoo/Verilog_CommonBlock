
module REG	#(parameter	BITWIDTH = 1) (
	input	wire						CLK,
	input	wire						RST,
	input	wire						EN,
	input	wire	[BITWIDTH-1 : 0]	D,
	output	reg		[BITWIDTH-1 : 0]	Q
);

	always @ (posedge CLK)		// synchronous
	begin 
		if (RST)		Q <= 0; 
		else if (EN)	Q <= D;
	end

endmodule

// NEGATIVE LEVEL-SENSITIVE LATCH (NO RST, NO WE)
module LatchN #(parameter	BITWIDTH = 1) (
	input	wire				CLK, 
	input	wire	[BITWIDTH-1 : 0]	D, 
	output	reg	[BITWIDTH-1 : 0]	Q 
);


	always @ (CLK or D)	// asynchronous
	begin 
		if (~CLK) Q <= D;
	end

endmodule

module	LatchN_gate(
	input	wire	CLK,
	input	wire	D,
	output	wire	Q
);

	wire	tempD;
	wire	tempE;
	wire	Qbar;

	assign	tempD	= ~(D&(~CLK));
	assign	tempE	= ~(tempD&(~CLK));
	assign	Q	= ~(tempD&Qbar);
	assign	Qbar	= ~(tempE&Q);

endmodule

// NEGATIVE EDGE-TRIGGERED FLIPFLOP (NO RST, NO WE)
module SyncRegN #(parameter	BITWIDTH = 1) (
	input	wire						CLK, 
	input	wire	[BITWIDTH-1 : 0]	D, 
	output	reg		[BITWIDTH-1 : 0]	Q 
);

	always @ (negedge CLK)
	begin 
		Q <= D;
	end

endmodule

// POSITIVE EDGE-TRIGGERED FLIPFLOP (SET, NO WE)
module PipeRegS #(parameter  BITWIDTH = 1) (
	input   wire                        CLK,
	input   wire                        SET,
	input	wire						EN,
	input   wire    [BITWIDTH-1 : 0]    D,
	output  reg     [BITWIDTH-1 : 0]    Q
);

	always @ (posedge CLK)
	begin   
		if (SET)		Q <= {BITWIDTH{1'b1}}; 
		else if (EN)	Q <= D; 
	end

endmodule

// POSITIVE EDGE-TRIGGERED FLIPFLOP (RST, WE)
module PipeReg #(parameter	BITWIDTH = 1) (
	input	wire						CLK,
	input	wire						RST,
	input	wire						EN,
	input	wire	[BITWIDTH-1 : 0]	D,
	output	reg		[BITWIDTH-1 : 0]	Q
);

	always @ (posedge CLK)
	begin 
		if (RST)		Q <= {BITWIDTH{1'b0}}; 
		else if (EN)	Q <= D;
	end

endmodule

