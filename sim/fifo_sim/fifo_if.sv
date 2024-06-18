interface fifo_if#(
    parameter DATA_WIDTH    = 8 ,
    parameter ADDR_WIDTH    = 4 
)(input logic clk);

logic [DATA_WIDTH-1:0] din         ;   // input
logic                  wr_en       ;   // input
logic                  full        ;   // output
logic                  almost_full ;   // output

logic [DATA_WIDTH-1:0] dout        ;   // output
logic                  rd_en       ;   // input
logic                  empty       ;   // output
logic                  almost_empty;   // output

logic                  rst_n       ;   // input
    
endinterface //fifo_if(input logic clk_in)