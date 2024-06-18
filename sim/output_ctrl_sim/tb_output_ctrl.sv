/**************************************
@ filename    : tb_output_ctrl.sv
@ author      : yyrwkk
@ create time : 2024/05/17 22:36:54
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module tb_output_ctrl();

localparam PORTNUM        =  16;
localparam BLK_ADDR_WIDTH =  10;
localparam LEN_WIDTH      =  10;
localparam TIMES_WIDTH    =  4 ;
localparam QUE_LEN_WIDTH  =  5 ;

logic                       i_clk         ;
logic                       i_rst_n       ;
logic [$clog2(PORTNUM)-1:0] i_port        ;
logic                       i_port_vld    ;
logic [BLK_ADDR_WIDTH-1:0 ] i_blk_addr    ;
logic                       i_blk_addr_vld;
logic [LEN_WIDTH-1:0 ]      i_len         ;
logic                       i_len_vld     ;
logic                       i_r_done      ;
logic [BLK_ADDR_WIDTH-1:0 ] o_blk_addr    ;
logic [BLK_ADDR_WIDTH-1:0 ] o_blk_addr_vld;
logic [$clog2(PORTNUM)-1:0] o_port        ;
logic                       o_port_vld    ;
logic                       o_last_blk_vld;
logic [TIMES_WIDTH-1:0    ] o_last_r_times;

output_ctrl output_ctrl_inst(
    .i_clk          (i_clk         ),
    .i_rst_n        (i_rst_n       ),
    .i_port         (i_port        ),
    .i_port_vld     (i_port_vld    ),
    .i_blk_addr     (i_blk_addr    ),
    .i_blk_addr_vld (i_blk_addr_vld),
    .i_len          (i_len         ),
    .i_len_vld      (i_len_vld     ),
    .i_r_done       (i_r_done      ),
    .o_blk_addr     (o_blk_addr    ),
    .o_blk_addr_vld (o_blk_addr_vld),
    .o_port         (o_port        ),
    .o_port_vld     (o_port_vld    ),
    .o_last_blk_vld (o_last_blk_vld),
    .o_last_r_times (o_last_r_times)    
);


initial begin
    i_clk         <= 'b0;
    i_rst_n       <= 'b0;
    i_port        <= 'b0;
    i_port_vld    <= 'b0;
    i_blk_addr    <= 'b0;
    i_blk_addr_vld<= 'b0;
    i_len         <= 'b0;
    i_len_vld     <= 'b0;
    i_r_done      <= 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    i_port <= 'd4;
    i_port_vld <= 'd1;
    @(posedge i_clk);
    i_port <= 'd0;
    i_port_vld <= 'd0;
    repeat(4) @(posedge i_clk);
    i_len <= 'd123;
    i_len_vld <= 1'b1;
    @(posedge i_clk);
    repeat(10) @(posedge i_clk);
    i_r_done <= 1'b1;
    @(posedge i_clk);
    i_r_done <= 1'b0;
    repeat(10) @(posedge i_clk);
    i_r_done <= 1'b1;
    @(posedge i_clk);
    i_r_done <= 1'b0;

    repeat(10) @(posedge i_clk);
    $stop();
end

initial begin
    forever begin
        @(posedge i_clk);
        if( o_port_vld) begin
            i_blk_addr <= 'd3;
            i_blk_addr_vld <= 1'b1;
        end else begin
            i_blk_addr <= 'd0;
            i_blk_addr_vld <= 1'b0;
        end
    end
end

endmodule