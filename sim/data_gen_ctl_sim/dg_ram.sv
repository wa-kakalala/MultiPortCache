

module dg_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH      = 10,
    parameter ID             = 0
)
(
  input   logic   clk,
  // input   logic   rst_n, // if rst_n set, synthesis will get lut rather than sram 
  
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
    // initialize 0 
    for( i = 0; i < DEPTH; i=i+1 ) begin
        mem[i] =  'b0;
    end

    case(ID)
      0: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat0.dat",  mem);  end
      1: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat1.dat",  mem);  end
      2: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat2.dat",  mem);  end
      3: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat3.dat",  mem);  end
      4: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat4.dat",  mem);  end
      5: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat5.dat",  mem);  end
      6: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat6.dat",  mem);  end
      7: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat7.dat",  mem);  end
      8: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat8.dat",  mem);  end
      9: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat9.dat",  mem);  end
      10: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat10.dat",  mem);  end
      11: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat11.dat",  mem);  end
      12: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat12.dat",  mem);  end
      13: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat13.dat",  mem);  end
      14: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat14.dat",  mem);  end
      15: begin    $readmemh("D:\\Desktop\\data_gen_data\\dat15.dat",  mem);  end
    endcase 
    // read file
    $readmemh("",  mem);

end


always @( posedge clk ) begin
  // if( !rst_n ) begin
  //     o_data <= 'b0;
  // end
  // else begin
    if( i_en ) begin
        if( i_we ) 
            mem[i_addr] <= i_data;
        else
            o_data <= mem[i_addr];
    end
  // end
end



endmodule
