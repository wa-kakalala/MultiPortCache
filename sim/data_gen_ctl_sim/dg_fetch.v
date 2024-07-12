
/***
file: dg_fetch.v
author: zfy
version: v10
description: fetch control-command for dg_fifo and control data_gen according to commands in order  

***/


module dg_fetch #(
    parameter   DATA_W  = 32,
    parameter   ADDR_W  = 10
)
(
    input clk,
    input rst_n,

    /* interface of config*/
    input       [ADDR_W-1:0]          fetch_n, //the number of packets fetched

    /*interface with sram */
    input       [DATA_W-1:0]    i_sram_data,
    output  reg                 o_sram_rden,
    output  reg [ADDR_W-1:0]    o_sram_addr,

    /*interface with data gen module */
    input                       i_dg_ready,
    output  reg     [3:0]       o_da,
    output  reg     [2:0]       o_prior,
    output  reg     [9:0]       o_len,
    output  reg                 o_vld

);




//FSM
localparam s_idle       =  3'd0;
localparam s_fetch      =  3'd1;
localparam s_get        =  3'd2;
localparam s_wait       =  3'd3;
localparam s_send       =  3'd4;


reg     [3:0]       r_da;
reg     [2:0]       r_prior;
reg     [9:0]       r_len;
reg     [9:0]       r_wait_clk_num;


// cnt wait clk num
reg [9:0] cnt_wait;

//sended packet number
reg [ADDR_W-1 : 0]  sended_n;
// reg [$clog2(fetch_n)-1 : 0]  sended_n;


reg [2:0] cstate, nstate;
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
                if( (sended_n < fetch_n) && i_dg_ready )
                    nstate = s_fetch;
                else
                    nstate = s_idle;
            end
            s_fetch: begin
                    nstate = s_get;
            end
            s_get: begin
                    nstate = s_wait;
            end
            s_wait: begin
                if( r_wait_clk_num== 'b0 ||  cnt_wait >=  ( r_wait_clk_num-'b1) )
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
        o_sram_rden <= 'b0;
        o_sram_addr <= 'b0;

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

                o_sram_rden <= 'b0;
                o_sram_addr <= o_sram_addr;
            end
            s_fetch: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;

                o_sram_rden <= 'b1;
                o_sram_addr <= o_sram_addr;
            end
            s_get: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;

                o_sram_rden <= 'b0;
                o_sram_addr <= o_sram_addr + 'b1;
            end
            s_wait: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;
                
                o_sram_rden <= 'b0;
                o_sram_addr <= o_sram_addr;
            end
            s_send: begin
                o_da <= r_da;
                o_prior <= r_prior;
                o_len <= r_len;
                o_vld <= 'b1;

                o_sram_rden <= 'b0;
                o_sram_addr <= o_sram_addr;
            end
            default: begin
                o_da <= 'b0;
                o_prior <= 'b0;
                o_len <= 'b0;
                o_vld <= 'b0;

                o_sram_rden <= 'b0;
                o_sram_addr <= o_sram_addr;
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
        if( cstate == s_get) begin
            r_da <= i_sram_data[3:0];
            r_prior <= i_sram_data[6:4];
            r_len <= i_sram_data[16:7];
            r_wait_clk_num <= i_sram_data[26:17];
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
        cnt_wait <= 'b0;
    else begin
        if( nstate == s_wait )
            cnt_wait <= cnt_wait + 'b1;
        else
            cnt_wait <= cnt_wait ;
    end
end

always @(posedge clk or negedge rst_n ) begin
    if( !rst_n ) begin
        sended_n <= 'b0;
    end
    else begin
        if( nstate == s_send ) begin
            sended_n <= sended_n + 'b1;
        end
        else begin
            sended_n <= sended_n ;
        end
    end
end


endmodule

