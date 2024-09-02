/**************************************
@ filename    : channel_arb.sv
@ author      : yyrwkk
@ create time : 2024/07/10 21:40:20
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module channel_arb # (
    parameter PORTNUM = 16   
)(
    input  logic                       i_clk         ,
    input  logic                       i_rst_n       ,
    input  logic [PORTNUM-1:0]         i_chann_req   ,
    input  logic                       i_end         ,
    
    output logic [PORTNUM-1:0]         o_chan_resp   ,
    output logic [PORTNUM-1:0]         o_chan_nresp  ,

    output logic [$clog2(PORTNUM)-1:0] o_chan_sel    ,
    output logic                       o_chan_en     ,

    output logic                       o_ready   
);

// ready signal 
always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( ! i_rst_n ) begin
        o_ready <= 'b1;
    end else begin
        if( o_ready && (|i_chann_req))  begin
            o_ready <= 1'b0;
        end else if( i_end ) begin
            o_ready <= 1'b1;
        end else begin
            o_ready <= o_ready;
        end
    end
end

logic [$clog2(PORTNUM)-1:0] chan_sel     ;
logic                       chan_sel_vld ;

prior16_encode # (
    .TARGET ( 1'b1 )   
) prior16_encode_inst (
    .i_data   (i_chann_req ),
    .i_rst_n  (i_rst_n     ),
    .o_d_vld  (chan_sel_vld),
    .o_sel    (chan_sel    )
);

// select demux signal 
always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( ! i_rst_n ) begin
        o_chan_sel <= 'b0 ;
        o_chan_en  <= 1'b0;
    end else if( o_ready && (|i_chann_req) ) begin
        o_chan_sel <= chan_sel;
        o_chan_en  <= chan_sel_vld;
    end else if( i_end ) begin
        o_chan_sel <= 'b0;
        o_chan_en  <= 'b0;
    end else begin
        o_chan_sel <= o_chan_sel;
        o_chan_en  <= o_chan_en ;
    end
end

// give out resp 
always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( ! i_rst_n ) begin
        o_chan_resp  <= 'b0;
        o_chan_nresp <= 'b0;
    end else if( o_ready && (|i_chann_req) ) begin
        o_chan_resp  <= 'b1 << (chan_sel);
        o_chan_nresp <= ~('b1 << (chan_sel));
    end else begin
        o_chan_resp  <= 'b0;
        o_chan_nresp <= 'b0;
    end
end

endmodule