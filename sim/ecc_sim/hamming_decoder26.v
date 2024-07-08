
/***
file: hamming_decoder26.v
author: zfy
version: v10
description: hamming code decoder for 26 bit data and 6bit hamming code,  

***/

module hamming_decoder26
(

    input wire [25:0] data,   // input data
    input wire [4:0] code, //5-bit output hamming code

    output wire [25:0] corrected_data, // Encoded data with Hamming code ( 32 data bits + 6 parity bits)
    output wire error_detected //indicator to indicate whether one-bit error has occur in data
);




wire [25:0] d;
assign d = data;


// Declare parity bits
wire p0, p1, p2, p3, p4, p5;
//compute parity bits
assign p0 = code[0]^ d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[11]^d[13]^d[15]^d[17]^d[19]^d[21]^d[23]^d[25];
assign p1 = code[1]^ d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[10]^d[12]^d[13]^d[16]^d[17]^d[20]^d[21]^d[24]^d[25];
assign p2 = code[2]^ d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[10]^d[14]^d[15]^d[16]^d[17]^d[22]^d[23]^d[24]^d[25];
assign p3 = code[3]^ d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[10]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25];
assign p4 = code[4]^ d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25];



// Declare Hamming sequence 
wire [31:0] h;
// Map input data bits and parity bits to hamming sequence
assign h[0] = p0;//2^0 position;
assign h[1] = p1;//2^1 position;
assign h[2] = d[0];
assign h[3] = p2;//2^2 position;
assign h[6:4] = d[3:1];
assign h[7] = p3;//2^3 position;
assign h[14:8] = d[10:4];
assign h[15] = p4;//2^4 position;
assign h[30:16] = d[25:11];
assign h[31]    = 1'b0;


// result 
wire [4:0] result;
assign result = {p4, p3, p2, p1, p0};


// The number of setbits inside parity bits
reg [3:0] setbits_in_parity;
    always @(*) begin
        setbits_in_parity = p4+p3+p2+p1+p0;
    end



// correct the hamming sequence
reg [31:0] corrected_h;
always @(*) begin
    corrected_h = h; // default corrected sequence is the input sequence


    if ( (setbits_in_parity > 4'd0 ) && (result <=5'd31) ) begin
        corrected_h[result-1] = ~h[result-1];
    end
end


//output
// Map corrected hamming sequence bits to corrected data
assign corrected_data[0] = corrected_h[2];
assign corrected_data[3:1] = corrected_h[6:4];
assign corrected_data[10:4] = corrected_h[14:8];
assign corrected_data[25:11] = corrected_h[30:16];

assign error_detected = (corrected_data != data)? 1'b1 : 1'b0;


endmodule