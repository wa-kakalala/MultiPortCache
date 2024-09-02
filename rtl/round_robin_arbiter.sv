/**************************************
@ filename    : round_robin_arbiter.sv
@ author      : yyrwkk
@ create time : 2024/08/18 02:24:47
@ version     : v1.0.0
**************************************/
module round_robin_arbiter # (
    parameter  N_REQ  =  16    // N must be at least 2
)(
    input  logic             i_clk   ,
    input  logic             i_rst_n ,

    input  logic [N_REQ-1:0] i_req   ,
    output logic [N_REQ-1:0] o_grant 
);

logic [N_REQ-1:0]  rotate_ptr  ;
logic [N_REQ-1:0]  mask_req    ;
logic [N_REQ-1:0]  mask_grant  ;
logic [N_REQ-1:0]  grant_comb  ;

logic              no_mask_req ;
logic [N_REQ-1:0]  nomask_grant;
logic              update_ptr  ;

genvar i;

// rotate pointer update logic
assign update_ptr = |o_grant;
always_ff @( posedge i_clk or negedge i_rst_n ) begin
    if( !i_rst_n ) begin
        rotate_ptr[0] <= 1'b1;
        rotate_ptr[1] <= 1'b1;
    end else begin
        if( update_ptr ) begin
            rotate_ptr[0] <= o_grant[N_REQ-1];
            rotate_ptr[1] <= o_grant[N_REQ-1] | o_grant[0];
        end else  begin
            rotate_ptr[0] <= rotate_ptr[0];
            rotate_ptr[1] <= rotate_ptr[1];
        end
    end
end

generate
    for(i=2;i<N_REQ;i=i+1) begin
        if( i == 0 ) begin

        end
        always @ (posedge i_clk or negedge i_rst_n) begin
            if (!i_rst_n)
                rotate_ptr[i] <= 1'b1;
            else begin
                if (update_ptr)
                    rotate_ptr[i] <= o_grant[N_REQ-1] | (|o_grant[i-1:0]);
                else begin
                    rotate_ptr[i] <= rotate_ptr[i];
                end
            end
        end
    end
endgenerate

// mask grant generation logic
assign mask_req = i_req & rotate_ptr;

assign mask_grant[0] = mask_req[0];
generate 
    for (i=1;i<N_REQ;i=i+1) begin
        assign mask_grant[i] = (~|mask_req[i-1:0]) & mask_req[i];
    end
endgenerate

// non-mask grant generation logic
assign nomask_grant[0] = i_req[0];
generate
    for (i=1;i<N_REQ;i=i+1) begin
        assign nomask_grant[i] = (~|i_req[i-1:0]) & i_req[i];
    end
endgenerate

// grant generation logic
assign no_mask_req = ~|mask_req[N_REQ-1:0];
assign grant_comb[N_REQ-1:0] = mask_grant[N_REQ-1:0] | (nomask_grant[N_REQ-1:0] & {N_REQ{no_mask_req}});

always @ (posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n ) begin
        o_grant <= {N_REQ{1'b0}};
    end else begin
        o_grant <= grant_comb & ~o_grant;   
    end
end

endmodule