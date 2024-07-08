

/***
file: data_gen_wrapper.v
author: zfy
version: v10
description: data gen wrapper
***/


module data_gen_wrapper #(
    parameter GEN_INF_W = 32, // data gen information width
    parameter FIFO_ADDR_W = 5,
    parameter RAM_ADDR_W =5,
    parameter DW     = 32    //data width
)
(
    input   clk,
    input   rst_n,

    /* interface of packet out,  */
    output  wire     o_sop,
    output  wire     o_vld,
    output  wire     [DW-1:0] o_data,
    output  wire     o_eop

);

wire    fifo_full;
wire    fifo_wr_ready;
wire    fifo_wren   ;
wire    [GEN_INF_W-1:0]  fifo_wr_data;

wire    fifo_empty;
wire    fifo_rd_ready;
wire    fifo_rden   ;
wire    [GEN_INF_W-1:0]  fifo_rd_data;

wire            dg_ready;
wire    [3:0]   dg_da;
wire    [2:0]   dg_prior;
wire    [9:0]   dg_len;
wire            dg_vld;



assign  fifo_rd_ready = !fifo_empty;
assign  fifo_wr_ready = !fifo_full;


dg_ram #(
    .DATA_WIDTH ( GEN_INF_W ),
    .ADDR_WIDTH ( RAM_ADDR_W ))
 u_dg_ram (
    .clk                              (   clk                               ),
    .rst_n                            (   rst_n                             ),
    .i_fifo_ready                     (   fifo_wr_ready                      ),

    .o_fifo_vld                       (   fifo_wren                        ),
    .o_fifo_data                      (   fifo_wr_data   )
);


dg_fifo #(
    .DATA_WIDTH ( GEN_INF_W ),
    .ADDR_WIDTH ( FIFO_ADDR_W ),
    .FWFT_EN    ( 1  ))
 u_dg_fifo (
    .clk           ( clk            ),
    .rst_n         ( rst_n          ),

    .din           ( fifo_wr_data            ),
    .wr_en         ( fifo_wren          ),
    .rd_en         ( fifo_rden          ),
    .dout          ( fifo_rd_data           ),

    .full          ( fifo_full           ),
    .almost_full   (            ),
    .empty         ( fifo_empty     ),
    .almost_empty  (    )
);


dg_fetch #(
    .FIFO_W ( GEN_INF_W ))
 u_dg_fetch (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),

    /* interface with dg fifo*/
    .i_fifo_ready            ( fifo_rd_ready   ),
    .i_fifo_data             ( fifo_rd_data    ),
    .o_fifo_rden             ( fifo_rden    ),

    /* interface with dg*/
    .i_dg_ready              ( dg_ready     ),
    .o_da                    ( dg_da           ),
    .o_prior                 ( dg_prior        ),
    .o_len                   ( dg_len          ),
    .o_vld                   ( dg_vld          )
);



data_gen #(
    .DW ( DW ))
 u_data_gen (
    .clk                     ( clk           ),
    .rst_n                   ( rst_n         ),
    
    /* interface of packet header information input,  */
    .i_da                    ( dg_da          ),
    .i_prior                 ( dg_prior       ),
    .i_len                   ( dg_len         ),
    .i_gen_vld               ( dg_vld     ),

    /* interface of control  */
    .o_gen_ready             ( dg_ready   ),

    /* send data */
    .o_sop                   ( o_sop         ),
    .o_vld                   ( o_vld         ),
    .o_data                  ( o_data        ),
    .o_eop                   ( o_eop         )
);

endmodule



