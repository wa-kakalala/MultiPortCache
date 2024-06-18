/**************************************
@ filename    : tb_crc32_d32.sv
@ author      : yyrwkk
@ create time : 2024/05/07 23:10:06
@ version     : v1.0.0
**************************************/
`timescale 1ps/1ps

module tb_crc32_d32();

logic          i_clk    ;
logic          i_rst_n  ;
logic [31:0]   i_d      ;
logic          i_d_vld  ;
logic          i_clr    ;

logic [31:0]   o_crc    ;

crc32_d32 crc32_d32_inst (
    .i_clk    (i_clk  ),
    .i_rst_n  (i_rst_n),

    .i_d      (i_d    ),
    .i_d_vld  (i_d_vld),
    .i_clr    (i_clr  ),

    .o_crc    (o_crc  )
);

task automatic show_pass();
begin: pass
    $display("pwd: %m");
    $display(".----------------.  .----------------.  .----------------.  .----------------. " ); 
    $display("| .--------------. || .--------------. || .--------------. || .--------------. |");
    $display("| |   ______     | || |      __      | || |    _______   | || |    _______   | |");
    $display("| |  |_   __ \   | || |     /  \     | || |   /  ___  |  | || |   /  ___  |  | |");
    $display("| |    | |__) |  | || |    / /\ \    | || |  |  (__ \_|  | || |  |  (__ \_|  | |");
    $display("| |    |  ___/   | || |   / ____ \   | || |   '.___`-.   | || |   '.___`-.   | |");
    $display("| |   _| |_      | || | _/ /    \ \_ | || |  |`\____) |  | || |  |`\____) |  | |");
    $display("| |  |_____|     | || ||____|  |____|| || |  |_______.'  | || |  |_______.'  | |");
    $display("| |              | || |              | || |              | || |              | |");
    $display("| '--------------' || '--------------' || '--------------' || '--------------' |");
    $display("'----------------'  '----------------'  '----------------'  '----------------' " );   
    $display("time: %t",$time );
end
endtask

logic [31:0] src_data[$];
reg   [31:0] crc_reg    ;
initial begin
    i_clk    = 'b0;
    i_rst_n  = 'b0;
    i_d      = 'b0;
    i_d_vld  = 'b0;
    for( int i=0;i<100;i++) begin
        src_data.push_back($urandom());
    end
    $display("---------- src data begin -------------- ");
    foreach(src_data[i]) begin
        $display(src_data[i]);
    end
    $display("---------- src data  end  -------------- ");

end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    @(posedge i_clk);
    i_rst_n <= 1'b1;
    @(posedge i_clk);
    $display("start calc crc------------");
    i_clr <= 1'b1;
    @(posedge i_clk);
    i_clr <= 1'b0;
    @(posedge i_clk);
    foreach(src_data[i]) begin
        i_d <= src_data[i];
        i_d_vld <= 1'b1;
        @(posedge i_clk);
    end
    i_d <= 'b0;
    i_d_vld <= 1'b1;
    @(posedge i_clk);
    i_d <= 'b0;
    i_d_vld <= 1'b0;
    crc_reg <= o_crc;
    @(posedge i_clk);
    $display("crc_result: %h",o_crc);

    $display("start valid crc------------");
    @(posedge i_clk);
    i_clr <= 1'b1;
    @(posedge i_clk);
    i_clr <= 1'b0;
    @(posedge i_clk);
    foreach(src_data[i]) begin
        i_d <= src_data[i];
        i_d_vld <= 1'b1;
        @(posedge i_clk);
    end
    i_d <= crc_reg;
    i_d_vld <= 1'b1;
    @(posedge i_clk);
    i_d <= 'b0;
    i_d_vld <= 1'b0;
    @(posedge i_clk)
    $display("crc_result: %h",o_crc);
    if(!o_crc  ) begin
        show_pass();
    end

    $stop;

end



endmodule
