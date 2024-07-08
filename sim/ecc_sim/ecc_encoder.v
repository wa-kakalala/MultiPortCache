

/***
file: ecc_encoder.v
author: zfy
version: v20
description: ecc encoder  

***/

module ecc_encoder #(
    parameter DATA_W = 32,
    parameter CODE_W = 6
)
(
    input i_clk,
    input i_rst_n,

    input wire [DATA_W-1:0] i_data,
    input wire i_vld,

    output reg [DATA_W-1:0] o_data,
    output reg [CODE_W-1:0] o_code,
    output reg o_vld

);

// declare
    wire [CODE_W-1:0] ecc_code;



//instantiate hamming encoder32
    hamming_encoder26  u_hamming_encoder (
        .data                    ( i_data           ),

        .code                    (  ecc_code          )
    );


//output
    always @(posedge i_clk or negedge i_rst_n) begin
        if( !i_rst_n ) begin
            o_data <= 'b0;
            o_code  <= 'b0;
            o_vld   <= 'b0;
        end
        else begin
            o_data <= i_data;
            o_code  <= ecc_code;
            o_vld   <= i_vld;
        end
    end

endmodule