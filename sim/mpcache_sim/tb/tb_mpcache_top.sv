module tb_mpcache_top;
timeunit 10ns;
timeprecision 1ns;

logic i_clk  ;
logic i_rst_n;

initial begin
    i_rst_n = 0;
    i_clk = 0;
end

initial begin
    forever #5 i_clk = ~i_clk;
end

initial begin
    repeat(2) @(posedge i_clk);
    i_rst_n <= 1'b1;
end

mp_if mif(i_clk,i_rst_n);

tb_mpcache tb_mpcache_inst(mif);

mpcache mpcache_inst(
    .clk_in                     (mif.clk        ),
    .rst_n_in                   (mif.rst_n_in   ),
    .wr_eop                     (mif.wr_eop     ),
    .wr_sop                     (mif.wr_sop     ),
    .wr_vld                     (mif.wr_vld     ),
    .wr_data                    (mif.wr_data    ),
 //   .ready                      (mif.ready      ),
    .ready                      ({16{1'b1}}     ),
    .rd_eop                     (mif.rd_eop     ),
    .rd_sop                     (mif.rd_sop     ),
    .rd_vld                     (mif.rd_vld     ),
    .rd_data                    (mif.rd_data    ),
    .full                       (mif.full       ),
    .almost_full                (mif.almost_full)
);

endmodule