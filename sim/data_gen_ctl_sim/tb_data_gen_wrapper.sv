
//~ `New testbench
`timescale  1ns / 1ps

module tb_data_gen_wrapper;

    // data_gen_wrapper Parameters
    parameter PERIOD            = 10;
    parameter RAM_ADDR_W        = 5;
    parameter DATA_W            =   32;


    // data_gen_wrapper Inputs
    logic   clk                                  = 0 ;
    logic   rst_n                                = 0 ;

    // data_gen_wrapper Outputs
    logic  o_sop                                ;
    logic  o_vld                                ;
    logic  [31:0]  o_data                     ;
    logic  o_eop                                ;
    logic  [RAM_ADDR_W-1:0]      fetch_n     ;                  


    initial
    begin
        forever #(PERIOD/2)  clk=~clk;
    end

    initial
    begin
        #(PERIOD*2) rst_n  =  1;
    end



// instialate data_gen_wrapper
    data_gen_wrapper  #(
            .GEN_INF_W (   32  ),
            .RAM_ADDR_W     (   RAM_ADDR_W   ),
            .DW     (   DATA_W  ),
            .ID     (7      )
    )
        u_data_gen_wrapper (
        .clk                     ( clk              ),
        .rst_n                   ( rst_n            ),

        .fetch_n                 (  fetch_n        ),

        .o_sop                   ( o_sop            ),
        .o_vld                   ( o_vld            ),
        .o_data                  ( o_data           ),
        .o_eop                   ( o_eop            )
    );


// instialate frame cnt
    frame_cnt  u_frame_cnt (
        .clk                     ( clk       ),
        .rst_n                   ( rst_n     ),
        .i_sop                   ( o_sop     ),
        .i_eop                   ( o_eop     ),

        .o_count                 ( frame_count   )
    );




initial
begin

    fetch_n = 10;
    #(1000*PERIOD);

    rst_n  = 0;
    #(PERIOD*2) rst_n  =  1;


    fetch_n = 5;
    #(1000*PERIOD);


    $stop;
end

endmodule