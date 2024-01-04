module onehot_en #(
  parameter OUT_WIDTH = 16,
  parameter IN_WIDTH = $clog2(OUT_WIDTH)

)(
  input wire [IN_WIDTH-1:0] din,
  output reg [OUT_WIDTH-1:0] dout       // define the register

);
  always @(*) begin
    dout = 0;    // initialization
    for (integer i=0; i < OUT_WIDTH; i = i+1) begin
      if (din == i)
        dout <= (1 << i);
    end
  end
endmodule
      
