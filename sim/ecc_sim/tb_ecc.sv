
//~ `New testbench
`timescale  1ns / 1ps

module tb_ecc;

// ecc_encoder Parameters
parameter PERIOD  = 10;
parameter DATA_W  = 26;
parameter CODE_W  = 5 ;



// ecc_encoder declare
logic   clk                                   ;
logic   rst_n                                 ;
logic   [DATA_W-1:0]  in_data              ;
logic   in_vld                              ;

logic   [DATA_W-1:0]  encoded_data       ;
logic   [CODE_W-1:0]  encoded_code;
logic   encoded_vld ;


logic   [DATA_W-1:0]  unverified_data        ;
logic   [CODE_W-1:0]  unverified_code     ;
logic   unverified_vld ;

logic   [DATA_W-1:0]  corrected_data        ;
logic   corrected_vld;
logic error_detected;
logic [DATA_W + CODE_W-1 :0] noise  ;

int i;



ecc_encoder #(
    .DATA_W ( DATA_W ),
    .CODE_W ( CODE_W ))
 u_ecc_encoder (
    .i_clk                     ( clk                   ),
    .i_rst_n                   ( rst_n                 ),
    .i_data                 ( in_data  [DATA_W-1:0] ),
    .i_vld                  ( in_vld                ),

    .o_data                ( encoded_data     [DATA_W-1:0] ),     
    .o_code                ( encoded_code     [CODE_W-1:0] ),
    .o_vld                 ( encoded_vld               )
);


// simulate the process during SRAM
always@(posedge clk) begin

    i <= {$random()} % (DATA_W+CODE_W); // range from [0, DATA_W+CODE_W-1]
    if( i == 0 ) begin
        noise <= 'b0; 
    end
    else begin
        noise <= 1<<i;
    end

    unverified_vld <= encoded_vld;

    //simulate error happened, maybe happened in data or ecc code
    {unverified_code, unverified_data}<= {encoded_code, encoded_data} ^ noise;

end



ecc_decoder #(
    .DATA_W ( DATA_W ),
    .CODE_W ( CODE_W  ))
 u_ecc_decoder (
    .i_clk                     ( clk              ),
    .i_rst_n                   ( rst_n            ),
    .i_data                 ( unverified_data          ),
    .i_code                 ( unverified_code          ),
    .i_vld                  ( unverified_vld           ),

    .o_corrected_data          ( corrected_data   ),
    .o_error_detected          ( error_detected   ),
    .o_vld                      ( corrected_vld          )
);



initial
begin
    clk = 0;
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    rst_n = 0;
    #(PERIOD*2); 
    rst_n = 1;
end


initial begin
    // initial
    in_data = 'd0;
    in_vld = 1'b0;
    noise = 'd0;
end



initial
begin

    #(PERIOD*100);

    for(int i =0; i<1000; i++) begin
        @(posedge clk) begin
            in_data <= in_data+1;
            in_vld  <= 1'b1;
            #(PERIOD);
        end
    end


    $stop;
end

endmodule