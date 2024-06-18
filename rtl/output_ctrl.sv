/**************************************
@ filename    : output_ctrl.sv
@ author      : yyrwkk
@ create time : 2024/05/17 20:47:22
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module output_ctrl#(
    parameter PORTNUM        =  16,
    parameter BLK_ADDR_WIDTH =  10,
    parameter LEN_WIDTH      =  10,
    parameter TIMES_WIDTH    =  4 ,
    parameter QUE_LEN_WIDTH  =  5
)(
    input  logic                       i_clk          ,
    input  logic                       i_rst_n        ,
     
    input  logic [$clog2(PORTNUM)-1:0] i_port         ,
    input  logic                       i_port_vld     ,
    input  logic [BLK_ADDR_WIDTH-1:0 ] i_blk_addr     ,
    input  logic                       i_blk_addr_vld ,
 
    input  logic [LEN_WIDTH-1:0 ]      i_len          ,
    input  logic                       i_len_vld      ,

    input  logic                       i_r_done       ,
     
    output logic [BLK_ADDR_WIDTH-1:0 ] o_blk_addr     ,
    output logic                       o_blk_addr_vld ,

    output logic [$clog2(PORTNUM)-1:0] o_port         ,
    output logic                       o_port_vld     ,
    output logic                       o_addr_rdy     ,
 
    output logic                       o_last_blk_vld ,
    output logic [TIMES_WIDTH-1:0    ] o_last_r_times     
);

localparam s_idle       =  4'd0;
localparam s_send_port  =  4'd1;
localparam s_send_rdy   =  4'd2;
localparam s_get_addr   =  4'd3;
localparam s_wait_len   =  4'd4;
localparam s_len        =  4'd5;
localparam s_wait_done  =  4'd6;
localparam s_last_send  =  4'd7;
localparam s_rls        =  4'd8;

logic [3:0] curr_state;
logic [3:0] next_state;

logic [LEN_WIDTH-1:0      ]   len         ;
logic [QUE_LEN_WIDTH-1:0  ]   send_times  ;
logic [TIMES_WIDTH-1:0    ]   last_r_times;
logic [$clog2(PORTNUM)-1:0]   port        ; 

always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n ) begin
        port <= 'b0;
    end else if(i_port_vld)begin
        port <= i_port;
    end else begin
        port <= port;
    end
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n ) begin
        curr_state <= s_idle;
    end else begin
        curr_state <= next_state;
    end
end



always_comb begin
    if( !i_rst_n ) begin
        next_state = s_idle;
    end else begin
        case(curr_state)
        s_idle     : begin
            if( i_port_vld ) begin
                next_state = s_send_port;
            end else begin
                next_state = s_idle;
            end
        end
        s_send_port    : begin
            next_state = s_send_rdy;
        end
        s_send_rdy: begin
            if( i_blk_addr_vld == 1'b1) begin
                if(send_times == 'b1 ) begin
                    next_state = s_last_send;
                end else begin
                    next_state = s_get_addr;
                end
            end else begin
                next_state = s_send_rdy;
            end
        end
        s_get_addr     : begin
            if( len == 'b0 ) begin
                next_state = s_wait_len;
            end else begin
                next_state = s_wait_done;
            end
        end
        s_wait_len : begin
            if( i_len_vld == 1'b1 ) begin
                next_state = s_len;
            end else begin
                next_state = s_wait_len;
            end
        end
        s_len      : begin
            next_state = s_wait_done;
        end
        s_wait_done: begin
            if( i_r_done == 1'b1 ) begin
                next_state = s_send_rdy;
            end else begin
                next_state = s_wait_done;
            end
        end
        s_last_send: begin
            if( i_r_done == 1'b1  ) begin
                next_state = s_rls;
            end else begin
                next_state = s_last_send;
            end
        end
        s_rls: begin
            next_state = s_idle;
        end
        default: begin
            next_state = s_idle;
        end
        endcase
    end
end

logic   first_flag   ;
always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n ) begin
        o_blk_addr     <= 'b0;
        o_blk_addr_vld <= 'b0;
        o_last_blk_vld <= 'b0;
        o_last_r_times <= 'b0;
        len            <= 'b0;
        send_times     <= 'b0;
        last_r_times   <= 'b0;
        first_flag     <= 'b0;
        o_port         <= 'b0;
        o_port_vld     <= 'b0;
        o_addr_rdy     <= 'b0;
    end else begin
        o_blk_addr     <= 'b0;
        o_blk_addr_vld <= 'b0;
        o_last_blk_vld <= 'b0;
        o_last_r_times <= 'b0;
        len            <= len         ;
        send_times     <= send_times  ;
        last_r_times   <= last_r_times;
        first_flag     <= 'b0;
        o_port         <= 'b0;
        o_port_vld     <= 'b0;
        o_addr_rdy     <= 'b0;
        case(next_state)
        s_idle     : begin
            len            <= 'b0;
            send_times     <= 'b0;
            last_r_times   <= 'b0;
        end
        s_send_port    : begin
            o_port     <= (i_port_vld==1'b1)?i_port:port;
            o_port_vld <= 1'b1   ;
        end
        s_send_rdy: begin
            o_addr_rdy <= 1'b1;
        end
        s_get_addr     : begin
            o_blk_addr <= i_blk_addr;
            o_blk_addr_vld <= 1'b1;
            if(send_times != 'b0) begin
                send_times <= send_times -1'b1;
            end else begin
                send_times <= send_times;
            end
        end
        s_wait_len : begin
        end
        s_len      : begin
            send_times   <= ((i_len + 11'd4 ) >> 6 ) + |((i_len + 11'd4 ) & 11'b111_111)-1'b1;
            last_r_times <= (((i_len + 11'd4 ) & 11'b111_111) >> 2) + |((i_len + 11'd4 ) & 11'b11) - 'b1 ;
            // send_times   <= ((i_len  ) >> 6 ) + |((i_len  ) & 11'b111_111) - 'b1;
            // last_r_times <= (((i_len ) & 11'b111_111) >> 2) + |((i_len  ) & 11'b11) - 'b1 ;
            len <= i_len;
        end
        s_wait_done: begin
        end
        s_last_send: begin
            o_blk_addr <= i_blk_addr;
            o_blk_addr_vld <= ~first_flag;
            o_last_blk_vld <= ~first_flag;
            o_last_r_times <= last_r_times;
            first_flag <= 1'b1;
        end
        s_rls: begin
            o_addr_rdy <= 1'b1;
        end
        default: begin
        end
        endcase
    end
end

endmodule