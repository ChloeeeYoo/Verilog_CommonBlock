module SYNC_RAM(q, d, addr, we, en, clk);
  parameter DWIDTH = 32;           // Data width
  parameter AWIDTH = 14;           // Address width
  parameter DEPTH  = 1 << AWIDTH; // Memory depth
  parameter MIF_HEX = "";
  parameter MIF_BIN = "";
  input  wire              clk;
  input  wire [AWIDTH-1:0] addr; // address
  input  wire              we;   // write-enable
  input  wire              en;   // ram-enable
  input  wire [DWIDTH-1:0] d;    // write data
  output wire [DWIDTH-1:0] q;    // read data
  // (* ram_style = "block" *) reg [DWIDTH-1:0] mem [0:DEPTH-1];
  reg [DWIDTH-1:0] mem [0:DEPTH-1];
  reg [DWIDTH-1:0] read_data_reg;

  initial begin
    if (MIF_BIN != "") begin
      $display("%s", MIF_BIN);
      $readmemb(MIF_BIN, mem, 0, DEPTH-1);
    end
    else if (MIF_HEX != "") begin
      $display("%s", MIF_HEX);
      $readmemh(MIF_HEX, mem, 0, DEPTH-1);
    end
  end

  always @(posedge clk) begin
    if (en) begin
      if (we)
        mem[addr] <= d;
      read_data_reg <= mem[addr];
    end
  end
  assign q = read_data_reg;
endmodule // SYNC_RAM


module SYNC_RAM_DP(q0, d0, addr0, we0, en0, q1, d1, addr1, we1, en1, clk);
  parameter DWIDTH = 8;             // Data width
  parameter AWIDTH = 8;             // Address width
  parameter DEPTH  = (1 << AWIDTH); // Memory depth
  parameter MIF_HEX = "";
  parameter MIF_BIN = "";

  input  wire              clk;
  input  wire [AWIDTH-1:0] addr0, addr1; // address
  input  wire              we0, we1;     // write-enable
  input  wire              en0, en1;     // ram-enable
  input  wire [DWIDTH-1:0] d0, d1;       // write data
  output wire [DWIDTH-1:0] q0, q1;       // read data

  //(* ram_style = "block" *) reg [DWIDTH-1:0] mem [0:DEPTH-1];
  reg [DWIDTH-1:0] mem [0:DEPTH-1];

  integer i;
  initial begin
    if (MIF_HEX != "") begin
      $readmemh(MIF_HEX, mem);
    end
    else if (MIF_BIN != "") begin
      $readmemb(MIF_BIN, mem);
    end
    else begin
      for (i = 0; i < DEPTH; i = i + 1) begin
        mem[i] = 0;
      end
    end
  end

  reg [DWIDTH-1:0] read_data0_reg, read_data1_reg;

  always @(posedge clk) begin
    if (en0) begin
      if (we0)
        mem[addr0] <= d0;
      read_data0_reg <= mem[addr0];
    end
  end

  always @(posedge clk) begin
    if (en1) begin
      if (we1)
        mem[addr1] <= d1;
      read_data1_reg <= mem[addr1];
    end
  end

  assign q0 = read_data0_reg;
  assign q1 = read_data1_reg;

endmodule // SYNC_RAM_DP
