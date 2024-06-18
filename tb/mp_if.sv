`ifndef MPCACHE_MP_IF
`define MPCACHE_MP_IF

`include "./mpcache.svh"
interface mp_if(input bit clk,input rst_n_in);

logic [`IN_PORT_NUM-1:0 ] wr_eop                     ;
logic [`IN_PORT_NUM-1:0 ] wr_sop                     ;
logic [`IN_PORT_NUM-1:0 ] wr_vld                     ;
logic [`DATA_WIDTH-1:0  ] wr_data [`IN_PORT_NUM-1:0] ;
logic                     ready                      ;
logic [`IN_PORT_NUM-1:0 ] rd_eop                     ;
logic [`IN_PORT_NUM-1:0 ] rd_sop                     ;
logic [`IN_PORT_NUM-1:0 ] rd_vld                     ;
logic [`DATA_WIDTH-1:0  ] rd_data [`IN_PORT_NUM-1:0] ;
logic                     full                       ;
logic                     almost_full                ;

modport driver(
    output wr_eop,wr_sop,wr_vld,wr_data,
    input  clk
);

modport state (
    output ready,
    input full,almost_full  
);
endinterface //mp_if

`endif