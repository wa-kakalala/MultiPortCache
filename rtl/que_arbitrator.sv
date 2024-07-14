/**************************************
@ filename    : qu_arbitrator.sv
@ author      : yyrwkk
@ create time : 2024/05/16 19:47:19
@ version     : v1.0.0
**************************************/
module que_arbitrator # (
    parameter PORTNUM = 16    ,
    parameter PRIOR   = 8   
)(
    input  logic                       i_clk                 ,
    input  logic                       i_rst_n               ,

    input  logic [PORTNUM-1:0]         i_pending             ,
    input  logic [$clog2(PRIOR)-1:0]   i_prior [PORTNUM-1:0] ,
    
    input  logic                       i_update              ,
    
    input  logic [$clog2(PORTNUM)-1:0] i_clr_port            ,
    input  logic                       i_clr_vld             ,


    output logic [$clog2(PORTNUM)-1:0] o_port                ,
    output logic                       o_port_vld            ,
    
    output logic                       o_empty            
);

logic [PORTNUM-1:0] port_pend               ;
logic [PRIOR-1:0  ] prior     [PORTNUM-1:0] ;

genvar idx;
generate 
    for(idx=0;idx<PORTNUM;idx=idx+1) begin: prior_block
        always_ff @(posedge i_clk or negedge i_rst_n) begin
            if( !i_rst_n ) begin
                prior[idx] <= 'b0;           
            end else if(i_update) begin
                prior[idx] <= ('d1 << i_prior[idx] ) ;       
            end else if(i_clr_vld && (i_clr_port == idx)) begin
                prior[idx] <= 'b0;
            end else begin
                prior[idx] <= prior[idx];
            end
        end
    end
endgenerate


always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        port_pend<= 'b0;           
    end else if(i_update) begin
        port_pend <= i_pending;       
    end else if(i_clr_vld) begin
        port_pend[i_clr_port] <= 'b0;
    end else begin
        port_pend <= port_pend;
    end
end

logic   port_vld     ;
always_ff @(posedge i_clk or negedge i_rst_n) begin
    if( !i_rst_n ) begin
        port_vld <= 'b0;
    end else begin
        port_vld <= i_clr_vld | i_update;
    end
end

logic [$clog2(PRIOR+1)-1:0] out_sel         ;
logic                      out_vld         ;

assign o_empty = ~( |port_pend) ;
assign o_port_vld = port_vld & (|port_pend) & out_vld;
// always_ff @(posedge i_clk or negedge i_rst_n) begin
//     if( !i_rst_n ) begin
//         o_port_vld <= 'b0;
//     end else begin
//         o_port_vld <= port_vld & (~o_empty) & out_vld;
//     end
// end

/********* prority decode process begin **********/
logic [PRIOR+1-1:0        ] prior_sel               ;
logic [$clog2(PORTNUM)-1:0] sel       [PRIOR+1-1:0] ;
genvar que_idx;
generate
    for(que_idx=0;que_idx<PRIOR;que_idx = que_idx+1) begin: que_arbitrate_block
        prior16_encode prior16_encode_inst(
            .i_data   (
                {   prior[15][que_idx],prior[14][que_idx],prior[13][que_idx],prior[12][que_idx],
                    prior[11][que_idx],prior[10][que_idx],prior[ 9][que_idx],prior[ 8][que_idx],
                    prior[ 7][que_idx],prior[ 6][que_idx],prior[ 5][que_idx],prior[ 4][que_idx],
                    prior[ 3][que_idx],prior[ 2][que_idx],prior[ 1][que_idx],prior[ 0][que_idx]
                }),
            .i_rst_n  (i_rst_n                     ),
            .o_d_vld  (prior_sel[que_idx+4'b1]     ),
            .o_sel    (sel[que_idx+4'b1]           )
        );
    end
endgenerate

prior16_encode prior16_encode_inst(
    .i_data   (port_pend              ),
    .i_rst_n  (i_rst_n                ),
    .o_d_vld  (prior_sel[0]           ),
    .o_sel    (sel[0]                 )
);


prior9_encode prior9_encode_inst(
    .i_data   (prior_sel                   ),
    .i_rst_n  (i_rst_n                     ),
    .o_d_vld  (out_vld                     ),
    .o_sel    (out_sel                     )
);

assign o_port = sel[out_sel];

/********* prority decode process  end  **********/

endmodule