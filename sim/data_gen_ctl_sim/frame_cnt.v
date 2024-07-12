`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/07/07 22:33:32
// Design Name: 
// Module Name: frame_cnt
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module frame_cnt(
    input   clk,
    input   rst_n,
    
    input       i_sop,
    input       i_eop,
    
    output  [15:0]    o_count
    );
    localparam s_idle      =  3'd0;
    localparam s_sop       =  3'd1;
    localparam s_eop       =  3'd2;
    reg [2:0] cstate, nstate;
    
    reg[15:0]     count;
    assign      o_count = count;
    
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
                if(i_sop)begin
                    nstate = s_sop;
                end
            end
            s_sop: begin
                if(i_eop)begin
                    nstate = s_eop;
                end
            end
            s_eop: begin
                nstate = s_idle;
            end
            default: begin
                nstate = cstate;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if( !rst_n) begin
        count <= 0;
    end
    else begin
        if(cstate==s_eop)begin
            count <= count +'d1;
        end
    end
end

    
endmodule
