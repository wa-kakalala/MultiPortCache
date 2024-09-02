/**************************************
@ filename    : channel_req.sv
@ author      : yyrwkk
@ create time : 2024/07/11 00:52:56
@ version     : v1.0.0
**************************************/
`timescale 1ns/1ps
module channel_req # (
    parameter       PORTNUM  =  16    ,
    parameter       DWIDTH   =  32    ,
    parameter       RAMWIDTH =  10    ,
    parameter       NPACKLEN =  8     ,
    parameter [3:0] PORT_ID  =  4'd0
)(
    input  logic                i_clk                   ,
    input  logic                i_rst_n                 ,

    input  logic [DWIDTH-1:0 ]  i_data                  ,

    input  logic                i_empty                 ,
    input  logic [PORTNUM-1:0 ] i_resp                  ,
    input  logic [PORTNUM-1:0 ] i_nresp                 ,

    input  logic [RAMWIDTH-1:0] i_ramspace [PORTNUM-1:0],
    input  logic [PORTNUM-1:0 ] i_ready                 ,
    
    output logic [PORTNUM-1:0]  o_req                   ,

    output logic [DWIDTH-1:0]   o_data                  ,
    output logic                o_data_vld              ,
    output logic                o_eop                   ,

    output logic                o_rd_en       
);

localparam s_idle      = 3'd0  ;
localparam s_rd_fifo   = 3'd1  ;
localparam s_arb       = 3'd2  ;
localparam s_req       = 3'd3  ;
localparam s_wait      = 3'd4  ;
localparam s_pre_rd    = 3'd5  ;
localparam s_send      = 3'd6  ;

logic [2:0]  curr_state        ;
logic [2:0]  next_state        ;

logic                       arb_sel_vld       ;
logic [$clog2(PORTNUM)-1:0] arb_sel_shift     ;
logic [$clog2(PORTNUM)-1:0] arb_sel           ;

logic [NPACKLEN-1:0] send_times;

logic [DWIDTH-1:0  ] packet_hdr;

logic [NPACKLEN-1:0] need_times;


logic rd_en_reg;

always_ff @(posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        rd_en_reg <= 'b0;
    end else begin
        rd_en_reg <= o_rd_en;
    end
end

always_ff @( posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        packet_hdr <= 'b0;
    end else if( rd_en_reg ) begin
        packet_hdr <= i_data;
    end else begin
        packet_hdr <= packet_hdr;
    end
end

always_ff @ (posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        curr_state <= s_idle;
    end else begin
        curr_state <= next_state;
    end
end

logic [PORTNUM-1:0] ramspace_status ;
genvar port_i;
generate    
    for( port_i = 0;port_i<PORTNUM;port_i = port_i + 1'b1 ) begin: ramspace_status_block
        if( port_i >= PORT_ID ) begin
            assign ramspace_status[port_i] =  (i_ready[port_i-PORT_ID]) & 
                (((i_data[16:7] + 11'd4 ) >> 6 ) + |(((i_data[16:7] + 11'd4 ) )) <= i_ramspace[port_i-PORT_ID] ? 1'b1:1'b0 );
        end else begin // use 4'd15 , need to optimize in the future
            assign ramspace_status[port_i] =  (i_ready[4'd15 - PORT_ID + port_i + 1'b1]) & 
                (((i_data[16:7] + 11'd4 ) >> 6 ) + |(((i_data[16:7] + 11'd4 ) )) <= i_ramspace[4'd15 - PORT_ID + port_i + 1'b1] ? 1'b1:1'b0);
        end
    end
endgenerate

prior16_encode  # (
    .TARGET ( 1'b1 )
)prior16_encode_inst(
    .i_data   (ramspace_status),
    .i_rst_n  (i_rst_n        ),
    .o_d_vld  (arb_sel_vld    ),
    .o_sel    (arb_sel_shift  )
);

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        arb_sel <= 'b0;
    end else if( rd_en_reg ) begin
        arb_sel <= arb_sel_shift + PORT_ID; // cut down to 4bit 
    end else begin
        arb_sel <= arb_sel;
    end
end

always_comb begin 
    if( !i_rst_n ) begin
        next_state = s_idle ;
    end else begin
        case( curr_state )
        s_idle   : begin
            if( !i_empty ) begin
                next_state = s_rd_fifo; 
            end else begin
                next_state = s_idle;
            end
        end
        s_rd_fifo: begin
            if( rd_en_reg ) begin
                next_state = s_arb;  // the fifo must give out data after 1 clk 
            end else begin
                next_state = s_rd_fifo;
            end
        end
        s_arb    : begin
            if( arb_sel_vld ) begin
                next_state = s_req;
            end else begin
                next_state = s_arb;
            end
        end
        s_req    : begin
            next_state = s_wait;
        end
        s_wait   : begin
            if( i_resp [ arb_sel ] == 1'b1 ) begin
                next_state = s_pre_rd;
            end else if( i_nresp[ arb_sel ] == 1'b1 ) begin
                next_state = s_arb;
            end else begin
                next_state = s_wait;
            end
        end
        s_pre_rd : begin
            next_state = s_send;
        end
        s_send   : begin
            if( send_times == need_times) begin
                next_state = s_idle ;
            end else begin
                next_state = s_send ;
            end
        end
        default  : begin
            next_state = s_idle;
        end
        endcase 
    end
end

logic first_flag ;

always_ff @( posedge i_clk or negedge i_rst_n )begin
    if( !i_rst_n) begin
        o_req      <= 'b0;
        need_times <= 'b0;
        o_rd_en    <= 'b0;
        o_req      <= 'b0;
        send_times <= 'b0;
        o_data     <= 'b0;
        o_data_vld <= 'b0;
        first_flag <= 'b1;
    end else begin
        o_rd_en    <= 'b0 ;
        o_req      <= 'b0;
        need_times <= need_times;
        send_times <= send_times;
        o_data     <= 'b0;
        o_data_vld <= 'b0;
        first_flag <= 'b1;
        case( next_state ) 
        s_idle   : begin
            need_times <= 'b0;
            send_times <= 'b0;
        end
        s_rd_fifo: begin
            first_flag <= 1'b0;
            o_rd_en    <= first_flag;
        end
        s_arb    : begin
            need_times <= 9'b0 + i_data[16:9]  + (|i_data[8:7]) - 1'b1;
        end
        s_req    : begin
            o_req <= 'b1 << arb_sel;
        end
        s_wait   : begin
        end
        s_pre_rd: begin
            o_rd_en <= 1'b1 ;
        end
        s_send   : begin
            first_flag <= 1'b0;
            if( first_flag == 1'b1 ) begin
                o_data <= packet_hdr;
                o_data_vld <= 1'b1; 
                o_rd_en <= 1'b1 ;
                send_times <=  1'b0;
            end else begin
                o_data <= i_data;
                o_data_vld <= 1'b1; 
                o_rd_en <= (send_times ==  (need_times-'d1)) ? 1'b0: 1'b1; 
                send_times <= send_times + 1'b1;
            end
        end
        default  : begin
            
        end
        endcase
    end
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        o_eop <= 1'b0;
    end else if( send_times == need_times - 1'b1 ) begin
        o_eop <= 1'b1;
    end else begin
        o_eop <= 1'b0;
    end
end

endmodule