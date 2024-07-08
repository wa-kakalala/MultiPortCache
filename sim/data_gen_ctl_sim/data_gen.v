
/***
author: zfy
version: 
description: 


***/

module data_gen #(
    parameter   DW = 32
)
(
    input   clk,
    input   rst_n,

    /* interface of packet header information input,  */
    input   [3:0]   i_da,
    input   [2:0]   i_prior,
    input   [9:0]   i_len,
    input           i_gen_vld,   // the packet header information valid

    /* interface of control,  */
    
    output          o_gen_ready, //only when o_gen_ready signal set, the packet header information can be input

    /* interface of packet out,  */
    output  reg     o_sop,
    output  reg     o_vld,
    output  reg     [DW-1:0] o_data,
    output  reg     o_eop
);


localparam LEN_W = 10; //1024 = 2^10

//cnt
reg [LEN_W:0] cnt; 

// packet header
reg [DW-1:0] packet_header;
reg          packet_load;

//rand
wire [DW-1:0] rand_data;


// data gen information
reg   [3:0]   r_da;
reg   [2:0]   r_prior;
reg   [9:0]   r_len;




//FSM
localparam s_idle       =  3'd0;
localparam s_send_ready       =  3'd1;
localparam s_send_sop       =  3'd2;
localparam s_send_data  =  3'd3;
localparam s_send_eop   =  3'd4;
localparam s_send_header = 3'd5;

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
                if( i_gen_vld )
                    nstate = s_send_ready;
                else
                    nstate = s_idle;
            end
            s_send_ready: begin
                nstate = s_send_sop;
            end
            s_send_sop: begin
                nstate = s_send_header;
            end
            s_send_header: begin
                nstate = s_send_data;
            end
            s_send_data: begin
                if( cnt >= r_len)
                    nstate = s_send_eop;
                else
                    nstate = s_send_data;
            end
            s_send_eop: begin
                nstate = s_idle;
            end
            default: begin
                nstate = s_idle;
            end
        endcase 
    end
end

always @(posedge clk or negedge rst_n) begin
    if( !rst_n || ( nstate == s_idle )) begin
        cnt <= 'b0;
    end
    else begin
        if( nstate == s_send_data )
            cnt <= cnt + {DW/8};
        else
            cnt <= cnt ;
    end
end


always @(posedge clk or negedge rst_n) begin
    if( !rst_n) begin
        packet_header   <= 'b0;
    end
    else begin
        if( i_gen_vld && cstate== s_idle )
            packet_header   <= { {(DW-17){1'b0}} , i_len, i_prior, i_da};
        else
            packet_header <= packet_header ;
    end
end


always @(posedge clk or negedge rst_n ) begin
    if( !rst_n ) begin
        r_da    <= 'b0;
        r_prior <= 'b0;
        r_len   <= 'b0;
    end
    else begin
        if( i_gen_vld && cstate== s_idle ) begin
            r_da <= i_da;
            r_prior <= i_prior;
            r_len <= i_len;
        end
        else begin
            r_da <= r_da;
            r_prior <= r_prior ;
            r_len <= r_len;
        end
    end
end


always @(posedge clk or negedge rst_n) begin
    if( !rst_n) begin
        packet_load   <= 'b0;
    end
    else begin
        if( nstate== s_send_sop )
            packet_load <= 'b1;
        else
            packet_load <= 'b0 ;
    end
end



// output generated packet signal based on FSM
always @(posedge clk or negedge rst_n) begin
    if( !rst_n ) begin
        o_sop   <=  'b0;
        o_data  <=  'b0;
        o_vld   <=  'b0;
        o_eop   <=  'b0;
    end
    else begin
        case( nstate ) 
            s_idle: begin
                o_sop   <=  'b0;
                o_data  <=  'b0;
                o_vld   <=  'b0;
                o_eop   <=  'b0;
            end
            s_send_ready: begin
                o_sop   <=  'b0;
                o_data  <=  o_data;
                o_vld   <=  'b0;
                o_eop   <=  'b0;
            end
            s_send_sop: begin
                o_sop   <=  'b1;
                o_data  <=  o_data;
                o_vld   <=  'b0;
                o_eop   <=  'b0;
            end
            s_send_header: begin
                o_sop   <=  'b0;
                o_data  <=  packet_header;
                o_vld   <=  'b1;
                o_eop   <=  'b0;
            end
            s_send_data: begin
                o_sop   <=  'b0;
                o_data  <=  rand_data;
                o_vld   <=  'b1;
                o_eop   <=  'b0;
            end
            s_send_eop: begin
                o_sop   <=  'b0;
                o_data  <=  o_data;
                o_vld   <=  'b0;
                o_eop   <=  'b1;
            end
            default: begin
                o_sop   <=  'b0;
                o_data  <=  'b0;
                o_vld   <=  'b0;
                o_eop   <=  'b1;
            end
        endcase 
    end
end


assign o_gen_ready = (cstate == s_idle)? 1'b1 : 1'b0;



//gen ramdom data
gen_rand #(
    .DW ( DW ),
    .RW ( 8 ) //number of DFF in Linear Feedback Shift Register(LFSR) to generate random
    )
 u_gen_rand (
    .rst_n                   ( rst_n         ),
    .clk                     ( clk           ),
    .i_load                  ( packet_load        ),
    .i_seed                  ( packet_header[7:0]        ),

    .o_rand_data             ( rand_data   )
);



endmodule