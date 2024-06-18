/**************************************
@ filename    : tb_port_req.sv
@ author      : yyrwkk
@ create time : 2024/05/17 15:14:43
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module tb_port_req ();

logic                       i_clk        ;
logic                       i_rst_n      ;
logic                       i_que_vld    ;
logic                       i_empty      ;
logic [16-1:0]              i_port_ready ;
logic [16-1:0]              i_resp       ;
logic [$clog2(16)-1:0]      i_port       ;
logic                       i_port_vld   ;
logic                       i_r_finish   ;
logic                       o_update     ;
logic                       o_port_vld   ;
logic [$clog2(16)-1:0]      o_port       ;
logic [$clog2(16)-1:0]      o_clr_port   ;
logic                       o_clr_vld    ;
logic [16-1:0]              o_req        ;

port_req port_req_inst(
    .i_clk        (i_clk       ),
    .i_rst_n      (i_rst_n     ),
    .i_que_vld    (i_que_vld   ),
    .i_empty      (i_empty     ),
    .i_port_ready (i_port_ready),
    .i_resp       (i_resp      ),
    .i_port       (i_port      ),
    .i_port_vld   (i_port_vld  ),
    .i_r_finish   (i_r_finish  ),
    .o_update     (o_update    ),
    .o_port_vld   (o_port_vld  ),
    .o_port       (o_port      ),
    .o_clr_port   (o_clr_port  ),
    .o_clr_vld    (o_clr_vld   ),
    .o_req        (o_req       )  
);

initial begin
    i_clk        <= 'b0;
    i_rst_n      <= 'b0;
    i_que_vld    <= 'b0;
    i_empty      <= 'b0;
    i_port_ready <= 16'hffff;
    i_resp       <= 'b0;
    i_port       <= 'b0;
    i_port_vld   <= 'b0;
    i_r_finish   <= 'b0;
end

initial begin
    forever begin
        #5 i_clk = ~i_clk;
    end
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    i_que_vld <= 1'b1;
    @(posedge i_clk);
    i_que_vld <= 1'b0;
    repeat(100) @(posedge i_clk);
    $stop();

end

initial begin
    forever begin
        @(posedge i_clk);
        if( o_update == 1'b1 ) begin
            i_port      <= 4'd15   ;
            i_port_vld  <= 1'b1    ;

        end else begin
            i_port      <= 'b0   ;
            i_port_vld  <= 1'b0  ;

        end
    end
end

initial begin
    forever begin
        @(posedge i_clk);
        if( o_update == 1'b1 ) begin
            i_port      <= 4'd15   ;
            i_port_vld  <= 1'b1    ;

        end else begin
            i_port      <= 'b0   ;
            i_port_vld  <= 1'b0  ;

        end
    end
end

initial begin
    forever begin
        @(posedge i_clk);
        if( (|o_req) == 1'b1) begin
            i_resp      <= o_req   ;
        end else begin
            i_resp      <= 'b0;
        end
    end
end



endmodule