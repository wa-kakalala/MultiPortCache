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
    input  logic [(DWIDTH - 1):0]           d_b_in        ,
    output logic [(DWIDTH - 1):0]           d_b_out
);

localparam NSRAM = 'd1 << NRAMWIDHT ;
logic [NSRAM-1:0] en_a_in_arr;
logic [NSRAM-1:0] we_a_in_arr;
logic [NSRAM-1:0] en_b_in_arr;
logic [NSRAM-1:0] we_b_in_arr;

logic [(DWIDTH - 1):0] d_a_out_arr [(1<<NRAMWIDHT)-1:0];
logic [(DWIDTH - 1):0] d_b_out_arr [(1<<NRAMWIDHT)-1:0];

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
            .d_a_out                   (d_a_out_arr[idx]        ),

            .clk_b_in                  (clk_b_in                ),
            .en_b_in                   (en_b_in_arr[idx]        ),
            .we_b_in                   (we_b_in_arr[idx]        ),
            .addr_b_in                 (addr_b_in[(AWIDTH-1):0] ),
            .d_b_in                    (d_b_in                  ),
            .d_b_out                   (d_b_out_arr[idx]        )
        );
    end
endgenerate

assign en_a_in_arr = (en_a_in == 1'b1) ? (('d1 ) << addr_a_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;
assign we_a_in_arr = (we_a_in == 1'b1 )? (('d1 ) << addr_a_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;

assign en_b_in_arr = (en_b_in == 1'b1) ? (('d1 ) << addr_b_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;
assign we_b_in_arr = (we_b_in == 1'b1 )? (('d1 ) << addr_b_in[(NRAMWIDHT+AWIDTH - 1):AWIDTH]) : 'd0;


logic en_a_in_reg;
logic we_a_in_reg;

logic en_b_in_reg;
logic we_b_in_reg;

logic [(NRAMWIDHT+AWIDTH - 1):0] addr_a_in_reg;
logic [(NRAMWIDHT+AWIDTH - 1):0] addr_b_in_reg;

always_ff @(posedge clk_a_in ) begin
    en_a_in_reg <= en_a_in;
    we_a_in_reg <= we_a_in;
    addr_a_in_reg <= addr_a_in;
end 

always_ff @(posedge clk_b_in ) begin
    en_b_in_reg <= en_b_in;
    we_b_in_reg <= we_b_in;
    addr_b_in_reg <= addr_b_in;
end 

assign d_a_out =  (en_a_in_reg==1'b1 && we_a_in_reg == 1'b0) ? d_a_out_arr[addr_a_in_reg[(NRAMWIDHT+AWIDTH - 1):AWIDTH]] :'b0;
assign d_b_out =  (en_b_in_reg==1'b1 && we_b_in_reg == 1'b0) ? d_b_out_arr[addr_b_in_reg[(NRAMWIDHT+AWIDTH - 1):AWIDTH]] :'b0;

endmodule