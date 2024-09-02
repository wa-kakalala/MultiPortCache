/**************************************
@ filename    : tb_channel_req.sv
@ author      : yyrwkk
@ create time : 2024/07/11 02:18:57
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module tb_channel_req();

parameter       PORTNUM  =  16    ;
parameter       DWIDTH   =  32    ;
parameter       RAMWIDTH =  10    ;
parameter       NPACKLEN =  8     ;
parameter [3:0] PORT_ID  =  4'd0  ;

logic                i_clk                   ;
logic                i_rst_n                 ;
logic [DWIDTH-1:0 ]  i_data                  ;
logic                i_empty                 ;
logic [PORTNUM-1:0 ] i_resp                  ;
logic [PORTNUM-1:0 ] i_nresp                 ;
logic [RAMWIDTH-1:0] i_ramspace [PORTNUM-1:0];
logic [PORTNUM-1:0 ] i_ready                 ;
logic [PORTNUM-1:0]  o_req                   ;
logic [DWIDTH-1:0]   o_data                  ;
logic                o_data_vld              ;
logic                o_eop                   ;
logic                o_rd_en                 ;

channel_req # (
    .PORTNUM (16   ),
    .DWIDTH  (32   ),
    .RAMWIDTH(10   ),
    .NPACKLEN(8    ),
    .PORT_ID (4'd1 )
)channel_req_inst(
    .i_clk                   (i_clk     ),
    .i_rst_n                 (i_rst_n   ),
    .i_data                  (i_data    ),
    .i_empty                 (i_empty   ),
    .i_resp                  (i_resp    ),
    .i_nresp                 (i_nresp   ),
    .i_ramspace              (i_ramspace),
    .i_ready                 (i_ready   ),
    .o_req                   (o_req     ),
    .o_data                  (o_data    ),
    .o_data_vld              (o_data_vld),
    .o_eop                   (o_eop     ),
    .o_rd_en                 (o_rd_en   )
);

logic [31:0] fifo_data ;
initial begin
    i_clk     = 'b0;
    i_rst_n   = 'b0;
    i_data    = 'b0;
    i_empty   = 'b1;
    i_resp    = 'b0;
    i_nresp   = 'b0;
    i_ramspace= '{0,0,0,0,0,0,0,0,0,0,0,0,0,800,2,10};
    i_ready   = 16'b0000_0000_0000_0111;
    fifo_data = {15'd0,10'd200,3'd6,4'd0};
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk );
    i_rst_n <= 1'b1;
    @(posedge i_clk );
    i_empty <= 1'b0;
    repeat( 300 )@(posedge i_clk);
    $stop;
end

initial begin
    forever begin
        @(posedge i_clk );
        if( o_rd_en ) begin
            i_data <= fifo_data;
            if( fifo_data == {15'd0,10'd200,3'd6,4'd0} ) begin
                fifo_data <= 'b0;
            end else begin
                fifo_data <= fifo_data  + 1'b1;
            end
            
        end
        if( o_eop ) begin
            fifo_data <= {15'd0,10'd200,3'd6,4'd0};
        end
    end
end

initial begin
    forever begin
        @(posedge i_clk );
        if( |o_req ) begin
            i_resp <= o_req;
            i_nresp <= ~o_req;
        end
    end
end

endmodule