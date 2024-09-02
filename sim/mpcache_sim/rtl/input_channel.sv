/**************************************
@ filename    : port_channel.sv
@ author      : yyrwkk
@ create time : 2024/05/14 22:42:02
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
`include "./mpcache.svh"
module input_channel(
    input  logic                       i_clk           ,
    input  logic                       i_rst_n         ,

    input  logic                       i_sop           ,
    input  logic                       i_wr_vld        ,
    input  logic [`DATA_WIDTH-1:0    ] i_wr_data       ,
    input  logic                       i_eop           ,

    input  logic                       i_blk_addr_vld  ,
    input  logic [`BLK_ADDR_WIDTH-1:0] i_blk_addr      ,

    output logic                       o_sop           ,
    output logic [`DA_WIDTH-1:0      ] o_da            ,
    output logic [`PRORITY_WIDTH-1:0 ] o_prority       ,
    output logic                       o_hdr_vld       ,
    output logic [`BLK_ADDR_WIDTH-1:0] o_blk_addr      ,
    output logic                       o_blk_addr_vld  ,
    output logic                       o_eop           ,
    
    output logic [`BLK_ADDR_WIDTH-1:0] o_sram_addr     ,
    output logic                       o_sram_w_vld    ,
    output logic [`DATA_WIDTH-1:0    ] o_sram_data     ,
    
    output logic                       o_addr_req      ,
    output logic                       o_packet_end 
);

logic fifo_full              ;
logic [`DATA_WIDTH-1:0] crc  ;
// nc
logic fifo_almost_full_nc    ;
logic fifo_empty_nc          ;
logic fifo_almost_empty_nc   ;

logic [`BLK_ADDR_WIDTH-1:0] sram_addr     ;
logic                       sram_addr_vld ;
logic [`DATA_WIDTH-1:0    ] fifo_data     ;
logic                       fifo_ren      ;

crc32_d32 crc32_d32_inst (
    .i_clk    (i_clk    ),
    .i_rst_n  (i_rst_n  ),

    .i_d      (i_wr_data),
    .i_d_vld  (i_wr_vld ),
    .i_clr    (i_sop    ),

    .o_crc    (crc      )
);


input_fifo  #(
    .DATA_WIDTH   (32)    ,
    .ADDR_WIDTH   (10)    ,
    .FWFT_EN      (1'b0)   // First_n word fall-through without latency
)input_fifo_inst(
  .din         ( i_wr_vld ? i_wr_data: crc ),
  .wr_en       (i_wr_vld| i_eop            ),
  .full        (fifo_full                  ),
  .almost_full (fifo_almost_full_nc        ),

  .dout        (fifo_data                  ),
  .rd_en       (fifo_ren                   ),
  .empty       (fifo_empty_nc              ),
  .almost_empty(fifo_almost_empty_nc       ),

  .clk         (i_clk                      ),
  .rst_n       (i_rst_n                    )
);

input_ctrl input_ctrl_inst(
    .i_clk           (i_clk         ),
    .i_rst_n         (i_rst_n       ),
  
    .i_blk_addr_vld  (i_blk_addr_vld),
    .i_blk_addr      (i_blk_addr    ),
   
    .i_sop           (i_sop         ),
    .i_wr_vld        (i_wr_vld      ),
    .i_wr_data       (i_wr_data     ),
    .i_eop           (i_eop         ),
  
    .o_sop           (o_sop         ),
    .o_da            (o_da          ),
    .o_prority       (o_prority     ),
    .o_hdr_vld       (o_hdr_vld     ),
    .o_blk_addr      (o_blk_addr    ),
    .o_blk_addr_vld  (o_blk_addr_vld),
    .o_eop           (o_eop         ),
  
    .o_sram_addr     (sram_addr     ),
    .o_sram_addr_vld (sram_addr_vld ),

    .o_addr_req      (o_addr_req    ),
    .o_packet_end    (o_packet_end  )
);

write_sram write_sram_inst (
    .i_clk             (i_clk          ),
    .i_rst_n           (i_rst_n        ),

    .i_sram_addr       (sram_addr      ),
    .i_sram_addr_vld   (sram_addr_vld  ),
    .i_fifo_data       (fifo_data      ),

    .o_fifo_ren        (fifo_ren       ),

    .o_sram_addr       (o_sram_addr    ),
    .o_sram_w_vld      (o_sram_w_vld   ),
    .o_sram_data       (o_sram_data    )
);


endmodule