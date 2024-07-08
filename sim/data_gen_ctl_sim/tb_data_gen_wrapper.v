
//~ `New testbench
`timescale  1ns / 1ps

module tb_data_gen_wrapper;

// data_gen_wrapper Parameters
parameter PERIOD  = 10;



// data_gen_wrapper Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

// data_gen_wrapper Outputs
wire  o_sop                                ;
wire  o_vld                                ;
wire  [31:0]  o_data                     ;
wire  o_eop                                ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

data_gen_wrapper  #(
        .GEN_INF_W (   32  ),
        .FIFO_ADDR_W    (   5   ),
        .RAM_ADDR_W     (   5   ),
        .DW     (   32  )
)
    u_data_gen_wrapper (
    .clk                     ( clk              ),
    .rst_n                   ( rst_n            ),

    .o_sop                   ( o_sop            ),
    .o_vld                   ( o_vld            ),
    .o_data                  ( o_data           ),
    .o_eop                   ( o_eop            )
);

initial
begin
    #(1000*PERIOD);

    $stop;
end

endmodule