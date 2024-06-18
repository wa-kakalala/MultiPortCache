/**************************************
@ filename    : crc32_d32.sv
@ author      : yyrwkk
@ create time : 2024/05/07 23:09:11
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 1999-2008 Easics NV.
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
//
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//
// Purpose : synthesizable CRC function
//   * polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
//   * data width: 32
//
// Info : tools@easics.be
//        http://www.easics.com
////////////////////////////////////////////////////////////////////////////////
module crc32_d32 (
    input  logic          i_clk    ,
    input  logic          i_rst_n  ,

    input  logic [31:0]   i_d      ,
    input  logic          i_d_vld  ,
    input  logic          i_clr    ,

    output logic [31:0]   o_crc
);

logic [31:0] crc_reg;
// polynomial: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x^1 + 1
// data width: 32
// convention: the first serial bit is i_d[31]

always_ff @( posedge i_clk or negedge i_rst_n ) begin : crc32
    if( !i_rst_n )  begin
        crc_reg <= {32{1'b1}};
    end else if( i_clr ) begin
        crc_reg <= {32{1'b1}};
    end else if(i_d_vld) begin
        crc_reg[0] <= i_d[31] ^ i_d[30] ^ i_d[29] ^ i_d[28] ^ i_d[26] ^ i_d[25] ^ i_d[24] ^ i_d[16] ^ i_d[12] ^ i_d[10] ^ i_d[9] ^ i_d[6] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[12] ^ crc_reg[16] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31];
        crc_reg[1] <= i_d[28] ^ i_d[27] ^ i_d[24] ^ i_d[17] ^ i_d[16] ^ i_d[13] ^ i_d[12] ^ i_d[11] ^ i_d[9] ^ i_d[7] ^ i_d[6] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[24] ^ crc_reg[27] ^ crc_reg[28];
        crc_reg[2] <= i_d[31] ^ i_d[30] ^ i_d[26] ^ i_d[24] ^ i_d[18] ^ i_d[17] ^ i_d[16] ^ i_d[14] ^ i_d[13] ^ i_d[9] ^ i_d[8] ^ i_d[7] ^ i_d[6] ^ i_d[2] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[30] ^ crc_reg[31];
        crc_reg[3] <= i_d[31] ^ i_d[27] ^ i_d[25] ^ i_d[19] ^ i_d[18] ^ i_d[17] ^ i_d[15] ^ i_d[14] ^ i_d[10] ^ i_d[9] ^ i_d[8] ^ i_d[7] ^ i_d[3] ^ i_d[2] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[31];
        crc_reg[4] <= i_d[31] ^ i_d[30] ^ i_d[29] ^ i_d[25] ^ i_d[24] ^ i_d[20] ^ i_d[19] ^ i_d[18] ^ i_d[15] ^ i_d[12] ^ i_d[11] ^ i_d[8] ^ i_d[6] ^ i_d[4] ^ i_d[3] ^ i_d[2] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[15] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31];
        crc_reg[5] <= i_d[29] ^ i_d[28] ^ i_d[24] ^ i_d[21] ^ i_d[20] ^ i_d[19] ^ i_d[13] ^ i_d[10] ^ i_d[7] ^ i_d[6] ^ i_d[5] ^ i_d[4] ^ i_d[3] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[13] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[28] ^ crc_reg[29];
        crc_reg[6] <= i_d[30] ^ i_d[29] ^ i_d[25] ^ i_d[22] ^ i_d[21] ^ i_d[20] ^ i_d[14] ^ i_d[11] ^ i_d[8] ^ i_d[7] ^ i_d[6] ^ i_d[5] ^ i_d[4] ^ i_d[2] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[14] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[29] ^ crc_reg[30];
        crc_reg[7] <= i_d[29] ^ i_d[28] ^ i_d[25] ^ i_d[24] ^ i_d[23] ^ i_d[22] ^ i_d[21] ^ i_d[16] ^ i_d[15] ^ i_d[10] ^ i_d[8] ^ i_d[7] ^ i_d[5] ^ i_d[3] ^ i_d[2] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[28] ^ crc_reg[29];
        crc_reg[8] <= i_d[31] ^ i_d[28] ^ i_d[23] ^ i_d[22] ^ i_d[17] ^ i_d[12] ^ i_d[11] ^ i_d[10] ^ i_d[8] ^ i_d[4] ^ i_d[3] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[17] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[28] ^ crc_reg[31];
        crc_reg[9] <= i_d[29] ^ i_d[24] ^ i_d[23] ^ i_d[18] ^ i_d[13] ^ i_d[12] ^ i_d[11] ^ i_d[9] ^ i_d[5] ^ i_d[4] ^ i_d[2] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[18] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[29];
        crc_reg[10] <= i_d[31] ^ i_d[29] ^ i_d[28] ^ i_d[26] ^ i_d[19] ^ i_d[16] ^ i_d[14] ^ i_d[13] ^ i_d[9] ^ i_d[5] ^ i_d[3] ^ i_d[2] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[19] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[11] <= i_d[31] ^ i_d[28] ^ i_d[27] ^ i_d[26] ^ i_d[25] ^ i_d[24] ^ i_d[20] ^ i_d[17] ^ i_d[16] ^ i_d[15] ^ i_d[14] ^ i_d[12] ^ i_d[9] ^ i_d[4] ^ i_d[3] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[9] ^ crc_reg[12] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[20] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[31];
        crc_reg[12] <= i_d[31] ^ i_d[30] ^ i_d[27] ^ i_d[24] ^ i_d[21] ^ i_d[18] ^ i_d[17] ^ i_d[15] ^ i_d[13] ^ i_d[12] ^ i_d[9] ^ i_d[6] ^ i_d[5] ^ i_d[4] ^ i_d[2] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[27] ^ crc_reg[30] ^ crc_reg[31];
        crc_reg[13] <= i_d[31] ^ i_d[28] ^ i_d[25] ^ i_d[22] ^ i_d[19] ^ i_d[18] ^ i_d[16] ^ i_d[14] ^ i_d[13] ^ i_d[10] ^ i_d[7] ^ i_d[6] ^ i_d[5] ^ i_d[3] ^ i_d[2] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[22] ^ crc_reg[25] ^ crc_reg[28] ^ crc_reg[31];
        crc_reg[14] <= i_d[29] ^ i_d[26] ^ i_d[23] ^ i_d[20] ^ i_d[19] ^ i_d[17] ^ i_d[15] ^ i_d[14] ^ i_d[11] ^ i_d[8] ^ i_d[7] ^ i_d[6] ^ i_d[4] ^ i_d[3] ^ i_d[2] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[23] ^ crc_reg[26] ^ crc_reg[29];
        crc_reg[15] <= i_d[30] ^ i_d[27] ^ i_d[24] ^ i_d[21] ^ i_d[20] ^ i_d[18] ^ i_d[16] ^ i_d[15] ^ i_d[12] ^ i_d[9] ^ i_d[8] ^ i_d[7] ^ i_d[5] ^ i_d[4] ^ i_d[3] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[12] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[18] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[24] ^ crc_reg[27] ^ crc_reg[30];
        crc_reg[16] <= i_d[30] ^ i_d[29] ^ i_d[26] ^ i_d[24] ^ i_d[22] ^ i_d[21] ^ i_d[19] ^ i_d[17] ^ i_d[13] ^ i_d[12] ^ i_d[8] ^ i_d[5] ^ i_d[4] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[8] ^ crc_reg[12] ^ crc_reg[13] ^ crc_reg[17] ^ crc_reg[19] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[29] ^ crc_reg[30];
        crc_reg[17] <= i_d[31] ^ i_d[30] ^ i_d[27] ^ i_d[25] ^ i_d[23] ^ i_d[22] ^ i_d[20] ^ i_d[18] ^ i_d[14] ^ i_d[13] ^ i_d[9] ^ i_d[6] ^ i_d[5] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[14] ^ crc_reg[18] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[30] ^ crc_reg[31];
        crc_reg[18] <= i_d[31] ^ i_d[28] ^ i_d[26] ^ i_d[24] ^ i_d[23] ^ i_d[21] ^ i_d[19] ^ i_d[15] ^ i_d[14] ^ i_d[10] ^ i_d[7] ^ i_d[6] ^ i_d[2] ^ crc_reg[2] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[14] ^ crc_reg[15] ^ crc_reg[19] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[31];
        crc_reg[19] <= i_d[29] ^ i_d[27] ^ i_d[25] ^ i_d[24] ^ i_d[22] ^ i_d[20] ^ i_d[16] ^ i_d[15] ^ i_d[11] ^ i_d[8] ^ i_d[7] ^ i_d[3] ^ crc_reg[3] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[29];
        crc_reg[20] <= i_d[30] ^ i_d[28] ^ i_d[26] ^ i_d[25] ^ i_d[23] ^ i_d[21] ^ i_d[17] ^ i_d[16] ^ i_d[12] ^ i_d[9] ^ i_d[8] ^ i_d[4] ^ crc_reg[4] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[12] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[30];
        crc_reg[21] <= i_d[31] ^ i_d[29] ^ i_d[27] ^ i_d[26] ^ i_d[24] ^ i_d[22] ^ i_d[18] ^ i_d[17] ^ i_d[13] ^ i_d[10] ^ i_d[9] ^ i_d[5] ^ crc_reg[5] ^ crc_reg[9] ^ crc_reg[10] ^ crc_reg[13] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[22] <= i_d[31] ^ i_d[29] ^ i_d[27] ^ i_d[26] ^ i_d[24] ^ i_d[23] ^ i_d[19] ^ i_d[18] ^ i_d[16] ^ i_d[14] ^ i_d[12] ^ i_d[11] ^ i_d[9] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[12] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[23] <= i_d[31] ^ i_d[29] ^ i_d[27] ^ i_d[26] ^ i_d[20] ^ i_d[19] ^ i_d[17] ^ i_d[16] ^ i_d[15] ^ i_d[13] ^ i_d[9] ^ i_d[6] ^ i_d[1] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[6] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[15] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[24] <= i_d[30] ^ i_d[28] ^ i_d[27] ^ i_d[21] ^ i_d[20] ^ i_d[18] ^ i_d[17] ^ i_d[16] ^ i_d[14] ^ i_d[10] ^ i_d[7] ^ i_d[2] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[7] ^ crc_reg[10] ^ crc_reg[14] ^ crc_reg[16] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30];
        crc_reg[25] <= i_d[31] ^ i_d[29] ^ i_d[28] ^ i_d[22] ^ i_d[21] ^ i_d[19] ^ i_d[18] ^ i_d[17] ^ i_d[15] ^ i_d[11] ^ i_d[8] ^ i_d[3] ^ i_d[2] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[8] ^ crc_reg[11] ^ crc_reg[15] ^ crc_reg[17] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[26] <= i_d[31] ^ i_d[28] ^ i_d[26] ^ i_d[25] ^ i_d[24] ^ i_d[23] ^ i_d[22] ^ i_d[20] ^ i_d[19] ^ i_d[18] ^ i_d[10] ^ i_d[6] ^ i_d[4] ^ i_d[3] ^ i_d[0] ^ crc_reg[0] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[10] ^ crc_reg[18] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[28] ^ crc_reg[31];
        crc_reg[27] <= i_d[29] ^ i_d[27] ^ i_d[26] ^ i_d[25] ^ i_d[24] ^ i_d[23] ^ i_d[21] ^ i_d[20] ^ i_d[19] ^ i_d[11] ^ i_d[7] ^ i_d[5] ^ i_d[4] ^ i_d[1] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[5] ^ crc_reg[7] ^ crc_reg[11] ^ crc_reg[19] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[29];
        crc_reg[28] <= i_d[30] ^ i_d[28] ^ i_d[27] ^ i_d[26] ^ i_d[25] ^ i_d[24] ^ i_d[22] ^ i_d[21] ^ i_d[20] ^ i_d[12] ^ i_d[8] ^ i_d[6] ^ i_d[5] ^ i_d[2] ^ crc_reg[2] ^ crc_reg[5] ^ crc_reg[6] ^ crc_reg[8] ^ crc_reg[12] ^ crc_reg[20] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[30];
        crc_reg[29] <= i_d[31] ^ i_d[29] ^ i_d[28] ^ i_d[27] ^ i_d[26] ^ i_d[25] ^ i_d[23] ^ i_d[22] ^ i_d[21] ^ i_d[13] ^ i_d[9] ^ i_d[7] ^ i_d[6] ^ i_d[3] ^ crc_reg[3] ^ crc_reg[6] ^ crc_reg[7] ^ crc_reg[9] ^ crc_reg[13] ^ crc_reg[21] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[25] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[31];
        crc_reg[30] <= i_d[30] ^ i_d[29] ^ i_d[28] ^ i_d[27] ^ i_d[26] ^ i_d[24] ^ i_d[23] ^ i_d[22] ^ i_d[14] ^ i_d[10] ^ i_d[8] ^ i_d[7] ^ i_d[4] ^ crc_reg[4] ^ crc_reg[7] ^ crc_reg[8] ^ crc_reg[10] ^ crc_reg[14] ^ crc_reg[22] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[26] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30];
        crc_reg[31] <= i_d[31] ^ i_d[30] ^ i_d[29] ^ i_d[28] ^ i_d[27] ^ i_d[25] ^ i_d[24] ^ i_d[23] ^ i_d[15] ^ i_d[11] ^ i_d[9] ^ i_d[8] ^ i_d[5] ^ crc_reg[5] ^ crc_reg[8] ^ crc_reg[9] ^ crc_reg[11] ^ crc_reg[15] ^ crc_reg[23] ^ crc_reg[24] ^ crc_reg[25] ^ crc_reg[27] ^ crc_reg[28] ^ crc_reg[29] ^ crc_reg[30] ^ crc_reg[31];
    end else begin
        crc_reg <= crc_reg;
    end
end

assign o_crc = crc_reg;

endmodule
