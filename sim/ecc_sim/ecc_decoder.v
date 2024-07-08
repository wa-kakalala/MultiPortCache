

/***
file: ecc_decoder.v
author: zfy
version: v20
description: ecc decoder  

***/

module ecc_decoder #(
    parameter DATA_W = 32,
    parameter CODE_W = 6
)
(
    input i_clk,
    input i_rst_n,

    input wire [DATA_W-1:0] i_data,
    input wire [CODE_W-1:0] i_code,
    input wire i_vld,

    output reg [DATA_W-1:0] o_corrected_data,
    output reg o_vld,
    output reg o_error_detected

);

// declare
    wire [DATA_W-1:0] corrected_data;
    wire              error_detected;



//instantiate hamming decoder32
    hamming_decoder26  u_hamming_decoder (
        .data                 ( i_data          ),
        .code                    ( i_code          ),

        .corrected_data          ( corrected_data   ),
        .error_detected          ( error_detected   )
    );


//output
    always @(posedge i_clk or negedge i_rst_n) begin
        if( !i_rst_n ) begin
            o_corrected_data  <= 'b0;
            o_error_detected  <= 'b0;
            o_vld             <= 'b0;
        end
        else begin
            o_corrected_data  <= corrected_data;
            o_error_detected  <= error_detected;
            o_vld             <= 'b1;
        end
    end


endmodule