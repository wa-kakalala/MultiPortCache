/**************************************
@ filename    : tb_channel_arb.sv
@ author      : yyrwkk
@ create time : 2024/07/10 22:05:10
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module tb_channel_arb();
parameter PORTNUM = 16   ;
logic                       i_clk       ;    
logic                       i_rst_n     ;  
logic [PORTNUM-1:0]         i_chann_req ;  
logic                       i_end       ;  
logic [PORTNUM-1:0]         o_chan_resp ;  
logic [PORTNUM-1:0]         o_chan_nresp;  
logic [$clog2(PORTNUM)-1:0] o_chan_sel  ;  
logic                       o_chan_en   ;  
logic                       o_ready     ;  

channel_arb # (
    .PORTNUM  ( 16 )   
)channel_arb_inst(
    .i_clk         (i_clk       ),
    .i_rst_n       (i_rst_n     ),
    .i_chann_req   (i_chann_req ),
    .i_end         (i_end       ),
    .o_chan_resp   (o_chan_resp ),
    .o_chan_nresp  (o_chan_nresp),
    .o_chan_sel    (o_chan_sel  ),
    .o_chan_en     (o_chan_en   ),
    .o_ready       (o_ready     )
);

initial begin
    i_clk       = 'b0;
    i_rst_n     = 'b0;
    i_chann_req = 'b0;
    i_end       = 'b0;
end 

initial begin
    forever #5 i_clk = ~i_clk;
end 

initial begin
    @(posedge i_clk ) ;
    i_rst_n <= 1'b1;
    @(posedge i_clk ) ;
    i_chann_req <= 16'b0000_0000_0000_0011;

    repeat(10) @(posedge i_clk );
    i_end <= 1'b1;
    @(posedge i_clk );
    i_end <= 1'b0;

    repeat(20) @(posedge i_clk );
    $stop;
end

endmodule