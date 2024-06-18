/**************************************
@ filename    : tb_fifo_top.sv
@ author      : yyrwkk
@ create time : 2024/04/24 16:36:15
@ version     : v1.0.0
**************************************/

module tb_fifo_top();

logic clk_out;

initial begin
    clk_out = 1'b0;
end
initial begin
    forever #5 clk_out = ~clk_out;
end

fifo_if#(
    .DATA_WIDTH ('d32),
    .ADDR_WIDTH ('d13)
)fif(clk_out);

tb_fifo #(    
    .DATA_WIDTH ('d32),
    .ADDR_WIDTH ('d13)
)tb_fifo_inst(fif);

// fifo #(
//     .DATA_WIDTH ('d32),
//     .ADDR_WIDTH ('d13),
//     .FWFT_EN    (1'b0) // First word fall-through without latency
// )fifo_inst_nofwft(
//     .din              (fif.din),
//     .wr_en            (fif.wr_en),
//     .full             (fif.full),
//     .almost_full      (fif.almost_full),

//     .dout             (fif.dout),
//     .rd_en            (fif.rd_en),
//     .empty            (fif.empty),
//     .almost_empty     (fif.almost_empty),

//     .clk              (fif.clk),
//     .rst_n              (fif.rst_n)
// );

fifo #(
    .DATA_WIDTH ('d32),
    .ADDR_WIDTH ('d13),
    .FWFT_EN    (1'b1) // First word fall-through without latency
)fifo_inst_fwft(
    .din              (fif.din),
    .wr_en            (fif.wr_en),
    .full             (fif.full),
    .almost_full      (fif.almost_full),

    .dout             (fif.dout),
    .rd_en            (fif.rd_en),
    .empty            (fif.empty),
    .almost_empty     (fif.almost_empty),

    .clk              (fif.clk),
    .rst_n            (fif.rst_n)
);


endmodule

