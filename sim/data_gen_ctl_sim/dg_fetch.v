
/***
file: dg_fetch.v
author: zfy
version: v10
description: fetch control-command for dg_fifo and control data_gen according to commands in order  

***/


module dg_fetch #(
    parameter   FIFO_W  = 32
)
(
    input clk,
    input rst_n,

    /*interface with fifo */
    input                   i_fifo_ready,
    input   [FIFO_W-1:0]    i_fifo_data,
    output  reg             o_fifo_rden,

    /*interface with data gen module */
    input                       i_dg_ready,
    output  reg     [3:0]       o_da,
    output  reg     [2:0]       o_prior,
    output  reg     [9:0]       o_len,
    output  reg                 o_vld

);




//FSM
localparam s_idle       =  2'd0;
localparam s_fetch      =  2'd1;
localparam s_wait       =  2'd2;
localparam s_send       =  2'd3;


reg     [3:0]       r_da;
reg     [2:0]       r_prior;
reg     [9:0]       r_len;
reg     [9:0]       r_wait_clk_num;


// cnt wait clk num
reg [9:0] cnt;
reg [9:0] wait_clk_num;

reg [1:0] cstate, nstate;

always @(posedge clk or negedge rst_n) begin
    if( !rst_n)
        cstate <= s_idle;
    else
        cstate <= nstate;
end


always @(*) begin
    if( !rst_n) begin
        nstate = s_idle;
    end
    else begin
        case( cstate ) 
            s_idle: begin
                if( i_fifo_ready && i_dg_ready )
                    nstate = s_fetch;
                else
                    nstate = s_idle;
            end
            s_fetch: begin
                if( i_fifo_data[26:17] == 'h0 )
                    nstate = s_send;
                else
                    nstate = s_wait;
            end
            s_wait: begin
                if( cnt ==  ( r_wait_clk_num - 'b1) )
                    nstate = s_send;
                else
                    nstate = s_wait;
            end
            s_send: begin
                nstate = s_idle;
            end
            default: begin
                nstate = s_idle;
            end
        endcase 
    end
end


always @(posedge clk or negedge rst_n) begin
    if( !rst_n ) begin
        o_fifo_rden <= 'b0;

        o_da <= 'b0;
        o_prior <= 'b0;
        o_len <= 'b0;
        o_vld <= 'b0;
    end
    else begin
        case( nstate ) 
            s_idle: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;
                o_fifo_rden <= 'b0;
            end
            s_fetch: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;
                o_fifo_rden <= 'b1;
            end
            s_wait: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;
                o_fifo_rden <= 'b0;
            end
            s_send: begin
                o_da <= r_da;
                o_prior <= r_prior;
                o_len <= r_len;
                o_vld <= 'b1;
                o_fifo_rden <= 'b0;
            end
            default: begin
                nstate = s_idle;
            end
        endcase 
    end

end




always @(posedge clk or negedge rst_n ) begin
    if( !rst_n ) begin
        r_da    <= 'b0;
        r_prior <= 'b0;
        r_len   <= 'b0;
        r_wait_clk_num <= 'b0;
    end
    else begin
        if( nstate == s_fetch) begin
            r_da <= i_fifo_data[3:0];
            r_prior <= i_fifo_data[6:4];
            r_len <= i_fifo_data[16:7];
            r_wait_clk_num <= i_fifo_data[26:17];
        end
        else begin
            r_da <= r_da;
            r_prior <= r_prior ;
            r_len <= r_len;
            r_wait_clk_num <= r_wait_clk_num;
        end
    end
end



always @(posedge clk or negedge rst_n ) begin
    if( !rst_n || nstate == s_idle ) 
        cnt <= 'b0;
    else begin
        if( nstate == s_wait )
            cnt <= cnt + 'b1;
        else
            cnt <= cnt ;
    end
end




endmodule

