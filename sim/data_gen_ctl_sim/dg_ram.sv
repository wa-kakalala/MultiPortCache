

module dg_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH      = 10
)
(
  input   logic   clk,
  input   logic   rst_n,
  
  /*interface with fifo */
  input    logic   i_fifo_ready,
  output   logic   o_fifo_vld,
  output   logic   [DATA_WIDTH-1: 0]   o_fifo_data      

);

//initial depth
localparam INIT_DEPTH = 'd16;


//memory
localparam  DEPTH = 1 << ADDR_WIDTH ; // 2** ADDR_WIDTH
logic [DATA_WIDTH-1:0] mem [DEPTH-1: 0];

//ptr
logic [ADDR_WIDTH-1:0]  addr;



// initialize the fifo memory
logic [3:0] t_da;
logic [2:0] t_prior;
logic [9:0] t_len;
logic [9:0] t_wait_clk_num;

initial begin: init_mem
  integer i;
  for( i = 0; i < DEPTH; i=i+1 ) begin
      mem[i] =  'b0;
  end

  t_da = 'd0;
  t_prior = 'd0;
  t_len = 'd1;
  t_wait_clk_num = 'd20;

  for( i = 0; i < INIT_DEPTH; i=i+1 ) begin
      t_da = t_da + 'd1;
      t_prior = t_prior + 'd1;
      t_len = t_len + 'd10;
      t_wait_clk_num = t_wait_clk_num + 'd10;
      mem[i] =  { {(DATA_WIDTH-10-10-3-4){1'b0}}, t_wait_clk_num, t_len, t_prior, t_da };
  end
end


always @( posedge clk or negedge rst_n) begin
  if( !rst_n ) begin
      addr <= 'b0;
      o_fifo_data <= 'b0;
      o_fifo_vld  <= 'b0;
  end
  else begin
    if( i_fifo_ready && (addr < INIT_DEPTH) ) begin
        addr <= addr + 1'b1;
        o_fifo_data <= mem[addr];
        o_fifo_vld  <= 1'b1;
    end
    else begin
        addr <= addr;
        o_fifo_data <= mem[addr];
        o_fifo_vld  <= 1'b0;
    end
  end
end 


endmodule
