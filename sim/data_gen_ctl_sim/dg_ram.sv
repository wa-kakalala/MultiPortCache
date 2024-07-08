

module dg_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH      = 10
)
(
  input   logic   clk,
  input   logic   rst_n,
  
  /*interface */
  input    logic   i_en,
  input    logic   i_we, // 'b1: write    'b0: read
  input    logic   [ADDR_WIDTH-1:0]    i_addr,
  input    logic   [DATA_WIDTH-1: 0]   i_data,
  output   logic   [DATA_WIDTH-1: 0]   o_data
);


//memory
localparam  DEPTH = 1 << ADDR_WIDTH ; // 2** ADDR_WIDTH
logic [DATA_WIDTH-1:0] mem [DEPTH-1: 0];





// initialize the fifo memory
logic [3:0] t_da;
logic [2:0] t_prior;
logic [9:0] t_len;
logic [9:0] t_wait_clk_num;

initial begin
    integer i;
    for( i = 0; i < DEPTH; i=i+1 ) begin
        mem[i] =  'b0;
    end
    
    mem[0]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd64, 3'd6, 4'd1 };
    mem[1]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd1023, 3'd7, 4'd6 };
    mem[2]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd64, 3'd2, 4'd8 };
    mem[3]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd1023, 3'd1, 4'd10 };
    mem[4]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd944, 3'd6, 4'd1 };
    mem[5]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd495, 3'd6, 4'd11 };
    mem[6]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd242, 3'd7, 4'd8 };
    mem[7]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd531, 3'd2, 4'd11 };
    mem[8]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd109, 3'd6, 4'd14 };
    mem[9]= {{(DATA_WIDTH-'d27){1'b0}}, 10'd0, 10'd263, 3'd2, 4'd7 };
end


always @( posedge clk or negedge rst_n) begin
  if( !rst_n ) begin
      o_data <= 'b0;
  end
  else begin
    if( i_en ) begin
        if( i_we ) 
            mem[i_addr] <= i_data;
        else
            o_data <= mem[i_addr];
    end
  end
end



endmodule
