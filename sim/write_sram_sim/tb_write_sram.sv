/**************************************
@ filename    : tb_write_sram.sv
@ author      : yyrwkk
@ create time : 2024/05/15 00:06:38
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
`include "mpcache.svh"
module tb_write_sram();

logic                       i_clk           ;
logic                       i_rst_n         ;
logic [`DATA_WIDTH-1:0    ] i_fifo_data     ;
logic                       i_fifo_wen      ;
logic [`BLK_ADDR_WIDTH-1:0] i_sram_addr     ;
logic                       i_sram_addr_vld ;

// don't drvier
logic [`BLK_ADDR_WIDTH-1:0] o_sram_addr       ;
logic                       o_sram_addr_vld   ;
logic [`DATA_WIDTH-1:0    ] o_sram_data       ;
logic [`DATA_WIDTH-1:0    ] fifo_data         ;
logic                       fifo_ren          ;


write_sram write_sram_inst (
    .i_clk             (i_clk        ),
    .i_rst_n           (i_rst_n      ),

    .i_sram_addr       (i_sram_addr    ),
    .i_sram_addr_vld   (i_sram_addr_vld),
    .i_fifo_data       (fifo_data    ),

    .o_fifo_ren        (fifo_ren     ),

    .o_sram_addr       (             ),
    .o_sram_addr_vld   (             ),
    .o_sram_data       (             )
);

input_fifo  #(
    .DATA_WIDTH   (32)    ,
    .ADDR_WIDTH   (10)    ,
    .FWFT_EN      (1'b0)   // First_n word fall-through without latency
)input_fifo_inst(
  .din         ( i_fifo_data      ),
  .wr_en       ( i_fifo_wen       ),
  .full        (                  ),
  .almost_full (        ),

  .dout        (fifo_data           ),
  .rd_en       (fifo_ren            ),
  .empty       (       ),
  .almost_empty(),

  .clk         (i_clk               ),
  .rst_n       (i_rst_n             )
);


initial begin
    i_clk           <= 'b0;
    i_rst_n         <= 'b0;
    i_fifo_data     <= 'b0;
    i_fifo_wen      <= 'b0;
    i_sram_addr     <= 'b0;
    i_sram_addr_vld <= 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk );
    i_rst_n <= 1'b1;
    @(posedge i_clk );
    for( int i=0;i<32;i++) begin
        i_fifo_data <= i+1;
        i_fifo_wen  <= 1'b1;
        @(posedge i_clk );
    end
    i_fifo_data <= 'b0;
    i_fifo_wen  <= 1'b0;
    @(posedge i_clk );
    for( int i=0;i<32;i++) begin
        i_sram_addr <= i;
        i_sram_addr_vld  <= 1'b1;
        @(posedge i_clk );
    end
    i_sram_addr      <= 'b0;
    i_sram_addr_vld  <= 1'b0;
    @(posedge i_clk );
    repeat(5) @(posedge i_clk);
    $stop();
end

endmodule