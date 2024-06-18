/**************************************
@ filename    : input_ctrl.sv
@ author      : yyrwkk
@ create time : 2024/05/13 21:58:25
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
`include "./mpcache.svh"
module input_ctrl(
    input  logic                       i_clk           ,
    input  logic                       i_rst_n         ,
  
    input  logic                       i_blk_addr_vld  ,
    input  logic [`BLK_ADDR_WIDTH-1:0] i_blk_addr      ,
   
    input  logic                       i_sop           ,
    input  logic                       i_wr_vld        ,
    input  logic [`DATA_WIDTH-1:0    ] i_wr_data       ,
    input  logic                       i_eop           ,
  
    output logic                       o_sop           ,
    output logic [`DA_WIDTH-1:0      ] o_da            ,
    output logic [`PRORITY_WIDTH-1:0 ] o_prority       ,
    output logic                       o_hdr_vld       ,
    output logic [`BLK_ADDR_WIDTH-1:0] o_blk_addr      ,
    output logic                       o_blk_addr_vld  ,
    output logic                       o_eop           ,
  
    output logic [`BLK_ADDR_WIDTH-1:0] o_sram_addr     ,
    output logic                       o_sram_addr_vld ,

    output logic                       o_addr_req   
);

localparam s_idle       =  3'd0;
localparam s_wait       =  3'd1;
localparam s_init       =  3'd2;
localparam s_init_wait  =  3'd3;
localparam s_fifo2sram  =  3'd4;
localparam s_lfifo2sram =  3'd5;

logic [2:0]  curr_state        ;
logic [2:0]  next_state        ;

logic [4:0]  need_req_times    ;
logic [3:0]  wr_times          ;
logic [3:0]  last_wr_times     ;
logic        addr_req_done     ;
                     
logic [`BLK_ADDR_WIDTH-1:0] blk_addr;
always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n) begin
        blk_addr <= 'b0;
    end if( i_blk_addr_vld) begin
        blk_addr <= i_blk_addr;
    end else begin
        blk_addr <= blk_addr;
    end
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n) begin
        curr_state <= s_idle;
    end begin
        curr_state <= next_state;
    end
end

always_comb begin
    if( !i_rst_n )  begin
        next_state = s_idle;
    end else begin
        case(curr_state) 
        s_idle: begin
            if( i_sop ) begin
                next_state = s_wait;
            end else begin
                next_state = s_idle;
            end
        end
        s_wait: begin
            if( i_wr_vld ) begin
                next_state = s_init;
            end else begin
                next_state = s_wait;   
            end
        end
        s_init: begin
            next_state = s_init_wait;
        end
        s_init_wait: begin
            if( i_blk_addr_vld ) begin
                next_state = s_fifo2sram;
            end else begin
                next_state = s_init_wait;
            end
        end
        s_fifo2sram: begin
            if(wr_times == 'd15 && (need_req_times == 'd1)) begin
                next_state = s_lfifo2sram;
            end else begin
                next_state = s_fifo2sram;
            end
        end
        s_lfifo2sram: begin
            if( (wr_times == last_wr_times)) begin
                next_state = s_idle;
            end else begin
                next_state = s_lfifo2sram;
            end
        end 
        default: begin
            next_state = s_idle;
        end
        endcase
    end
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin 
    if( !i_rst_n ) begin
        o_sop          <= 'b0           ;
        o_da           <= 'b0           ;
        o_prority      <= 'b0           ;
        o_hdr_vld      <= 'b0           ;
        o_blk_addr     <= 'b0           ;
        o_blk_addr_vld <= 'b0           ;
        o_eop          <= 'b0           ;
        need_req_times <= 'b0           ;
        wr_times       <= 'b0           ;
        last_wr_times  <= 'b0           ;
        o_addr_req     <= 'b0           ;
        o_sram_addr    <= 'b0           ;
        o_sram_addr_vld<= 'b0           ;
        addr_req_done  <= 'b0           ;
    end else begin
        o_sop          <= 'b0           ;
        o_da           <= 'b0           ;
        o_prority      <= 'b0           ;
        o_hdr_vld      <= 'b0           ;
        o_blk_addr     <= 'b0           ;
        o_blk_addr_vld <= 'b0           ;
        o_eop          <= 'b0           ;
        o_addr_req     <= 'b0           ;
        last_wr_times  <= last_wr_times ;
        need_req_times <= need_req_times;
        wr_times       <= wr_times      ;
        o_sram_addr    <= 'b0           ;
        o_sram_addr_vld<= 'b0           ;
        addr_req_done  <= 'b0           ;
        case(next_state)
        s_idle: begin
            last_wr_times  <= 'b0;
            need_req_times <= 'b0;
            wr_times       <= 'b0;
        end
        s_wait: begin
            need_req_times <= 'b0;
        end
        s_init: begin
            o_hdr_vld<='b1;
            o_da<= i_wr_data[3:0];
            o_prority <= i_wr_data[6:4];
            //need_req_times <= ((i_wr_data[16:7] + 11'd4 ) >> 6 ) + ((((i_wr_data[16:7] + 11'd4 ) & 11'b111_111 == 'b0 ))? 1'b0 : 1'b1);  // maybe bug
            //last_wr_times  <= (((i_wr_data[16:7] + 11'd4 ) & 11'b111_111) >> 2) + (((((i_wr_data[16:7] + 11'd4 ) & 11'b111_111) >> 2) & 'b11 == 'b0)?1'b0:1'b1);
            need_req_times <= ((i_wr_data[16:7] + 11'd4 ) >> 6 ) + |(((i_wr_data[16:7] + 11'd4 ) ) & 11'b111_111);  // maybe bug
            last_wr_times  <= (((i_wr_data[16:7] + 11'd4 ) & 11'b111_111) >> 2) + |((i_wr_data[16:7] + 11'd4 ) & 11'b11 ) - 1'b1;
            o_addr_req <= 1'b1;
            o_sop <= 1'b1;
            wr_times <= 'd15;
        end
        s_init_wait: begin
            
        end
        s_fifo2sram: begin
            if( wr_times == 'd15 ) begin
                o_sram_addr <= (i_blk_addr_vld == 'b1)?i_blk_addr:blk_addr;
                wr_times <= 'd0;
            end else begin
                o_sram_addr <= o_sram_addr + 1'b1;
                wr_times <= wr_times + 1'b1;
            end

            need_req_times <= (wr_times == 'b0 ) ?need_req_times -'d1:need_req_times;

            o_addr_req      <=  (wr_times == 'd10) ? 1'b1:1'b0;
            o_blk_addr      <=  (i_blk_addr_vld == 'b1)?i_blk_addr:'b0;
            o_blk_addr_vld  <=  i_blk_addr_vld;
            o_sram_addr_vld <= 1'b1;
            o_eop           <=  (i_blk_addr_vld == 'b1 && need_req_times == 'd1)?1'b1:1'b0;

        end
        s_lfifo2sram: begin
            if( wr_times == 'd15 ) begin
                o_sram_addr <= blk_addr;
                wr_times <= 'd0;
            end else begin
                o_sram_addr <= o_sram_addr + 1'b1;
                wr_times <= wr_times + 1'b1;
            end
            o_sram_addr_vld <= 1'b1;
        end 
        default: begin

        end
        endcase
    end
end

endmodule