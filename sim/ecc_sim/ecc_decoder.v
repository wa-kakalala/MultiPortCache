

/***
file: ecc_decoder.v
author: zfy
version: v10
description: ecc decoder  

***/

module ecc_decoder #(
    parameter DATA_W = 32,
    parameter CODE_W = 6
)
(
    input clk,
    input reset,

    input wire [DATA_W-1:0] in_data,
    input wire [CODE_W-1:0] in_code,
    input wire in_vld,

    output wire [DATA_W-1:0] corrected_data,
    output wire error_detected,
    output wire out_vld

);

// declare
    wire [CODE_W-1:0] hamming_code;



//instantiate hamming decoder32
    hamming_decoder26  u_hamming_decoder (
        .data                 ( in_data          ),
        .code                    ( in_code          ),

        .corrected_data          ( corrected_data   ),
        .error_detected          ( error_detected   )
    );



//output
    assign out_vld = in_vld;


endmodule