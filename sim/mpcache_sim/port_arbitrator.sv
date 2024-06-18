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

    output logic               o_port_ready ,
    output logic [PORTNUM-1:0] o_resp       ,
    output logic [PORTNUM-1:0] o_nresp      ,

    output logic [$clog2(PORTNUM)-1:0] o_sel  
);

logic                       working         ;
logic                       sel_vld         ; 
//logic [$clog2(PORTNUM)-1:0] sel             ;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        working <= 'b0 ;
    end else if( working == 1'b0 && (i_req!='b0)) begin
        working <= 1'b1;
    end else if(  working == 1'b1 && i_eop == 1'b1 ) begin
        working <= 1'b0;
    end else begin
        working <= working;
    end
end

prior16_encode prior16_encode_inst(
    .i_data   (i_req  ),
    .i_rst_n  (i_rst_n),
    .o_d_vld  (sel_vld),
    .o_sel    (o_sel  ) 
);

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        o_resp       <= 'b0;
        o_nresp      <= 'b0;
    end else if( working == 1'b0 && (i_req!='b0)) begin
        o_resp       <=  ('b1 << o_sel  );
        o_nresp      <= ~('b1 << o_sel  );
    end else begin
        o_resp       <= 'b0;
        o_nresp      <= 'b0;
    end
end

assign o_port_ready = ~working;

endmodule