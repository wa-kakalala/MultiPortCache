`timescale 1ns / 1ps



`include "./mpcache.svh"
module Print2file#(
    parameter   data_type = 0,   //0:in   1:out
    parameter   channel_idx = 0
)
(
    input   logic                               clk_in,
    input   logic                               rst_n_in,
    
    input  logic   i_eop                     ,
    input  logic   i_sop                     ,
    input  logic   i_vld                     ,
    input  logic[`DATA_WIDTH-1:0  ]    i_data 
    
    );

integer handle_gen;
initial begin
    if(data_type)begin
        case(channel_idx)
            0 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_0.txt");
            end
            1 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_1.txt");
            end
            2 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_2.txt");
            end
            3 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_3.txt");
            end
            4 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_4.txt");
            end
            5 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_5.txt");
            end
            6 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_6.txt");
            end
            7 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_7.txt");
            end
            8 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_8.txt");
            end
            9 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_9.txt");
            end
            10 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_10.txt");
            end
            11 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_11.txt");
            end
            12 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_12.txt");
            end
            13 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_13.txt");
            end
            14 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_14.txt");
            end
            15 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_15.txt");
            end
            default : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\out_file\\out_file_0.txt");
            end
        endcase
    end
    else begin
        case(channel_idx)
            0 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_0.txt");
            end
            1 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_1.txt");
            end
            2 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_2.txt");
            end
            3 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_3.txt");
            end
            4 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_4.txt");
            end
            5 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_5.txt");
            end
            6 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_6.txt");
            end
            7 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_7.txt");
            end
            8 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_8.txt");
            end
            9 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_9.txt");
            end
            10 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_10.txt");
            end
            11 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_11.txt");
            end
            12 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_12.txt");
            end
            13 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_13.txt");
            end
            14 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_14.txt");
            end
            15 : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_15.txt");
            end
            default : begin
                handle_gen  =  $fopen("D:\\Documents\\myCareer\\program\\2024ICcontest\\ZFY\\project_sram_controllor\\sim_print\\in_file\\in_file_0.txt");
            end
        endcase
    end
end

always@(posedge clk_in)begin
    if(i_vld)begin
        $fwrite(handle_gen,"%h",i_data);
    end
    else if(i_eop)begin
        $fwrite(handle_gen,"\n");
    end
end

endmodule
