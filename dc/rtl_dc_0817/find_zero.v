
/***
author: zfy
version: 
description: 


***/


module find_zero #(
           parameter  WIDTH    = 8
       )
       (
           input  wire [WIDTH-1 : 0]               code,
           output wire [WIDTH-1 : 0]               one_hot_code,
           output wire                            find,
           output wire [$clog2(WIDTH)-1 : 0]      bin_code
       
	   );


    
    // get one hot code for first 0 from low to high
    assign one_hot_code = (code+1) & (~code);

    // if one hot code has no 1, find=0; otherwise find=1 
    assign find =  !(&code);


    //transform onehot code to bin code 
    onehot_decoder #(
                .ONE_HOT_WIDTH ( WIDTH  )
            )
            u_onehot_decoder (
                .one_hot_code            ( one_hot_code   ),

                .bin_code                ( bin_code )
    );



endmodule