module multi_sram#(
    parameter DWIDTH      =  32                 ,
    parameter NRAMWIDHT   =  5                  ,
    parameter AWIDTH      =  13                 
  )(
    /*================ Port A ================*/
    input  logic                            clk_a_in      ,
    input  logic                            en_a_in       ,
    input  logic                            we_a_in       ,
    input  logic [(NRAMWIDHT+AWIDTH - 1):0] addr_a_in     ,
    input  logic [(DWIDTH - 1):0]           d_a_in        ,
    output logic [(DWIDTH - 1):0]           d_a_out       ,
    /*================ Port B ================*/
    input  logic                            clk_b_in      ,
    input  logic                            en_b_in       ,
    input  logic                            we_b_in       ,
    input  logic [(NRAMWIDHT+AWIDTH - 1):0] addr_b_in     ,
    input  logic [(DWIDTH - 1):0] d_b_in                  ,
    output logic [(DWIDTH - 1):0] d_b_out
);

localparam NSRAM = 'd2 << NRAMWIDHT ;
logic [NSRAM-1:0] en_a_in_arr;
logic [NSRAM-1:0] we_a_in_arr;
logic [NSRAM-1:0] en_b_in_arr;
logic [NSRAM-1:0] we_b_in_arr;

genvar idx;
generate 
    for( idx =0;idx<NSRAM;idx = idx+1 )begin : generate_dpsram
        dual_sram #(
            .DWIDTH (DWIDTH)                  ,
            .AWIDTH ('d13)                                  // here need to optimize          
        )dual_sram(
            .clk_a_in                  (clk_a_in                ),
            .en_a_in                   (en_a_in_arr[idx]        ),
            .we_a_in                   (we_a_in_arr[idx]        ),
            .addr_a_in                 (addr_a_in[(AWIDTH-1):0] ),
            .d_a_in                    (d_a_in                  ),
            .d_a_out                   (d_a_out                 ),

            .clk_b_in                  (clk_b_in                ),
            .en_b_in                   (en_b_in_arr[idx]        ),
            .we_b_in                   (we_b_in_arr[idx]        ),
            .addr_b_in                 (addr_b_in[(AWIDTH-1):0] ),
            .d_b_in                    (d_b_in                  ),
            .d_b_out                   (d_b_out                 )
        );
    end
endgenerate

assign en_a_in_arr = (en_a_in == 1'b1) ? (('d1 ) << addr_a_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;
assign we_a_in_arr = (we_a_in == 1'b1 )? (('d1 ) << addr_a_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;

assign en_b_in_arr = (en_a_in == 1'b1) ? (('d1 ) << addr_b_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;
assign we_b_in_arr = (we_a_in == 1'b1 )? (('d1 ) << addr_b_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;

endmodule