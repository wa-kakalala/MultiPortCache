/***
author: zfy
version: 
description: 


***/

module bit_map_rom #(
    parameter WIDTH =  8                 ,
    parameter DEPTH = 128    
    )(
    input  wire clk                  ,
    input  wire rst                   ,

    input  wire wr_en_1                   ,
    input  wire [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ] wr_addr_1,
    input  wire  wr_val_1   ,

    input  wire wr_en_2                   ,
    input  wire [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ] wr_addr_2,
    input  wire  wr_val_2   ,


    output wire [$clog2(DEPTH)+$clog2(WIDTH)-1: 0] emp_ready_addr,
    output wire emp_ready_vld,

    output wire full,
    output wire almost_full,
    output wire empty

);
    // row width
    parameter ROW_W = $clog2(WIDTH);
    parameter COL_W = $clog2(DEPTH);
    //memory volume
    parameter VOLUME = 1<<(ROW_W + COL_W);
    //almost full threshold
    parameter AMFULL_DIFF = 'd4; 

    reg [WIDTH - 1 : 0] memory[ DEPTH-1 : 0];
    integer     i;
    genvar      d;



    //bit map group
    wire   [DEPTH-1:0] grp;
    generate
        for (d = 0; d < DEPTH; d = d + 1) begin : generate_grp
            assign grp[d] =  &memory[d]; //
        end
    endgenerate


    //grp first 0, grp_emp_bin is the bin index to first 0 
    wire  [COL_W-1:0] grp_emp_bin;
    wire              grp_emp_vld;
    find_zero #(
                .WIDTH ( DEPTH  ) //DEPTH
            )
            u_find_zero (
                .code            ( grp   ),
                .find            ( grp_emp_vld ),
                .bin_code        ( grp_emp_bin   )
    );

    reg [COL_W-1:0] grp_emp_bin_r1;
    reg grp_emp_vld_r1;
    always @(posedge clk) begin
        if( rst )begin
            grp_emp_bin_r1 <= 'b0;
            grp_emp_vld_r1 <= 1'b0;
        end
        else begin
            grp_emp_bin_r1 <= grp_emp_bin;
            grp_emp_vld_r1 <= grp_emp_vld;
        end
    end





    //every group's first 0 find
    wire  [ROW_W-1:0] row_emp_bin [DEPTH-1:0];
    generate
        for( d=0; d < DEPTH; d = d+1 ) begin: generate_row_emp
            find_zero #(
                .WIDTH ( WIDTH  )
            )
            u_find_zero (
                .code            ( memory[d]   ),

                .bin_code        ( row_emp_bin[d]   )
            );
        end
    endgenerate



    //emp bin
    reg [ROW_W+ COL_W -1: 0] emp_bin;
    reg emp_bin_vld;
    always @(posedge clk) begin
        if( rst )begin
            emp_bin <= 'b0;
            emp_bin_vld <= 1'b0;
        end
        else begin
            emp_bin <= {grp_emp_bin_r1, row_emp_bin[grp_emp_bin] };

            if( grp_emp_bin_r1 == grp_emp_bin ) 
                emp_bin_vld <= grp_emp_vld_r1;
            else
                emp_bin_vld <= 1'b0;
        end
    end


    assign emp_ready_addr = emp_bin;
    assign emp_ready_vld = emp_bin_vld;






    //bit map write count
    reg [ROW_W+COL_W:0] wr_count;
    always @(posedge clk) begin
        if( rst ) begin
            wr_count <= 'd0;
        end
        else begin
            if(wr_en_1 && wr_val_1 && (memory[wr_addr_1>>ROW_W][ wr_addr_1[ROW_W-1:0] ] ^ wr_val_1) )
                wr_count <= wr_count + 'd1; //write 1 with wr interface 1
            else if(wr_en_1 && (!wr_val_1) && (memory[wr_addr_1>>ROW_W][ wr_addr_1[ROW_W-1:0] ] ^ wr_val_1) )
                wr_count <= wr_count -'d1; //write 0 with wr interface 1
            else if(wr_en_2 && wr_val_2 && (memory[wr_addr_2>>ROW_W][ wr_addr_2[ROW_W-1:0] ] ^ wr_val_2) )
                wr_count <= wr_count + 'd1; //write 1 with wr interface 2
            else if(wr_en_2 && (!wr_val_2) && (memory[wr_addr_2>>ROW_W][ wr_addr_2[ROW_W-1:0] ] ^ wr_val_2) )
                wr_count <= wr_count -'d1; //write 0 with wr interface 2

            else 
                wr_count <= wr_count;
        end
    end



    //empty and full， almost full flag
    assign full =  & grp; //
    assign almost_full =  (wr_count >= ( (1<<(ROW_W+COL_W)) - AMFULL_DIFF ) )? 1'b1 : 1'b0; //
    assign empty = ~( |grp );





    //write and read memory
    always @(posedge clk)begin
        if( rst ) begin
            for(i = 0;i < DEPTH; i = i + 1)
                memory[i] <= {WIDTH{1'h0}};
        end
        else begin
            if(wr_en_1 && wr_en_2 && (wr_addr_1^wr_addr_2 == { (ROW_W+COL_W){1'b0} } ) )
                memory[wr_addr_1>>ROW_W][ wr_addr_1[ROW_W-1:0] ] <= wr_val_1 | wr_val_2; //wr_addr2==wr_addr1
            else if(wr_en_1)
                memory[wr_addr_1>>ROW_W][ wr_addr_1[ROW_W-1:0] ] <= wr_val_1;
            else if( wr_en_2) 
                memory[wr_addr_2>>ROW_W][ wr_addr_2[ROW_W-1:0] ] <= wr_val_2;
        end
    end







endmodule
