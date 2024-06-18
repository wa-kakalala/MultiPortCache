/**************************************
@ filename    : read_sram.v
@ author      : yyrwkk
@ create time : 2024/05/26 22:32:14
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module read_sram #(
    parameter AWIDTH     = 14, 
    parameter BLK_AWIDTH = 10,
    parameter DWIDTH     = 32
)(
    input  logic                         i_clk                ,
    input  logic                         i_rst_n              ,

    input  logic [AWIDTH-1:0]            i_blk_addr           ,
    input  logic                         i_blk_addr_vld       ,
    input  logic                         i_last_blk_vld       ,
    input  logic [AWIDTH-BLK_AWIDTH-1:0] i_last_blk_n         ,
 
    input  logic [DWIDTH-1:0]            i_sram_rd_data       ,
 
    output logic                         o_read_finish        ,
    output logic                         o_read_almost_finish ,
 
    output logic                         o_sram_rd_en         ,
    output logic [AWIDTH-1:0]            o_sram_rd_addr       ,

    output logic                         o_rd_sop             ,
    output logic                         o_rd_eop             ,
    output logic                         o_rd_vld             ,
    output logic [DWIDTH-1:0]            o_rd_data            ,

    output logic [DWIDTH-1:0]            o_pkt_hdr            ,
    output logic                         o_pkt_hdr_vld       
);

localparam s_idle         =  3'd0;
localparam s_rd_first_blk =  3'd1;
localparam s_send_hdr     =  3'd2;
localparam s_rd_sram      =  3'd3;
localparam s_rd_last_blk  =  3'd4;
localparam s_rd_end       =  3'd5;

logic [2:0] curr_state;
logic [2:0] next_state;

logic [AWIDTH-BLK_AWIDTH-1:0] rd_times     ;
logic [AWIDTH-BLK_AWIDTH-1:0] last_rd_times;
logic                         last_rd_blk  ;

logic [AWIDTH-1:0]            blk_addr     ;


always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if(!i_rst_n ) begin
        blk_addr <= 'b0;
    end else if(i_blk_addr_vld ) begin
        blk_addr <= i_blk_addr;
    end else begin
        blk_addr <= blk_addr;
    end 
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if(!i_rst_n || curr_state == s_idle ) begin
        last_rd_blk <= 'b0;
        last_rd_times <= 'b0;
    end else if(i_last_blk_vld ) begin
        last_rd_blk <= 1'b1;
        last_rd_times <= i_last_blk_n;
    end else begin
        last_rd_blk <= last_rd_blk;
        last_rd_times <= last_rd_times;
    end 
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if(!i_rst_n ) begin
        curr_state <= s_idle;
    end else begin
        curr_state <= next_state;
    end
end

always_comb begin
    if( !i_rst_n )  begin
        next_state = s_idle;
    end else begin
       case (curr_state)
       s_idle         : begin
            if( i_blk_addr_vld ) begin
                next_state = s_rd_first_blk;
            end else begin
                next_state = s_idle;
            end
       end
       s_rd_first_blk : begin
            next_state = s_send_hdr;
       end
       s_send_hdr     : begin
            next_state = s_rd_sram;
       end
       s_rd_sram      : begin
            if(rd_times == 'd15 && last_rd_blk == 1'b1 ) begin
                next_state = s_rd_last_blk;
            end else begin
                next_state = s_rd_sram;
            end
       end
       s_rd_last_blk  : begin
            if( rd_times == last_rd_times ) begin
                next_state = s_rd_end     ;
            end else begin
                next_state = s_rd_last_blk;
            end
       end
       s_rd_end       : begin
            next_state = s_idle     ;
       end
       default        : begin
            next_state = s_idle     ;
       end
       endcase
    end
end

always_ff@( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n )  begin
        o_read_finish       <= 'b0;
        o_read_almost_finish<= 'b0;
        o_sram_rd_en        <= 'b0;
        o_sram_rd_addr      <= 'b0;
        o_rd_sop            <= 'b0;
        o_rd_eop            <= 'b0;
        o_rd_vld            <= 'b0;
        rd_times            <= 'b0;
        o_pkt_hdr_vld       <= 'b0;
    end else begin
        o_read_finish       <= 'b0;
        o_read_almost_finish<= 'b0;
        o_sram_rd_en        <= 'b0;
        o_sram_rd_addr      <= 'b0;
        o_rd_sop            <= 'b0;
        o_rd_eop            <= 'b0;
        o_rd_vld            <= 'b0;
        o_pkt_hdr_vld       <= 'b0;
        rd_times            <= rd_times;
        case( next_state )
        s_idle        : begin
        end
        s_rd_first_blk: begin
            o_sram_rd_addr <= i_blk_addr;
            o_sram_rd_en   <= 1'b1;
            o_rd_sop       <= 1'b1;
        end
        s_send_hdr    : begin
            o_sram_rd_addr <= o_sram_rd_addr+1'b1;
            o_pkt_hdr_vld  <= 1'b1;
            o_sram_rd_en   <= 1'b1;
            rd_times       <= rd_times +1'b1;
            o_rd_vld       <= 1'b1;
        end
        s_rd_sram     : begin
            if(rd_times == 'd15 ) begin
                o_sram_rd_addr <= blk_addr;
                rd_times       <= 'b0;
            end else begin
                o_sram_rd_addr <= o_sram_rd_addr+1'b1;
                rd_times       <= rd_times +1'b1;
            end

            o_read_finish <= (rd_times == 'd15) ? 1'b1 : 1'b0;
            o_read_almost_finish <= (rd_times == 'd7) ? 1'b1 : 1'b0;
            o_sram_rd_en   <= 1'b1;
            o_rd_vld       <= 1'b1;
        end
        s_rd_last_blk : begin
            //o_read_almost_finish <= 1'b1;
            if(rd_times == 'd15 ) begin
                o_sram_rd_addr <= blk_addr;
                rd_times       <= 'b0;
            end else begin
                o_sram_rd_addr <= o_sram_rd_addr+1'b1;
                rd_times       <= rd_times +1'b1;
            end
            o_sram_rd_addr <= o_sram_rd_addr+1'b1;
            o_sram_rd_en   <= 1'b1;
            o_rd_vld       <= 1'b1;
        end
        s_rd_end      : begin
            o_read_almost_finish <= 1'b1;
            o_rd_eop       <= 1'b1;
        end
        default       : begin
        end
        endcase
    end
end
assign o_rd_data = (o_rd_vld == 1'b1)?i_sram_rd_data:'b0;

assign o_pkt_hdr = (o_pkt_hdr_vld==1'b1)?i_sram_rd_data:'b0;;

endmodule