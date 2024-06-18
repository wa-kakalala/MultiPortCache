/**************************************
@ filename    : write_sram.sv
@ author      : yyrwkk
@ create time : 2024/05/14 23:15:58
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
`include "./mpcache.svh"
module write_sram (
    input  logic                       i_clk             ,
    input  logic                       i_rst_n           ,

    input  logic [`BLK_ADDR_WIDTH-1:0] i_sram_addr       ,
    input  logic                       i_sram_addr_vld   ,
    input  logic [`DATA_WIDTH-1:0    ] i_fifo_data       ,

    output logic                       o_fifo_ren        ,

    output logic [`BLK_ADDR_WIDTH-1:0] o_sram_addr       ,
    output logic                       o_sram_addr_vld   ,
    output logic [`DATA_WIDTH-1:0    ] o_sram_data       
);

assign o_fifo_ren = i_sram_addr_vld;
assign o_sram_data= i_fifo_data    ;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( ! i_rst_n ) begin
        o_sram_addr    <= 'b0;
        o_sram_addr_vld<= 'b0;
    end else begin
        o_sram_addr    <= i_sram_addr    ;
        o_sram_addr_vld<= i_sram_addr_vld;
    end
end







    
endmodule