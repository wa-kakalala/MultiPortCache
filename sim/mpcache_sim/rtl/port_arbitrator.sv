/**************************************
@ filename    : port_arbitrator.sv
@ author      : yyrwkk
@ create time : 2024/05/17 16:36:51
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module port_arbitrator#(
    parameter PORTNUM  = 16 
)(
    input  logic               i_clk        ,
    input  logic               i_rst_n      ,

    input  logic [PORTNUM-1:0] i_req        ,
    input  logic               i_eop        ,
    input  logic               i_ready,

    output logic               o_port_ready ,
    output logic [PORTNUM-1:0] o_resp       ,
    output logic [PORTNUM-1:0] o_nresp      ,

    output logic                       o_en ,
    output logic [$clog2(PORTNUM)-1:0] o_sel  
);

logic                       working         ;
logic [$clog2(PORTNUM)-1:0] bin_sel         ;
logic [PORTNUM-1:0]         sel             ;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        working <= 'b0 ;
    end else if( working == 1'b0 && (i_req!='b0)&& (i_ready!='b0)) begin
        working <= 1'b1;
    end else if(  working == 1'b1 && i_eop == 1'b1 ) begin
        working <= 1'b0;
    end else begin
        working <= working;
    end
end

// prior16_encode prior16_encode_inst(
//     .i_data   (i_req  ),
//     .i_rst_n  (i_rst_n),
//     .o_d_vld  (sel_vld),
//     .o_sel    (sel  ) 
// );

round_robin_arbiter # (
    .N_REQ  (PORTNUM)   // N must be at least 2
)round_robin_arbiter_inst(
    .i_clk   (i_clk  ),
    .i_rst_n (i_rst_n),
    .i_req   (i_req  ),
    .o_grant (sel    )
);

logic sel_en  ;  // 

always_ff@(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        sel_en <= 1'b0;
    end else begin
        if(working == 1'b0 && (i_req!='b0)&& (i_ready!='b0)) begin
            sel_en <= 1'b1;
        end else begin
            sel_en <= 1'b0;
        end
    end
end

onehot2bin #(
    .ONE_HOT_WIDTH(PORTNUM)
)onehot2bin_inst(
    .one_hot_code( sel        ) ,
    .bin_code    ( bin_sel    )
);   

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        o_en  <= 1'b0;
    end else begin
        if( sel_en ) begin
            o_en  <= 1'b1;
        end else if(  working == 1'b1 && i_eop == 1'b1 ) begin
            o_en  <= 1'b0;
        end else begin
            o_en  <= o_en;
        end
    end
end

always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        o_sel <= 'b0;
    end else begin
        if( sel_en ) begin
            o_sel <= bin_sel;
        end else begin
            o_sel <= o_sel;
        end
    end 
end

always_comb begin
    if( !i_rst_n ) begin
        o_resp       = 'b0;
        o_nresp      = 16'hff_ff;
    end else if( sel_en  ) begin
        o_resp       =  sel;
        o_nresp      = ~sel;
    end else begin
        o_resp       <= 'b0;
        o_nresp      <= 16'hff_ff;
    end
end

assign o_port_ready = ~working;

endmodule