
/***
file: hamming_encoder26.v
author: zfy
version: V10
description: hamming code encoder for 26 bit data, the hamming code is 5 bits in width

***/

module hamming_encoder26 
(
    input wire [25:0] data,   // DW must be bigger than 26-bit 
    output wire [4:0] code // 5-bit output hamming code
);



wire [25:0] d;
assign d = data;

// Declare parity bits
wire p0, p1, p2, p3, p4;

//compute parity bits
assign p0 = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[11]^d[13]^d[15]^d[17]^d[19]^d[21]^d[23]^d[25];
assign p1 = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[10]^d[12]^d[13]^d[16]^d[17]^d[20]^d[21]^d[24]^d[25];
assign p2 = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[10]^d[14]^d[15]^d[16]^d[17]^d[22]^d[23]^d[24]^d[25];
assign p3 = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[10]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25];
assign p4 = d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25];




//output
assign code = {p4, p3, p2, p1, p0}; //hamming code



endmodule