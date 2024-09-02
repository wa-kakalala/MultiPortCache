/**************************************
@ filename    : mux16to1en.sv
@ author      : yyrwkk
@ create time : 2024/07/11 13:26:13
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
`include "mpcache.svh"
module mux16to1en (
    input  logic                            i_clk                       ,
    input  logic                            i_rst_n                     ,

    input  logic                            i_en                        ,
    input  logic [$clog2(`IN_PORT_NUM)-1:0] i_sel                       ,

    input  logic [`IN_PORT_NUM-1:0]         i_rd_eop                    ,
    input  logic [`IN_PORT_NUM-1:0]         i_rd_sop                    ,       
    input  logic [`IN_PORT_NUM-1:0]         i_rd_vld                    ,
    input  logic [`DATA_WIDTH-1:0]          i_rd_data [`IN_PORT_NUM-1:0],

    output logic                            o_rd_sop                    ,
    output logic                            o_rd_eop                    ,
    output logic                            o_rd_vld                    ,
    output logic [`DATA_WIDTH-1:0]          o_rd_data                   
);

always_comb begin
    if( !i_rst_n || !i_en ) begin
        o_rd_eop  <= 'b0; 
        o_rd_vld  <= 'b0;
        o_rd_data <= 'b0;
        o_rd_sop  <= 'b0;
    end else begin
        o_rd_sop  <= i_rd_sop [i_sel];
        o_rd_eop  <= i_rd_eop [i_sel];
        o_rd_vld  <= i_rd_vld [i_sel];
        o_rd_data <= i_rd_data[i_sel];
    end
end
endmodule