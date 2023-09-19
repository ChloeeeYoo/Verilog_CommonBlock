module RegisterFile #(
  parameter AWIDTH = 5,
  parameter DWIDTH = 16
)(
  input wire clk,
  input wire wr_en,
  input wire [AWIDTH-1:0] wr_addr,
  input wire [AWIDTH-1:0] rd_addr,
  input wire [DWIDTH-1:0] wr_data,
  output wire [DWIDTH-1:0] rd_data
);
  reg [DWIDTH-1:0] reg_file [0:2**AWIDTH-1];

  always @(posedge clk) begin
    if (wr_en) begin
      reg_file[wr_addr] <= wr_data;
    end
  end

  assign rd_data = reg_file[rd_addr];
  
endmodule
