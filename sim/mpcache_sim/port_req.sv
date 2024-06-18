/**************************************
@ filename    : port_req.sv
@ author      : yyrwkk
@ create time : 2024/05/17 14:35:01
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module port_req#(
    parameter  PORTNUM  =  16  
)(
    input  logic                       i_clk        ,
    input  logic                       i_rst_n      ,
 
    input  logic                       i_que_vld    ,
 
    input  logic                       i_empty      ,
 
    input  logic [PORTNUM-1:0]         i_port_ready ,
    input  logic [PORTNUM-1:0]         i_resp       ,
    input  logic [PORTNUM-1:0]         i_nresp      ,
 
    input  logic [$clog2(PORTNUM)-1:0] i_port       ,
    input  logic                       i_port_vld   ,
 
    input  logic                       i_r_finish   ,
 
    output logic                       o_update     ,
    output logic                       o_port_vld   ,
    output logic [$clog2(PORTNUM)-1:0] o_port       ,
    output logic [$clog2(PORTNUM)-1:0] o_clr_port   ,
    output logic                       o_clr_vld    ,
 
    output logic [PORTNUM-1:0]         o_req          
);

localparam s_idle     = 3'd0;
localparam s_update   = 3'd1;
localparam s_getport  = 3'd2;
localparam s_req      = 3'd3;
localparam s_clr_port = 3'd4;
localparam s_r_sram   = 3'd5;

logic [2:0]                 curr_state  ;
logic [2:0]                 next_state  ;
logic [$clog2(PORTNUM)-1:0] port        ;

always @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n) begin
        port <= 'b0;
    end else if( i_port_vld )begin
        port <= i_port;
    end else begin
        port <= port;
    end
end

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n) begin
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
        s_idle    : begin
            if(i_que_vld ) begin
                next_state = s_update;
            end else begin
                next_state = s_idle;
            end
        end
        s_update  : begin
            if( i_port_vld) begin
                next_state = s_getport;
            end else begin
                next_state = s_update;
            end
        end
        s_getport : begin
            if( i_port_ready[i_port] == 1'b1 ) begin
                next_state = s_req;
            end else begin
                next_state = s_clr_port;
            end
        end
        s_req     : begin
            if( i_resp[port] == 1'b1 ) begin
                next_state = s_r_sram;
            end else if(i_nresp[port]==1'b1) begin
                next_state = s_clr_port;
            end else begin
                next_state = s_req;
            end
        end
        s_clr_port: begin
            if(i_port_vld==1'b1) begin
                next_state = s_idle;
            end else if( i_empty == 1'b1 ) begin
                next_state = s_getport;
            end else begin
                next_state = s_clr_port;
            end
        end
        s_r_sram  : begin
            if( i_r_finish ) begin
                next_state = s_idle;
            end else begin
                next_state = s_r_sram;
            end
        end
        default: begin
            next_state = s_idle;
        end
        endcase
    end
end

logic first_flag   ;
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n) begin
        o_update     <= 'b0;
        o_port_vld   <= 'b0;
        o_port       <= 'b0;
        o_clr_port   <= 'b0;
        o_clr_vld    <= 'b0;
        o_req        <= 'b0;
        first_flag   <= 'b0;
    end else begin
        o_update     <= 'b0;
        o_port_vld   <= 'b0;
        o_port       <= 'b0;
        o_clr_port   <= 'b0;
        o_clr_vld    <= 'b0;
        o_req        <= 'b0;
        first_flag   <= 'b0;
        case(next_state)
        s_idle    : begin
            
        end
        s_update  : begin
            o_update <= ~first_flag;
            first_flag <= 1'b1;
        end
        s_getport : begin

        end
        s_req     : begin
            o_req <= ('b1 << port);
        end
        s_clr_port: begin
            first_flag    <= 'b1;
            o_clr_port <=  (first_flag == 1'b0)?port:'b0;
            o_clr_vld  <= ~first_flag;
        end
        s_r_sram  : begin
            first_flag    <= 'b1         ;
            o_port <=  (first_flag == 1'b0)?port:'b0;
            o_port_vld    <= ~first_flag;
        end
        default: begin
        end
        endcase
    end
end

endmodule