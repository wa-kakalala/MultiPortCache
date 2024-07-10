
/***
author: zfy
version: 
description:  rom manager top file


***/

module mem_manager#(
    parameter AWIDTH =  10                    
)
(
    input  wire clk                        ,
    input  wire rst_n                      ,

    // occupy rom
    input  wire ocp_req                    ,
    output reg  ocp_rsp                    ,
    output reg [AWIDTH-1:0] ocp_block_addr ,
    output reg ocp_vld                     ,

    // available/empty block num
    output wire [AWIDTH:0]  emp_block_num   ,
    
    //sram flag signal
    output wire full                       ,
    output wire almost_full                ,
    output wire empty                      ,

    //release rom
    input wire [AWIDTH-1:0] rls_block_addr ,
    input wire rls_vld

);


    parameter ROM_WIDTH = 1<<3; //default is 8
    parameter ROM_DEPTH = 1<<(AWIDTH-3);


    wire                  rst;
    reg                   wr_en_1;
    reg     [AWIDTH-1:0]  wr_addr_1;
    reg                   wr_en_2;
    reg     [AWIDTH-1:0]  wr_addr_2;
    wire    [AWIDTH-1:0]  emp_ready_addr;
    wire                  emp_ready_vld;

    bit_map_rom #(
        .WIDTH       ( ROM_WIDTH                 ),
        .DEPTH       ( ROM_DEPTH                 )
    )
    u_bit_map_rom (
        .clk                     ( clk              ),
        .rst                     ( rst              ),
        .wr_en_1                 ( wr_en_1          ),
        .wr_addr_1               ( wr_addr_1        ),
        .wr_val_1                ( 1'b1             ),
        .wr_en_2                 ( wr_en_2          ),
        .wr_addr_2               ( wr_addr_2        ),
        .wr_val_2                ( 1'b0             ),

        .emp_ready_addr          ( emp_ready_addr   ),
        .emp_ready_vld           ( emp_ready_vld    ),

        .emp_addr_num            (  emp_block_num    ),
        .full                    ( full             ),
        .almost_full             ( almost_full      ),
        .empty                   ( empty            )
    );




    assign rst = ~rst_n;



    //state machine for occupying
    reg [2:0] cstate, nstate ;

    parameter IDLE = 3'd0, OCP = 3'd1, RSP = 3'd2;

    always @(posedge clk or negedge rst_n) begin
        if( !rst_n)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    always@(*) begin
        if(!rst_n)
            nstate = IDLE;
        else begin
            case(cstate)
                IDLE: begin
                    if(ocp_req && (!full) )
                        nstate = OCP;
                    else
                        nstate = IDLE;
                end
                OCP: begin
                    if( emp_ready_vld )
                        nstate = RSP;
                    else
                        nstate = OCP;
                end
                RSP: begin
                        nstate = IDLE;
                end
                default: begin
                    nstate = IDLE;
                end
            endcase
        end
    end


    //
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ocp_rsp <= 1'b0;
            ocp_block_addr <= 'd0;
            ocp_vld <= 1'b0;
        end
        else begin

            case( nstate )
                IDLE: begin
                    ocp_rsp <= 1'b0;
                    ocp_block_addr <= 'd0;
                    ocp_vld <= 1'b0;
                end
                OCP: begin
                    ocp_rsp <= 1'b0;
                    ocp_block_addr <= 'd0;
                    ocp_vld <= 1'b0;
                end
                RSP: begin
                    ocp_rsp <= 1'b1;
                    ocp_block_addr <= emp_ready_addr;
                    ocp_vld <= 1'b1;
                end
                default: begin
                    ocp_rsp <= 1'b0;
                    ocp_block_addr <= 'd0;
                    ocp_vld <= 1'b0;
                end
            endcase
            // if( nstate == IDLE  ) begin
            //     ocp_rsp <= 1'b0;
            //     ocp_block_addr <= 'd0;
            //     ocp_vld <= 1'b0;
            // end
            // else if( (nstate == OCP) && emp_ready_vld  ) begin
            //     ocp_rsp <= 1'b1;
            //     ocp_block_addr <= 'd0;
            //     ocp_vld <= 1'b0;
            // end
            // else if( (nstate == OCP) && !emp_ready_vld ) begin
            //     ocp_rsp <= 1'b0;
            //     ocp_block_addr <= 'd0;
            //     ocp_vld <= 1'b0;
            // end
            // else if( (nstate == RSP) && emp_ready_vld ) begin
            //     ocp_rsp <= 1'b0;
            //     ocp_block_addr <= emp_ready_addr;
            //     ocp_vld <= 1'b1;
            // end
            // else if( (nstate == RSP) && !emp_ready_vld ) begin
            //     ocp_rsp <= 1'b0;
            //     ocp_block_addr <= 'd0;
            //     ocp_vld <= 1'b0;
            // end
        end
    end


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_en_1 <= 1'b0;
            wr_addr_1 <= 'd0;
        end
        else begin
            if( nstate == IDLE || nstate == OCP ) begin
                wr_en_1 <= 1'b0;
                wr_addr_1 <= 'd0;
            end
            else if( (nstate == RSP) && emp_ready_vld ) begin
                wr_en_1 <= 1'b1;
                wr_addr_1 <= emp_ready_addr;
            end
            else if( (nstate == RSP) && !emp_ready_vld ) begin
                wr_en_1 <= 1'b0;
                wr_addr_1 <= 'd0;
            end
            else begin
                wr_en_1 <= 1'b0;
                wr_addr_1 <= 'd0;
            end
        end
    end


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_en_2 <= 1'b0;
            wr_addr_2 <= 'd0;
        end
        else begin
            wr_en_2   <= rls_vld;
            wr_addr_2 <= rls_block_addr;
        end
    end


endmodule