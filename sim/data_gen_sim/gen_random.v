
/***
author: zfy
version: 
description: 


***/

module gen_rand #(
    parameter   DW = 32,
    parameter   RW = 32
)
(  
    input               rst_n,    /*rst_n is necessary to prevet locking up*/  
    input               clk,      /*clock signal*/  
    input               i_load,     /*load seed to rand_num,active high */  
    input      [RW-1:0]    i_seed,       
    output     [DW-1:0]    o_rand_data  /*random number output*/  
);  
    
    localparam RBN = DW/8; //number of generated gen_rand_byte module 

    wire [7:0] rand_byte[RBN-1:0]; 


    genvar d;


    generate
        for( d=0; d < RBN; d = d+1 ) begin: generate_gen_rand_bytes
            gen_random_byte #(
                .RW ( RW )
                )
            u_gen_random_byte (
                .rst_n                   ( rst_n         ),
                .clk                     ( clk           ),
                .i_load                  ( i_load        ),
                .i_seed                  ( i_seed + d       ),

                .o_rand_byte             ( rand_byte[d]   )
            );
        end
    endgenerate


    generate
        for( d=0; d < RBN; d = d+1 ) begin: generate_o_rand_data
            assign o_rand_data[(d*8)+ :8] = rand_byte[d];
        end
    endgenerate


endmodule 