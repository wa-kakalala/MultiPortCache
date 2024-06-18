/**************************************
@ filename    : tb_port_arbitator.sv
@ author      : yyrwkk
@ create time : 2024/05/17 16:50:55
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module tb_port_arbitator();
logic               i_clk        ;
logic               i_rst_n      ;
logic [16-1:0]      i_req        ;
logic               i_eop        ;
logic               o_port_ready ;
logic [16-1:0]      o_resp       ;
logic [16-1:0]      o_nresp      ;

port_arbitrator port_arbitrator_inst(
    .i_clk       (i_clk       ),
    .i_rst_n     (i_rst_n     ),

    .i_req       (i_req       ),
    .i_eop       (i_eop       ),

    .o_port_ready(o_port_ready),
    .o_resp      (o_resp      ),
    .o_nresp     (o_nresp     )
);

initial begin
    i_clk    <= 'b0;
    i_rst_n  <= 'b0;
    i_req    <= 'b0;
    i_eop    <= 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);

    i_req <= 16'b1000_0000_0000_0010;
    @(posedge i_clk);
    i_eop <= 1'b1;

    repeat(50)@(posedge i_clk);
    $stop();
end

endmodule