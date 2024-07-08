

/***
file: ecc_encoder.v
author: zfy
version: v10
description: ecc encoder  

***/

module ecc_encoder #(
    parameter DATA_W = 32,
    parameter CODE_W = 6
)
(
    input clk,
    input reset,

    input wire [DATA_W-1:0] in_data,
    input wire in_vld,

    output wire [CODE_W-1:0] code,
    output wire out_vld

);

// declare
    wire [CODE_W-1:0] hamming_code;



//instantiate hamming encoder32
    hamming_encoder26  u_hamming_encoder (
        .data                    ( in_data           ),

        .code                    (  hamming_code          )
    );


//output
    assign out_vld = in_vld;
    assign code = hamming_code;


endmodule