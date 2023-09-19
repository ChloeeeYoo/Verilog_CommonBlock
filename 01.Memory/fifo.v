module sync_fifo #(
  parameter FIFO_SIZE = 8,
  parameter FIFO_SIZE_LG2 = $clog2(FIFO_SIZE),
  parameter DWIDTH = 32
)(
  input wire CLK,
  input wire RST,
  // write
  output wire FULL,
  output wire ALMOST_FULL,
  input wire WR_EN,
  input wire [DWIDTH-1:0] WR_DATA,
  // read
  output wire EMPTY,
  output wire ALMOST_EMPTY,
  input wire RD_EN,
  output wire [DWIDTH-1:0] RD_DATA
);

//internals
reg [DWIDTH-1:0] mem[0:FIFO_SIZE-1];

reg [FIFO_SIZE_LG2:0] write_ptr;
reg [FIFO_SIZE_LG2:0] read_ptr;

wire [FIFO_SIZE_LG2:0] write_ptr_next = (write_ptr[FIFO_SIZE_LG2-1:0] == (FIFO_SIZE-1)) ? {~(write_ptr[FIFO_SIZE_LG2]), {(FIFO_SIZE_LG2){1'b0}}} : (write_ptr + 1);
wire [FIFO_SIZE_LG2:0] read_ptr_next = (read_ptr[FIFO_SIZE_LG2-1:0] == (FIFO_SIZE-1)) ? {~(read_ptr[FIFO_SIZE_LG2]), {(FIFO_SIZE_LG2){1'b0}}} : (read_ptr+1);

int i;
always @ (posedge CLK) begin
  if (RST) begin
    // for (i=0; i<FIFO_SIZE; i++)
    //   mem[i] <= 0;
    write_ptr <= 0;
    read_ptr <= 0;
  end else begin
    
    if (WR_EN && !FULL) begin
      mem[write_ptr[FIFO_SIZE_LG2-1:0]] <= WR_DATA;
      write_ptr <= write_ptr_next;
      // write_ptr <= write_ptr + 1;
      
      // if(write_ptr[FIFO_SIZE_LG2-1:0] == (FIFO_SIZE-1)) begin
      //   write_ptr[FIFO_SIZE_LG2-1:0] <= 0;
      // end

    end
    if(RD_EN && !EMPTY) begin
      read_ptr <= read_ptr_next;
      // read_ptr <= read_ptr + 1;

      // if(read_ptr[FIFO_SIZE_LG2-1:0] == (FIFO_SIZE-1)) begin
      //   read_ptr[FIFO_SIZE_LG2-1:0] <= 0;
      // end
    end

  end
end


assign RD_DATA = mem[read_ptr[FIFO_SIZE_LG2-1:0]];

assign EMPTY = (write_ptr == read_ptr);
assign FULL = (write_ptr[FIFO_SIZE_LG2-1:0] == read_ptr[FIFO_SIZE_LG2-1:0]) & (write_ptr[FIFO_SIZE_LG2] != read_ptr[FIFO_SIZE_LG2]);

assign ALMOST_EMPTY = (write_ptr == read_ptr_next);
assign ALMOST_FULL = (write_ptr_next[FIFO_SIZE_LG2-1:0] == read_ptr[FIFO_SIZE_LG2-1:0]) & (write_ptr_next[FIFO_SIZE_LG2] != read_ptr[FIFO_SIZE_LG2]);

endmodule
