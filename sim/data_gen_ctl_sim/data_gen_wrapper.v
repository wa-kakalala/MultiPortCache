

/***
file: data_gen_wrapper.v
author: zfy
version: v10
description: data gen wrapper
***/


module data_gen_wrapper #(
    parameter GEN_INF_W = 32, // data gen information width
    parameter RAM_ADDR_W =10,
    parameter DW     = 32    //data width
)
(
    input   clk,
    input   rst_n,


    input   wire     [RAM_ADDR_W-1:0] fetch_n,

    /* interface of packet out,  */
    output  wire     o_sop,
    output  wire     o_vld,
    output  wire     [DW-1:0] o_data,
    output  wire     o_eop

);


wire                        sram_rden   ;
wire    [RAM_ADDR_W-1:0]    sram_addr   ;
wire    [GEN_INF_W-1:0]     sram_data   ;


wire            dg_ready;
wire    [3:0]   dg_da;
wire    [2:0]   dg_prior;
wire    [9:0]   dg_len;
wire            dg_vld;






dg_ram #(
    .DATA_WIDTH ( GEN_INF_W ),
    .ADDR_WIDTH ( RAM_ADDR_W )
)
 u_dg_ram (
    .clk                              (   clk                               ),
    // .rst_n                            (   rst_n                             ),
    .i_en                             (   sram_rden             ),
    .i_we                             (    1'b0         ),
    .i_addr                           (   sram_addr          ),
    .i_data                           (   'b0          ),
    .o_data                           (   sram_data   )
);




dg_fetch #(
    .DATA_W ( GEN_INF_W ),
    .ADDR_W ( RAM_ADDR_W  ) 
)
 u_dg_fetch (
    .clk                     ( clk            ),
    .rst_n                   ( rst_n          ),

    .fetch_n                (   fetch_n     ),

    /* interface with dg fifo*/
    .i_sram_data            (  sram_data    ),
    .o_sram_addr             ( sram_addr    ),
    .o_sram_rden             ( sram_rden    ),

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



