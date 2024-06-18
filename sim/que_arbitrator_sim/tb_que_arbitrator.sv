/**************************************
@ filename    : tb_que_arbitrator.sv
@ author      : yyrwkk
@ create time : 2024/05/16 21:04:53
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module tb_que_arbitrator();

logic                       i_clk                 ;
logic                       i_rst_n               ;
logic [16-1:0]              i_pending             ;
logic [$clog2(8)-1:0]       i_prior      [16-1:0] ;
logic                       i_update              ;
logic [$clog2(16)-1:0]      i_clr_port            ;
logic                       i_clr_vld             ;
logic [$clog2(16)-1:0]      o_port                ;
logic                       o_port_vld            ;
logic                       o_empty               ;

que_arbitrator que_arbitrator_inst(
    .i_clk                 (i_clk     ),
    .i_rst_n               (i_rst_n   ),

    .i_pending             (i_pending ),
    .i_prior               (i_prior   ),
    .i_update              (i_update  ),

    .i_clr_port            (i_clr_port),
    .i_clr_vld             (i_clr_vld ),

    .o_port                (o_port    ),
    .o_port_vld            (o_port_vld),

    .o_empty               (o_empty   )
);

initial begin
    i_clk     <= 'b0;
    i_rst_n   <= 'b0;
    i_pending <= 'b0;
    for( int i=0;i<16;i++) begin
        i_prior[i]   <= 'b0;
    end
    
    i_update  <= 'b0;
    i_clr_port<= 'b0;
    i_clr_vld <= 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    i_pending <= {1'b0,1'b0,1'b0,1'b0,  1'b0,1'b0,1'b0,1'b0,  1'b0,1'b0,1'b0,1'b0,  1'b0,1'b0,1'b1,1'b1};
    i_prior[0] <= 16'd2;
    i_prior[1] <= 16'd3;
    i_update <= 1'b1;
    @(posedge i_clk);
    i_update <= 1'b0;
    repeat(10) @(posedge i_clk);
    $stop();

end


endmodule