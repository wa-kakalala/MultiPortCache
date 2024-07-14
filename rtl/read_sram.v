
/***
author: zfy
version: V10
description:  read sram 

params：
    AWIDTH: DPRAM中 最小存储单元地址位宽（DWIDTH bit， 32bit）
    BLK_AWIDTH: rom manager 中 最小block 单元地址位宽
    DWIDTH： 默认32bit， 数据位宽

interface:
    interface:
    phead: 帧头，32bit


***/



module read_sram #(
    parameter AWIDTH = 14, 
    parameter BLK_AWIDTH = 10,
    parameter DWIDTH = 32
)
(
    input   wire                       clk             ,
    input   wire                       rst_n           ,


    //interface with arbitrater
    input   wire    [AWIDTH-1:0]            i_blk_addr       ,
    input   wire                        i_blk_addr_vld   ,
    input   wire                        i_is_last_blk                        ,
    input   wire    [AWIDTH-BLK_AWIDTH-1:0] i_last_blk_n    ,
    output  reg                         o_read_finish       ,
    input   wire                        i_start_packet        ,


    //interface with dpram
    output  reg                        o_sram_rd_en,
    output  reg    [AWIDTH-1:0]        o_sram_rd_addr,
    input   wire   [DWIDTH-1:0]        i_sram_rd_data,


    //interface with output port
    input  wire                        ready                      ,
    output reg                         rd_sop                     ,
    output reg                         rd_eop                     ,
    output wire                         rd_vld                     ,
    output wire     [DWIDTH-1:0]        rd_data                    ,

    output reg      [DWIDTH-1:0]        phead                       ,
    output reg                          phead_vld                   ,
    output reg                          crc_correct                 ,
    output reg                          crc_correct_vld                      


);


//表示 block 中 每个数据单元个数的位宽
    parameter UNIT_AWIDTH = AWIDTH -BLK_AWIDTH;

    reg [UNIT_AWIDTH-1:0] unit_count, unit_count_r1, unit_count_r2;
    reg unit_count_finish, unit_count_finish_r1, unit_count_finish_r2;
    reg [UNIT_AWIDTH-1:0] unit_count_tar;



//state machine for reading dpram
    reg [1:0] rdr_state;
    parameter IDLE = 2'b00, READ = 2'b01;

    //state transfer
    always@(posedge clk) begin
        if(!rst_n)
            rdr_state <= IDLE;
        else begin
            case(rdr_state)
                IDLE: begin
                    if( i_blk_addr_vld )
                        rdr_state <= READ;
                end
                READ: begin
                    if(unit_count_finish)
                        rdr_state <= IDLE; 
                end
                default: begin
                    rdr_state <= IDLE;
                end
            endcase
        end
    end

// count 
    // unit count tar
    always @(posedge clk) begin
        if( !rst_n)
            unit_count_tar <= 'b0;
        else begin
            if( i_blk_addr_vld ) begin
                unit_count_tar <= (i_is_last_blk)? i_last_blk_n : {UNIT_AWIDTH{1'b1}};
            end
            else
                unit_count_tar <= unit_count_tar;
        end
    end

    // unit count
    always @(posedge clk) begin
        if( !rst_n || (rdr_state ==IDLE) ) begin
            unit_count <= 'b0;
        end
        else begin
            if( rdr_state == READ ) begin
                if( unit_count == unit_count_tar )
                    unit_count <= unit_count;
                else
                    unit_count <= unit_count + 1;
            end
        end
    end
    //compare unit count and tar count
    always @(*) begin
        if( unit_count == unit_count_tar && rdr_state == READ )
            unit_count_finish = 1'b1;
        else
            unit_count_finish = 1'b0;
    end

    always @(posedge clk) begin
        if( !rst_n ) begin
            o_read_finish <= 1'b0;
        end
        else begin
            o_read_finish <= unit_count_finish;
        end
    end


//sram read
    //    output  reg                        o_sram_rd_en,
    // output  reg    [AWIDTH-1:0]        o_sram_rd_addr,
    // input   wire   [DWIDTH-1:0]        i_sram_rd_data,
    always @(posedge clk) begin
        if( !rst_n ) begin
            o_sram_rd_en <= 1'b0;
        end
        else begin
            if( i_blk_addr_vld )
                o_sram_rd_en <= 1'b1;
            else if( unit_count_finish ) 
                o_sram_rd_en <= 1'b0;
            else 
                o_sram_rd_en <= o_sram_rd_en;
        end
    end

    reg [BLK_AWIDTH-1:0 ] blk_addr;
    always @(posedge clk) begin
        if( !rst_n ) begin
            blk_addr <= 'b0;
        end
        else begin
            if( i_blk_addr_vld )begin
                blk_addr <= i_blk_addr[AWIDTH-1:UNIT_AWIDTH];
            end
            else 
                blk_addr <= blk_addr;
        end
    end
    always @(*) begin
        o_sram_rd_addr =  {blk_addr, unit_count};  
    end



// fifo
    // wire [UNIT_AWIDTH+1+DWIDTH-1: 0] fifo_data;
    // // 记录 transfer（unit）个数 信息， 是否为最后一个transfer
    // assign fifo_data = {unit_count, unit_count_finish, i_sram_rd_data};
    wire [DWIDTH-1: 0] fifo_sram_data;
    assign fifo_sram_data = i_sram_rd_data;
    // fifo wr_en
    reg fifo_wr_en;
    reg [AWIDTH-1:0] fifo_sram_addr;
    always @(posedge clk) begin
        if( !rst_n) begin
            fifo_wr_en <= 1'b0;
            fifo_sram_addr <= 'b0;
        end
        else begin
            fifo_wr_en <= o_sram_rd_en;
            fifo_sram_addr <= o_sram_rd_addr;
        end
    end
    
    
    // fifo dout
    wire [DWIDTH-1: 0] fifo_dout;
    wire               fifo_empty;

    //
    fifo #(
        .DATA_WIDTH ( DWIDTH ),
        .ADDR_WIDTH ( 5 ),
        .FWFT_EN    ( 1 )
        )
    u_fifo (
        .din           (                fifo_sram_data            ),
        .wr_en         (                fifo_wr_en         ),
        .rd_en         (                  ready          ),
        .clk           (                  clk            ),
        .rst_n         (                  rst_n          ),

        .full          (                                 ),
        .almost_full   (                                 ),
        .dout          (            fifo_dout            ),
        .empty         (            fifo_empty           ),
        .almost_empty  (                       )
    );
    assign rd_data = fifo_dout;

//fifo_rd_vld fifo_rd_addr
    reg fifo_rd_vld;
    always @(posedge clk) begin
        if(!rst_n || !ready) begin
            fifo_rd_vld <= 1'b0;
        end
        else begin
            fifo_rd_vld <= fifo_wr_en;
        end
    end
    assign rd_vld = fifo_rd_vld;

    //fifo_rd_addr
    reg [AWIDTH-1:0] fifo_rd_addr;
    always @(posedge clk) begin
        if(!rst_n) begin
            fifo_rd_addr <= 'b0;
        end
        else begin
            if( ready )
                fifo_rd_addr <= fifo_sram_addr;
            else
                fifo_rd_addr <= fifo_rd_addr;
        end
    end



// start 
    reg start_packet_r;
    always @(posedge clk) begin
        if(!rst_n ||  phead_vld ) begin
            start_packet_r <= 1'b0;
        end
        else begin
            if( i_start_packet )
                start_packet_r <= 1'b1;
            else
                start_packet_r <= start_packet_r;
        end
    end

    always @( * ) begin
        if( start_packet_r && fifo_wr_en && (fifo_sram_addr[UNIT_AWIDTH-1:0]== {UNIT_AWIDTH{1'b0}} )) begin
            phead = fifo_sram_data;
            phead_vld = 1'b1;
            rd_sop = 1'b1;
        end
        else begin
            phead = 'b0;
            phead_vld = 1'b0;
            rd_sop = 1'b0;
        end
    end


// end
    reg end_packet_r;
    reg [UNIT_AWIDTH-1:0] end_packet_n;
    always @(posedge clk) begin
        if(!rst_n ||  crc_correct_vld ) begin
            end_packet_r <= 1'b0;
            end_packet_n <= 'b0;
        end
        else begin
            if( i_is_last_blk ) begin
                end_packet_r <= 1'b1;
                end_packet_n <= i_last_blk_n;
            end
            else begin
                end_packet_r <= end_packet_r;
                end_packet_n <= end_packet_n;

            end
        end
    end

    always @( posedge clk ) begin
        if( !rst_n ) begin
            crc_correct <= 1'b0;
            crc_correct_vld <= 1'b0;
            rd_eop <= 1'b0;
        end
        else begin
            if( end_packet_r && fifo_rd_vld && (fifo_rd_addr[UNIT_AWIDTH-1:0]== end_packet_n ) ) begin
                crc_correct <= 1'b1;
                crc_correct_vld <= 1'b1;
                rd_eop <= 1'b1;
            end
            else begin
                crc_correct <= 'b0;
                crc_correct_vld <= 1'b0;
                rd_eop <= 1'b0;
            end
        end
    end





endmodule