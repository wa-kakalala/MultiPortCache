
/**************************************
@ filename    : tb_read_sram.sv
@ author      : yyrwkk
@ create time : 2024/05/26 23:15:07
@ version     : v1.0.0
**************************************/
`timescale  1ns / 1ps

module tb_read_sram;
parameter AWIDTH     = 14; 
parameter BLK_AWIDTH = 10;
parameter DWIDTH     = 32;
logic                          i_clk                ;
logic                          i_rst_n              ;
logic [AWIDTH-1:0]             i_blk_addr           ;
logic                          i_blk_addr_vld       ;
logic                          i_last_blk_vld       ;
logic [AWIDTH-BLK_AWIDTH-1:0]  i_last_blk_n         ;
logic [DWIDTH-1:0]             i_sram_rd_data       ;
logic                          o_read_finish        ;
logic                          o_read_almost_finish ;
logic                          o_sram_rd_en         ;
logic [AWIDTH-1:0]             o_sram_rd_addr       ;
logic                          o_rd_sop             ;
logic                          o_rd_eop             ;
logic                          o_rd_vld             ;
logic [DWIDTH-1:0]             o_rd_data            ;
logic [DWIDTH-1:0]             o_pkt_len            ;
logic                          o_pkt_len_vld        ;

read_sram read_sram_inst(
    .i_clk                (i_clk               ),
    .i_rst_n              (i_rst_n             ),
    .i_blk_addr           (i_blk_addr          ),
    .i_blk_addr_vld       (i_blk_addr_vld      ),
    .i_last_blk_vld       (i_last_blk_vld      ),
    .i_last_blk_n         (i_last_blk_n        ),
    .i_sram_rd_data       (i_sram_rd_data      ),
    .o_read_finish        (o_read_finish       ),
    .o_read_almost_finish (o_read_almost_finish),
    .o_sram_rd_en         (o_sram_rd_en        ),
    .o_sram_rd_addr       (o_sram_rd_addr      ),
    .o_rd_sop             (o_rd_sop            ),
    .o_rd_eop             (o_rd_eop            ),
    .o_rd_vld             (o_rd_vld            ),
    .o_rd_data            (o_rd_data           ),
    .o_pkt_len            (o_pkt_len           ),
    .o_pkt_len_vld        (o_pkt_len_vld       )
);

initial begin
    i_clk              <= 'b0; 
    i_rst_n            <= 'b0; 
    i_blk_addr         <= 'b0; 
    i_blk_addr_vld     <= 'b0; 
    i_last_blk_vld     <= 'b0; 
    i_last_blk_n       <= 'b0; 
    i_sram_rd_data     <= 'b0; 
end 

initial begin
    forever #5 i_clk = ~i_clk;
end 

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    i_blk_addr_vld  <= 1'b1;
    i_blk_addr      <= 0*16;
    @(posedge i_clk);
    i_blk_addr_vld  <= 1'b0;
    i_blk_addr      <= 0;
    @(posedge i_clk);
    for( int i=1;i<8;i++) begin
        forever begin
            @(posedge i_clk);
            if(o_read_almost_finish) break;
        end
        i_blk_addr_vld  <= 1'b1;
        i_blk_addr      <= i*16;
        @(posedge i_clk);
        i_blk_addr_vld  <= 1'b0;
        i_blk_addr      <= i*16;
    end
    forever begin
        @(posedge i_clk);
        if(o_read_almost_finish) break;
    end
    i_blk_addr_vld  <= 1'b1;
    i_blk_addr      <= 8*16;
    i_last_blk_vld  <= 'b1 ; 
    i_last_blk_n    <= 'd10; 
    @(posedge i_clk);
    i_blk_addr_vld  <= 1'b0;
    i_blk_addr      <= 8*16;
    i_last_blk_vld  <= 'b0 ; 
    i_last_blk_n    <= 'd10; 

    repeat(100)@(posedge i_clk);
    $stop;
end

initial begin
    forever begin
        @(posedge i_clk);
        if( o_sram_rd_en ) begin
            i_sram_rd_data <= i_sram_rd_data +1'b1;
        end
    end
end

endmodule