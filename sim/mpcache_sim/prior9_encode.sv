/**************************************
@ filename    : prior_decode.sv
@ author      : yyrwkk
@ create time : 2024/05/16 19:18:23
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps
module prior9_encode # (
    parameter [0:0] TARGET     =    1'b1   ,
    localparam      DWIDTH     =    9     
)(
    input  logic [DWIDTH-1:0]         i_data   ,
    input  logic                      i_rst_n  ,
    
    output logic                      o_d_vld  ,
    output logic [$clog2(DWIDTH)-1:0] o_sel
);

assign o_d_vld = |i_data;

always_comb begin
    if( !i_rst_n ) begin
        o_sel = 'b0;
    end else begin
        if     (i_data[0 ] == TARGET ) begin  o_sel = 'd0 ;  end
            else if(i_data[1 ] == TARGET ) begin  o_sel = 'd1 ;  end
            else if(i_data[2 ] == TARGET ) begin  o_sel = 'd2 ;  end
            else if(i_data[3 ] == TARGET ) begin  o_sel = 'd3 ;  end
            else if(i_data[4 ] == TARGET ) begin  o_sel = 'd4 ;  end
            else if(i_data[5 ] == TARGET ) begin  o_sel = 'd5 ;  end
            else if(i_data[6 ] == TARGET ) begin  o_sel = 'd6 ;  end
            else if(i_data[7 ] == TARGET ) begin  o_sel = 'd7 ;  end
            else if(i_data[8 ] == TARGET ) begin  o_sel = 'd8 ;  end
            else begin  o_sel = 'b0; end
    end
end
endmodule