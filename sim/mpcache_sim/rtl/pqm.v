`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/13   16:21
// Design Name: 
// Module Name: pqm
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
module pqm#(
    parameter  DW_IN = 32,
    parameter  DW_OUT = 32,
    parameter  SM_AW = 10

)(
    input                   i_clk,
    input                   i_rst,
    
    input                   i_vld,
    input[3:0]              i_da,
    input[2:0]              i_prior,
    
    input                   i_addr_in_vld,
    output                  o_addr_in_rdy,
    input[SM_AW-1:0]        i_addr_in,
    input                   i_frame_last,
    
    output                  o_addr_rls_vld,
    output[SM_AW-1:0]       o_addr_rls,
    
    input                   i_addr_out_rdy,
    output                  o_addr_out_vld,
    output[SM_AW-1:0]       o_addr_out,          
    output                  o_frame_last,
    
    input                   i_out_vld,
    input[3:0]              i_out_port,
     
    output[15:0]             o_out_pending,    
    output[2:0]              o_out_prior_0,
    output[2:0]              o_out_prior_1,
    output[2:0]              o_out_prior_2,
    output[2:0]              o_out_prior_3,
    output[2:0]              o_out_prior_4,
    output[2:0]              o_out_prior_5,
    output[2:0]              o_out_prior_6,
    output[2:0]              o_out_prior_7,
    output[2:0]              o_out_prior_8,
    output[2:0]              o_out_prior_9,
    output[2:0]              o_out_prior_10,
    output[2:0]              o_out_prior_11,
    output[2:0]              o_out_prior_12,
    output[2:0]              o_out_prior_13,
    output[2:0]              o_out_prior_14,
    output[2:0]              o_out_prior_15        
   
    );
    reg[2*SM_AW:0]   queue_addr[127:0];
    integer i;
    reg [6:0]   in_line;
    reg [6:0]   out_line;   
    reg[2:0]    out_prior;  
    reg         addr_in_rdy;
    assign      o_addr_in_rdy = addr_in_rdy;
    //update in_line and out_line                                                                                                                                                                 
    always@(posedge i_clk or posedge i_rst)begin
        if(i_rst)begin
            in_line <= 0;
            out_line <= 0;
            addr_in_rdy <= 0;
        end
        else begin
            if(i_vld)begin
               addr_in_rdy <= 0;
               in_line <= (i_da<<3)+i_prior;
            end
            else begin
                addr_in_rdy <= 1;
                in_line <= in_line;
            end
            if(i_out_vld)begin           
                out_line <= (i_out_port<<3)+out_prior;
            end
            else begin
                out_line <= out_line;
            end
        end
    end
     //update  out_prior
     always@(*)begin
        if(i_out_vld)begin
            case(i_out_port)
                4'd0 : out_prior = o_out_prior_0;
                4'd1 : out_prior = o_out_prior_1;
                4'd2 : out_prior = o_out_prior_2;
                4'd3 : out_prior = o_out_prior_3;
                4'd4 : out_prior = o_out_prior_4;
                4'd5 : out_prior = o_out_prior_5;
                4'd6 : out_prior = o_out_prior_6;
                4'd7 : out_prior = o_out_prior_7;
                4'd8 : out_prior = o_out_prior_8;
                4'd9 : out_prior = o_out_prior_9;
                4'd10 : out_prior = o_out_prior_10;
                4'd11 : out_prior = o_out_prior_11;
                4'd12 : out_prior = o_out_prior_12;
                4'd13 : out_prior = o_out_prior_13;
                4'd14 : out_prior = o_out_prior_14;
                4'd15 : out_prior = o_out_prior_15;
                default : out_prior = 3'b111;
            endcase
        end
        else begin
            out_prior = 3'b111;
        end
    end
 
    
    reg                 queue_en_a;
    reg                 queue_en_b;
    reg                 queue_wr_a;
    reg                 queue_wr_b;
    reg [SM_AW-1:0]     queue_addr_a;
    reg [SM_AW-1:0]     queue_addr_b;
    
    reg [SM_AW:0]     queue_in_a;
    reg [SM_AW:0]     queue_in_b;

    wire [SM_AW : 0]   queue_out_a;
    wire [SM_AW : 0]   queue_out_b;
    
    reg                 frame_last;
    reg[SM_AW-1:0]      addr_in;
    reg[SM_AW-1:0]      addr_last;
    reg[3:0]            addr_in_cnt;
    
    reg                 addr_out_vld;
    reg[SM_AW-1:0]      addr_out;
    reg[3:0]            addr_out_cnt;
    assign              o_addr_out_vld = addr_out_vld;
    assign              o_addr_out = addr_out;
    
    reg                 addr_rls_vld;
    reg[SM_AW-1:0]      addr_rls;
    assign              o_addr_rls_vld = addr_rls_vld;
    assign              o_addr_rls = addr_rls;
    
    reg        queue_empty_n;     //1:queue not empty
    reg     first_addr;
    reg     in_vld;
    
    wire             raw;
    assign          raw = (in_line==out_line)&(addr_in_cnt !='d0)&&(addr_out_cnt == 'd3)&&(i_addr_out_rdy)&first_addr;
    reg[9:0]         addr_reg;
    reg         raw_flag;
    always@(posedge i_clk or posedge i_rst)begin
        if(i_rst)begin
            queue_en_a <= 0;
            queue_wr_a <= 0;
            queue_addr_a <= 0;
            queue_in_a <= 0;                      
            
            addr_in <= 0;
            addr_last <= 0;
            addr_in_cnt <= 0;
            frame_last <= 0;
        end
        else begin
            if(i_addr_in_vld)begin
                frame_last <= i_frame_last;
                addr_in <= i_addr_in;
                addr_in_cnt <= 'd1;
                addr_last <= queue_addr[in_line][2*SM_AW:SM_AW+1];
//                if(queue_addr[in_line][0]==1'b1)begin  //read old tail
//                    queue_en_a <= 1;
//                    queue_wr_a <= 0;
//                    queue_addr_a <= queue_addr[in_line][2*SM_AW:SM_AW+1];
//                    addr_in_cnt <= 1;
//                end 
//                else begin
//                    addr_in_cnt <= 0;
//                    queue_en_a <= 0;
//                    queue_wr_a <= 0;
//                end
            end
            else begin
//                frame_last <= 0;
//                if(addr_in_cnt == 1)begin
//                    queue_en_a <= 1;
//                    queue_wr_a <= 1;
//                    queue_addr_a <= queue_addr[in_line][2*SM_AW:SM_AW+1];
//                    queue_in_a <= {addr_in,queue_out_a[0]};
//                    addr_in_cnt <= 2;
//                end
//                else if(addr_in_cnt == 2)begin
//                    queue_en_a <= 1;
//                    queue_wr_a <= 1;
//                    queue_addr_a <= queue_addr[in_line][2*SM_AW:SM_AW+1];
//                    queue_in_a <= {addr_in,frame_last};
//                    addr_in_cnt <= 0;
//                end
//                else begin
//                    queue_en_a <= 0;
//                    queue_wr_a <= 0;
//                end  
                if(addr_in_cnt == 1)begin
                    if(queue_empty_n==1'b1 | queue_addr[in_line][0]==1'b1 | ~first_addr)begin  //read old tail
                        queue_en_a <= 1;
                        queue_wr_a <= 0;
                        queue_addr_a <= addr_last;
                        addr_in_cnt <= 2;
                    end 
                    else begin
                        queue_en_a <= 1;
                        queue_wr_a <= 1;
                        queue_addr_a <= addr_in;
                        queue_in_a <= {addr_in,1'b0};
                        addr_in_cnt <= 0;
                    end                  
                end
                else if(addr_in_cnt == 2)begin
                    addr_in_cnt <= 3;
                    queue_en_a <= 0;
                    queue_wr_a <= 0;                   
                end
                else if(addr_in_cnt == 3)begin //write old tail
                    queue_en_a <= 1;
                    queue_wr_a <= 1;
                    queue_addr_a <= addr_last;
                    queue_in_a <= {addr_in,queue_out_a[0]};
                    addr_in_cnt <= 4;                   
                end
                else if(addr_in_cnt == 4)begin //write new tail
                    queue_en_a <= 1;
                    queue_wr_a <= 1;
                    queue_addr_a <= queue_addr[in_line][2*SM_AW:SM_AW+1];
                    queue_in_a <= {addr_in,frame_last};
                    addr_in_cnt <= 0;
                end
                else begin
                    frame_last <= 0;
                    queue_en_a <= 0;
                    queue_wr_a <= 0;
                end                               
            end
        end
    end   
    
    reg             out_frame_last;
    assign          o_frame_last = out_frame_last;
    reg[9:0]             out_addr;
    always@(posedge i_clk or posedge i_rst)begin
        if(i_rst)begin
            queue_en_b <= 0;
            queue_wr_b <= 0;
            queue_addr_b <= 0;
            queue_in_b <= 0;
            
            addr_out_cnt <= 0;
            addr_out_vld <= 0;
            addr_out <= 0;
            
            addr_rls_vld <= 0;
            addr_rls <= 0;
            
            out_frame_last <= 0;
            out_addr <= 'b0;
            addr_reg <= 0;
        end
        else begin
            queue_in_b <= 0;
            if(i_out_vld)begin
                out_frame_last <= 0;
                addr_rls_vld <= 1'b0;
                addr_out_cnt <= 4'd1;
                addr_out <= 0;
                queue_en_b <= 0;
//                queue_wr_b <= 0;
//                queue_addr_b <= queue_addr[out_line][SM_AW:1];
            end
            else begin
                if(addr_out_cnt == 4'd1)begin //read queue_addr tail
                    out_frame_last <= 0;
                    addr_rls_vld <= 1'b0;
                    if(i_addr_out_rdy)begin
                        queue_en_b <= 1;
                        queue_wr_b <= 0;
                        queue_addr_b <= queue_addr[out_line][SM_AW:1];   
                                
                        addr_out_vld <= 1;
                        addr_out <= queue_addr[out_line][SM_AW:1];
//                        out_addr <= queue_addr[out_line][SM_AW:1];
                        addr_out_cnt <= 4'd2;
                    end 
                    else begin
                        queue_en_b <= 0;
                        addr_out_vld <= 0;
                    end                  
                end      
                else if(addr_out_cnt == 4'd2)begin //wait for read result
                    out_frame_last <= 0;
                    addr_rls_vld <= 1'b0;
                    addr_out_vld <= 0;
                    queue_en_b <= 0;
                    addr_out_cnt <= 4'd3;
                end   
//                else if(addr_out_cnt == 4'd3)begin //wait for read result
//                    out_frame_last <= 0;
//                    addr_rls_vld <= 1'b0;
//                    addr_out_vld <= 0;
//                    queue_en_b <= 0;
//                    addr_out_cnt <= 4'd4;
//                end      
                else if(addr_out_cnt == 4'd3)begin   //release addr and                                     
                    if(i_addr_out_rdy)begin
                        addr_rls_vld <= 1;
                        addr_rls <= addr_out;
                        
                        if(raw)begin  
                            raw_flag <= 1'b1;  
                            addr_reg <= addr_in;
                        end
                        else begin
                            raw_flag <= 1'b0;  
                        end
                        
//                        addr_rls <= queue_addr[out_line][SM_AW:1];
                        if(queue_out_b[0] == 1)begin
                            out_frame_last <= 1;
                            addr_out_cnt <= 4'd0;   
                            addr_out_vld <= 0;
                            queue_en_b <= 1'b0;
                        end                                             
                        else begin      
                            addr_out_cnt <= 4'd2;                      
                            addr_out_vld <= 1;
                            addr_out <= queue_out_b[SM_AW:1];                            
                            
                            queue_en_b <= 1;
                            queue_wr_b <= 0;
                            queue_addr_b <= queue_out_b[SM_AW:1];
//                            queue_addr_b <= queue_addr[out_line][SM_AW:1]; 
                        end 
//                        if(out_frame_last)begin
////                            addr_out_cnt <= 4'd0; 
//                            addr_rls_vld <= 1'b0;
//                            out_frame_last <= 0;
//                        end
//                        else begin
//                            addr_out_cnt <= 4'd2;
//                        end
//                        if(queue_out_b[SM_AW:1] == queue_addr[out_line][2*SM_AW:SM_AW+1])begin
////                        out_state <= 0;     
////                        o_sm_out_vld <= 1'b0;                                                   
//                        queue_en_b <= 1'b0;
//                        frame_last <= 1;
//                        if(frame_last)begin
//                            out_state <= 0;
//                        end
                      
                    end
                    else begin
                        addr_out_vld <= 0;
                        addr_rls_vld <= 0;
                        queue_en_b <= 0;
                    end
                end
                else begin
                    queue_en_b <= 0;
                    queue_wr_b <= 0;
                    addr_out_vld <= 0;
                    addr_rls_vld <= 0;
                    out_frame_last <= 0;
                end
            end
        end
    end
    
     
    //update queue_addr
    always@(posedge i_clk or posedge i_rst)begin
        if(i_rst)begin
            in_vld <= 'b0;
            first_addr <= 'b0;
        end
        else begin
            if(i_vld)begin
                in_vld <= 'b1;
            end
            else if(i_addr_in_vld)begin
                in_vld <= 'b0;
            end
            if(in_vld&&i_addr_in_vld)begin
                first_addr <= 1'b1;
            end
            else if(~in_vld&&i_addr_in_vld)begin
                first_addr <= 1'b0;
            end
        end
    end
    
    
    always@(posedge i_clk or posedge i_rst)begin
        if(i_rst)begin
            queue_empty_n <= 0;
            for(i = 0;i < 128; i = i + 1)
                queue_addr[i] <= 0;
        end
        else begin
//            if(addr_in_cnt == 1)begin
//                if(queue_addr[in_line][0]==1'b0)begin
//                    queue_empty_n <= 1;
//                    if(!queue_empty_n && first_addr)begin
//                        queue_addr[in_line][SM_AW:1] <= addr_in; 
//                    end
////                    queue_addr[in_line][SM_AW:1] <= addr_in;   
//                    queue_addr[in_line][2*SM_AW:SM_AW+1] <= addr_in;
//                    if(frame_last)begin
//                        queue_addr[in_line][0]<=1'b1;
//                        queue_empty_n <= 0;
//                    end                  
//                end
//                else begin
//                    queue_addr[in_line][2*SM_AW:SM_AW+1] <= addr_in;
//                end
                  
//            end 

            if(addr_in_cnt == 1)begin
                if(queue_addr[in_line][0]==1'b0 )begin 
                    queue_empty_n <= 1;      
                    if(queue_empty_n == 1)begin
                        queue_addr[in_line][2*SM_AW:SM_AW+1] <= addr_in;
                        if(frame_last)begin
                            queue_addr[in_line][0]<=1'b1;
                            queue_empty_n <= 0;
                        end
                    end      
                    else begin 
                        if(first_addr)begin                            
                            queue_addr[in_line][SM_AW:1] <= addr_in;
                        end               
//                        queue_addr[in_line][SM_AW:1] <= addr_in;  
                        queue_addr[in_line][2*SM_AW:SM_AW+1] <= addr_in;                                                
                    end                   
                end
                else begin                   
                    queue_addr[in_line][2*SM_AW:SM_AW+1] <= addr_in;
                end
            end   
            if(addr_out_cnt == 4'd3 && i_addr_out_rdy)begin
                if(queue_addr[out_line][0]==1'b1 )begin
                    if(raw_flag &(queue_addr[out_line][SM_AW:1]==queue_out_b[SM_AW:1]))begin
                        queue_addr[out_line][SM_AW:1] <= addr_reg;
                    end else begin
                        queue_addr[out_line][SM_AW:1] <= queue_out_b[SM_AW:1];
                    end
                end
//                queue_addr[out_line][SM_AW:1] <= queue_out_b[SM_AW:1];
                if((queue_addr[out_line][2*SM_AW:SM_AW+1] == queue_out_b[SM_AW:1]))begin   
                       if(~raw)begin
                            queue_addr[out_line][0] <= 0;
                       end                
//                       queue_addr[out_line][0] <= 0;
                end
            end        
        end
    end 
       
    dual_sram #(
    .DWIDTH ( SM_AW+1 ),
    .AWIDTH ( SM_AW  )
    )u_queue (
    .clk_a_in          (  i_clk             ),
//    .clk_b_in          (  i_clk             ),
    .en_a_in           (  queue_en_a        ),
    .we_a_in           (  queue_wr_a        ),
    .addr_a_in         (  queue_addr_a      ),
    .d_a_in            (  queue_in_a        ),
    .d_a_out           (  queue_out_a       ),
    
    .en_b_in           (  queue_en_b        ),
    .we_b_in           (  queue_wr_b        ),
    .addr_b_in         (  queue_addr_b      ),
    .d_b_in            (  queue_in_b        ),
    .d_b_out           (  queue_out_b       )
       
);
assign     o_out_prior_0 = queue_addr[0][0]?3'b000:queue_addr[1][0]?3'b001:queue_addr[2][0]?3'b010:queue_addr[3][0]?3'b011:
                           queue_addr[4][0]?3'b100:queue_addr[5][0]?3'b101:queue_addr[6][0]?3'b110:queue_addr[7][0]?3'b111:3'b000;                          
assign     o_out_prior_1 = queue_addr[8][0]?3'b000:queue_addr[9][0]?3'b001:queue_addr[10][0]?3'b010:queue_addr[11][0]?3'b011:
                           queue_addr[12][0]?3'b100:queue_addr[13][0]?3'b101:queue_addr[14][0]?3'b110:queue_addr[15][0]?3'b111:3'b000;
assign     o_out_prior_2 = queue_addr[16][0]?3'b000:queue_addr[17][0]?3'b001:queue_addr[18][0]?3'b010:queue_addr[19][0]?3'b011:
                           queue_addr[20][0]?3'b100:queue_addr[21][0]?3'b101:queue_addr[22][0]?3'b110:queue_addr[23][0]?3'b111:3'b000;                           
assign     o_out_prior_3 = queue_addr[24][0]?3'b000:queue_addr[25][0]?3'b001:queue_addr[26][0]?3'b010:queue_addr[27][0]?3'b011:
                           queue_addr[28][0]?3'b100:queue_addr[29][0]?3'b101:queue_addr[30][0]?3'b110:queue_addr[31][0]?3'b111:3'b000;
assign     o_out_prior_4 = queue_addr[32][0]?3'b000:queue_addr[33][0]?3'b001:queue_addr[34][0]?3'b010:queue_addr[35][0]?3'b011:
                           queue_addr[36][0]?3'b100:queue_addr[37][0]?3'b101:queue_addr[38][0]?3'b110:queue_addr[39][0]?3'b111:3'b000;                           
assign     o_out_prior_5 = queue_addr[40][0]?3'b000:queue_addr[41][0]?3'b001:queue_addr[42][0]?3'b010:queue_addr[43][0]?3'b011:
                           queue_addr[44][0]?3'b100:queue_addr[45][0]?3'b101:queue_addr[46][0]?3'b110:queue_addr[47][0]?3'b111:3'b000;                           
assign     o_out_prior_6 = queue_addr[48][0]?3'b000:queue_addr[49][0]?3'b001:queue_addr[50][0]?3'b010:queue_addr[51][0]?3'b011:
                           queue_addr[52][0]?3'b100:queue_addr[53][0]?3'b101:queue_addr[54][0]?3'b110:queue_addr[55][0]?3'b111:3'b000;                           
assign     o_out_prior_7 = queue_addr[56][0]?3'b000:queue_addr[57][0]?3'b001:queue_addr[58][0]?3'b010:queue_addr[59][0]?3'b011:
                           queue_addr[60][0]?3'b100:queue_addr[61][0]?3'b101:queue_addr[62][0]?3'b110:queue_addr[63][0]?3'b111:3'b000;
assign     o_out_prior_8 = queue_addr[64][0]?3'b000:queue_addr[65][0]?3'b001:queue_addr[66][0]?3'b010:queue_addr[67][0]?3'b011:
                           queue_addr[68][0]?3'b100:queue_addr[69][0]?3'b101:queue_addr[70][0]?3'b110:queue_addr[71][0]?3'b111:3'b000; 
assign     o_out_prior_9 = queue_addr[72][0]?3'b000:queue_addr[73][0]?3'b001:queue_addr[74][0]?3'b010:queue_addr[75][0]?3'b011:
                           queue_addr[76][0]?3'b100:queue_addr[77][0]?3'b101:queue_addr[78][0]?3'b110:queue_addr[79][0]?3'b111:3'b000;                           
assign     o_out_prior_10 = queue_addr[80][0]?3'b000:queue_addr[81][0]?3'b001:queue_addr[82][0]?3'b010:queue_addr[83][0]?3'b011:
                           queue_addr[84][0]?3'b100:queue_addr[85][0]?3'b101:queue_addr[86][0]?3'b110:queue_addr[87][0]?3'b111:3'b000;
assign     o_out_prior_11 = queue_addr[88][0]?3'b000:queue_addr[89][0]?3'b001:queue_addr[90][0]?3'b010:queue_addr[91][0]?3'b011:
                           queue_addr[92][0]?3'b100:queue_addr[93][0]?3'b101:queue_addr[94][0]?3'b110:queue_addr[95][0]?3'b111:3'b000;
assign     o_out_prior_12 = queue_addr[96][0]?3'b000:queue_addr[97][0]?3'b001:queue_addr[98][0]?3'b010:queue_addr[99][0]?3'b011:
                           queue_addr[100][0]?3'b100:queue_addr[101][0]?3'b101:queue_addr[102][0]?3'b110:queue_addr[103][0]?3'b111:3'b000;   
assign     o_out_prior_13 = queue_addr[104][0]?3'b000:queue_addr[105][0]?3'b001:queue_addr[106][0]?3'b010:queue_addr[107][0]?3'b011:
                           queue_addr[108][0]?3'b100:queue_addr[109][0]?3'b101:queue_addr[110][0]?3'b110:queue_addr[111][0]?3'b111:3'b000;                                                   
assign     o_out_prior_14 = queue_addr[112][0]?3'b000:queue_addr[113][0]?3'b001:queue_addr[114][0]?3'b010:queue_addr[115][0]?3'b011:
                           queue_addr[116][0]?3'b100:queue_addr[117][0]?3'b101:queue_addr[118][0]?3'b110:queue_addr[119][0]?3'b111:3'b000;
assign     o_out_prior_15 = queue_addr[120][0]?3'b000:queue_addr[121][0]?3'b001:queue_addr[122][0]?3'b010:queue_addr[123][0]?3'b011:
                           queue_addr[124][0]?3'b100:queue_addr[125][0]?3'b101:queue_addr[126][0]?3'b110:queue_addr[127][0]?3'b111:3'b000;
                                                                                                                                                                                            
assign     o_out_pending[0] =  queue_addr[0][0]|queue_addr[1][0]|queue_addr[2][0]|queue_addr[3][0]
                              |queue_addr[4][0]|queue_addr[5][0]|queue_addr[6][0]|queue_addr[7][0];
assign     o_out_pending[1] =  queue_addr[8][0]|queue_addr[9][0]|queue_addr[10][0]|queue_addr[11][0]
                              |queue_addr[12][0]|queue_addr[13][0]|queue_addr[14][0]|queue_addr[15][0];
assign     o_out_pending[2] =  queue_addr[16][0]|queue_addr[17][0]|queue_addr[18][0]|queue_addr[19][0]
                              |queue_addr[20][0]|queue_addr[21][0]|queue_addr[22][0]|queue_addr[23][0];   
assign     o_out_pending[3] =  queue_addr[24][0]|queue_addr[25][0]|queue_addr[26][0]|queue_addr[27][0]
                              |queue_addr[28][0]|queue_addr[29][0]|queue_addr[30][0]|queue_addr[31][0];
assign     o_out_pending[4] =  queue_addr[32][0]|queue_addr[33][0]|queue_addr[34][0]|queue_addr[35][0]
                              |queue_addr[36][0]|queue_addr[37][0]|queue_addr[38][0]|queue_addr[39][0]; 
assign     o_out_pending[5] =  queue_addr[40][0]|queue_addr[41][0]|queue_addr[42][0]|queue_addr[43][0]
                              |queue_addr[44][0]|queue_addr[45][0]|queue_addr[46][0]|queue_addr[47][0];
assign     o_out_pending[6] =  queue_addr[48][0]|queue_addr[49][0]|queue_addr[50][0]|queue_addr[51][0]
                              |queue_addr[52][0]|queue_addr[53][0]|queue_addr[54][0]|queue_addr[55][0];
assign     o_out_pending[7] =  queue_addr[56][0]|queue_addr[57][0]|queue_addr[58][0]|queue_addr[59][0]
                              |queue_addr[60][0]|queue_addr[61][0]|queue_addr[62][0]|queue_addr[63][0];   
assign     o_out_pending[8] =  queue_addr[64][0]|queue_addr[65][0]|queue_addr[66][0]|queue_addr[67][0]
                              |queue_addr[68][0]|queue_addr[69][0]|queue_addr[70][0]|queue_addr[71][0]; 
assign     o_out_pending[9] =  queue_addr[72][0]|queue_addr[73][0]|queue_addr[74][0]|queue_addr[75][0]
                              |queue_addr[76][0]|queue_addr[77][0]|queue_addr[78][0]|queue_addr[79][0];
assign     o_out_pending[10] =  queue_addr[80][0]|queue_addr[81][0]|queue_addr[82][0]|queue_addr[83][0]
                              |queue_addr[84][0]|queue_addr[85][0]|queue_addr[86][0]|queue_addr[87][0];
assign     o_out_pending[11] =  queue_addr[88][0]|queue_addr[89][0]|queue_addr[90][0]|queue_addr[91][0]
                              |queue_addr[92][0]|queue_addr[93][0]|queue_addr[94][0]|queue_addr[95][0]; 
assign     o_out_pending[12] =  queue_addr[96][0]|queue_addr[97][0]|queue_addr[98][0]|queue_addr[99][0]
                              |queue_addr[100][0]|queue_addr[101][0]|queue_addr[102][0]|queue_addr[103][0];    
assign     o_out_pending[13] =  queue_addr[104][0]|queue_addr[105][0]|queue_addr[106][0]|queue_addr[107][0]
                              |queue_addr[108][0]|queue_addr[109][0]|queue_addr[110][0]|queue_addr[111][0];
assign     o_out_pending[14] =  queue_addr[112][0]|queue_addr[113][0]|queue_addr[114][0]|queue_addr[115][0]
                              |queue_addr[116][0]|queue_addr[117][0]|queue_addr[118][0]|queue_addr[119][0]; 
assign     o_out_pending[15] =  queue_addr[120][0]|queue_addr[121][0]|queue_addr[122][0]|queue_addr[123][0]
                              |queue_addr[124][0]|queue_addr[125][0]|queue_addr[126][0]|queue_addr[127][0]; 
                                                                                                                                                                                                  
endmodule
