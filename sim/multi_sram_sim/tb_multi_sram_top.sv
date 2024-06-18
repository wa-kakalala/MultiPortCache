module tb_multi_sram_top();
logic clk_out;

initial begin
    clk_out = 1'b0;
    forever #5 clk_out = ~clk_out;
end

multi_sram_if msif(clk_out,clk_out);

multi_sram # (
    .DWIDTH (32),
    .AWIDTH (15)
)multi_sram_inst(
    .clk_a_in                  (msif.clk_a_in ),
    .en_a_in                   (msif.en_a_in  ),
    .we_a_in                   (msif.we_a_in  ),
    .addr_a_in                 (msif.addr_a_in),
    .d_a_in                    (msif.d_a_in   ),
    .d_a_out                   (msif.d_a_out  ),

    .clk_b_in                  (msif.clk_b_in  ),
    .en_b_in                   (msif.en_b_in  ),
    .we_b_in                   (msif.we_b_in  ),
    .addr_b_in                 (msif.addr_b_in),
    .d_b_in                    (msif.d_b_in   ),
    .d_b_out                   (msif.d_b_out  )
);

tb_multi_sram #(
    .DWIDTH (32),
    .AWIDTH (15)
)tb_multi_sram_inst( msif );

endmodule