/**************************************
@ filename    : tb_input_ctrl.sv
@ author      : yyrwkk
@ create time : 2024/05/14 11:45:38
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module tb_input_ctrl();
`include "./mpcache.svh"
logic                       i_clk           ;
logic                       i_rst_n         ;
logic                       i_blk_addr_vld  ;
logic [`BLK_ADDR_WIDTH-1:0] i_blk_addr      ;
logic                       i_sop           ;
logic                       i_wr_vld        ;
logic [`DATA_WIDTH-1:0    ] i_wr_data       ;
logic                       i_eop           ;
logic                       o_sop           ;
logic [`DA_WIDTH-1:0      ] o_da            ;
logic [`PRORITY_WIDTH-1:0 ] o_prority       ;
logic                       o_hdr_vld       ;
logic [`BLK_ADDR_WIDTH-1:0] o_blk_addr      ;
logic                       o_blk_addr_vld  ;
logic                       o_eop           ;
logic [`BLK_ADDR_WIDTH-1:0] o_sram_addr     ;
logic                       o_sram_addr_vld ;
logic                       o_addr_req      ;

input_ctrl input_ctrl_inst(
    .i_clk           (i_clk          ),
    .i_rst_n         (i_rst_n        ),
 
    .i_blk_addr_vld  (i_blk_addr_vld ),
    .i_blk_addr      (i_blk_addr     ),
 
    .i_sop           (i_sop          ),
    .i_wr_vld        (i_wr_vld       ),
    .i_wr_data       (i_wr_data      ),
    .i_eop           (i_eop          ),
 
    .o_sop           (o_sop          ),
    .o_da            (o_da           ),
    .o_prority       (o_prority      ),
    .o_hdr_vld       (o_hdr_vld      ),
    .o_blk_addr      (o_blk_addr     ),
    .o_blk_addr_vld  (o_blk_addr_vld ),
    .o_eop           (o_eop          ),

    .o_sram_addr     (o_sram_addr    ),
    .o_sram_addr_vld (o_sram_addr_vld),

    .o_addr_req      (o_addr_req     )
);

logic [`BLK_ADDR_WIDTH-1:0] blk_addr      ;

initial begin
    i_clk           <= 'b0;
    i_rst_n         <= 'b0;
    i_blk_addr_vld  <= 'b0;
    i_blk_addr      <= 'b0;
    i_sop           <= 'b0;
    i_wr_vld        <= 'b0;
    i_wr_data       <= 'b0;
    i_eop           <= 'b0;
    blk_addr        <= 'b0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    i_sop <= 1'b1;
    @(posedge i_clk);
    i_sop <= 1'b0;
    i_wr_vld <= 'b1;
    i_wr_data <= {15'd0,10'd1022,3'd1,4'd4};
    @(posedge i_clk);
    for( int i=0;i<(1022-4)/4 ;i++ ) begin
        i_wr_vld <= 'b1;
        i_wr_data <= $urandom();
        @(posedge i_clk);
    end
    if( ((1022-4)) % 4 != 0 ) begin
        i_wr_vld <= 'b1;
        i_wr_data <= $urandom();
        @(posedge i_clk);
    end
    i_wr_vld  <= 'b0;
    i_wr_data <= 'b0;
    i_eop     <= 'b1;
    @(posedge i_clk);
    i_eop     <= 'b0;

    repeat(1000) @(posedge i_clk);
    $stop;
end

initial begin
    forever begin
        @(posedge i_clk );
        if( o_addr_req ) begin
            i_blk_addr_vld <= 1'b1;
            i_blk_addr     <= blk_addr;
            blk_addr       <= blk_addr + 1'b1;
        end else begin
            i_blk_addr_vld <= 1'b0;
            i_blk_addr     <= 'b0;
            blk_addr       <= blk_addr ;
        end
    end
end
endmodule