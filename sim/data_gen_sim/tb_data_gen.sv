

/***
author: zfy
version: 
description: 


***/

`timescale  1ns / 1ps

module tb_data_gen;

// data_gen Parameters
parameter PERIOD = 10;
parameter DW  = 32;

// data_gen Inputs
logic   clk                                  = 0 ;
logic   rst_n                                = 0 ;
logic   [3:0]  i_da                          = 0 ;
logic   [2:0]  i_prior                       = 0 ;
logic   [9:0]  i_len                         = 0 ;
logic   i_gen_vld                            = 0 ;

// data_gen Outputs
logic  o_gen_ready                          ;


logic  o_sop                                ;
logic  o_vld                                ;
logic  [DW-1:0]  o_data                     ;
logic  o_eop                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*10) rst_n  =  1;
end


data_gen #(
    .DW ( DW ))
 u_data_gen (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .i_da                    ( i_da         [3:0]    ),
    .i_prior                 ( i_prior      [2:0]    ),
    .i_len                   ( i_len        [9:0]    ),
    .i_gen_vld               ( i_gen_vld             ),

    .o_gen_ready             ( o_gen_ready           ),
    .o_sop                   ( o_sop                 ),
    .o_vld                   ( o_vld                 ),
    .o_data                  ( o_data       [DW-1:0] ),
    .o_eop                   ( o_eop                 )
);

initial
begin
    wait( rst_n);


    wait( o_gen_ready );
    @(posedge clk) begin
        if( o_gen_ready ) begin
            i_gen_vld <= 1'b1;
            i_da <= 'd3;
            i_prior <= 'd1;
            i_len <= 'd1022;
        end
    end


    wait( o_eop );
    #(PERIOD*10);



    $stop;
end

endmodule