interface multi_sram_if#(
    parameter DWIDTH      =  32                    ,
    parameter NRAMWIDHT   =  5                     ,
    parameter AWIDTH      =  13                 
)(input logic clk_a_in,input logic clk_b_in);
/*================ Port A ================*/
logic en_a_in                                      ;
logic we_a_in                                      ;
logic [(NRAMWIDHT+AWIDTH - 1):0] addr_a_in         ;
logic [(DWIDTH - 1):0] d_a_in                      ;
logic [(DWIDTH - 1):0] d_a_out                     ;
/*================ Port B ================*/
logic en_b_in                                      ;    
logic we_b_in                                      ;    
logic [(NRAMWIDHT+AWIDTH - 1):0] addr_b_in         ;    
logic [(DWIDTH - 1):0] d_b_in                      ;    
logic [(DWIDTH - 1):0] d_b_out                     ;

endinterface