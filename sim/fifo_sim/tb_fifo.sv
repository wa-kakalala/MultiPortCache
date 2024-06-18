/**************************************
@ filename    : tb_fifo.sv
@ author      : yyrwkk
@ create time : 2024/04/24 16:36:24
@ version     : v1.0.0
**************************************/
program tb_fifo#(
    parameter DATA_WIDTH    = 8 ,
    parameter ADDR_WIDTH    = 4 
)(fifo_if fif);

initial begin
    fif.wr_en = 1'b0;
    fif.rd_en = 1'b0;
    fif.rst_n = 1'b0;
    fif.din   = 'b0;
end

task automatic write_task( input logic [DATA_WIDTH-1:0] data);
    @(posedge fif.clk);
    fif.wr_en <= 1'b1;
    fif.din   <= data;
    @(posedge fif.clk);
    fif.wr_en <= 1'b0;
endtask:write_task

task automatic read_task();
    @(posedge fif.clk);
    fif.rd_en <= 1'b1;
    // @(posedge fif.clk);
    // fif.rd_en <= 1'b0;
endtask:read_task

initial begin
    repeat(2) @(posedge fif.clk);
    fif.rst_n <= 1'b1;
    for( int i=0;i<8192;i++ )begin
        write_task(i);
    end

    for( int i = 0;i<8192;i++) begin
        read_task();
        if( fif.dout != i) begin
            $display("@%0t: error occure, true value : %d, read value : %d",$time,i,fif.dout);
            $stop;
        end
        @(posedge fif.clk);
        fif.rd_en <= 1'b0;
    end

    $display("Successfully, all Pass");

end

endprogram