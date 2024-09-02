/**************************************
@ filename    : tb_round_robin_arbiter.sv
@ author      : yyrwkk
@ create time : 2024/08/18 02:48:09
@ version     : v1.0.0
**************************************/
module tb_round_robin_arbiter();

parameter  N_REQ  =  16;
logic             i_clk  ;
logic             i_rst_n;
logic [N_REQ-1:0] i_req  ;
logic [N_REQ-1:0] o_grant;
round_robin_arbiter  # (
    .N_REQ ( N_REQ )    // N must be at least 2
)round_robin_arbiter_inst(
    .i_clk   (i_clk  ),
    .i_rst_n (i_rst_n),
    .i_req   (i_req  ),
    .o_grant (o_grant)
);

initial begin
    i_clk   = 'b0;
    i_rst_n = 'b0;
    i_req   = 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk );
    i_rst_n <= 1'b1;
    @(posedge i_clk );
    for( int i=0;i<18;i++) begin
        i_req <= 16'hff_ff;
        @(posedge i_clk );
        @(posedge i_clk );
        $display("grant: %b",o_grant);
    end
    i_req <= 16'h0;
    repeat(50) @(posedge i_clk );
    $stop;
end


endmodule