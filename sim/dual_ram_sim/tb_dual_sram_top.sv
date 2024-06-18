module tb_dual_sram_top();
logic clk_out;

initial begin
    clk_out = 1'b0;
    forever #5 clk_out = ~clk_out;
end

dpram_if #(
    .DWIDTH (32),
    .AWIDTH (15)
)dif(clk_out,clk_out);

dual_sram # (
    .DWIDTH (32),
    .AWIDTH (15)
)dual_sram_inst(
    .clk_a_in                  (dif.clk_a_in ),
    .en_a_in                   (dif.en_a_in  ),
    .we_a_in                   (dif.we_a_in  ),
    .addr_a_in                 (dif.addr_a_in),
    .d_a_in                    (dif.d_a_in   ),
    .d_a_out                   (dif.d_a_out  ),

    .clk_b_in                  (dif.clk_b_in  ),
    .en_b_in                   (dif.en_b_in  ),
    .we_b_in                   (dif.we_b_in  ),
    .addr_b_in                 (dif.addr_b_in),
    .d_b_in                    (dif.d_b_in   ),
    .d_b_out                   (dif.d_b_out  )
);

tb_dual_sram #(
    .DWIDTH (32),
    .AWIDTH (15)
)tb_dual_sram_inst( dif );

endmodule