/**************************************
@ filename    : refmodel.sv
@ author      : yyrwkk
@ create time : 2024/05/19 15:51:28
@ version     : v1.0.0
**************************************/
`ifndef MPCACHE_RM
`define MPCACHE_RM
`include "mpcache.svh"
`include "transaction.sv"
`include "record.sv"
// import "DPI-C" function void crc32_init();
// import "DPI-C" function void crc32_indata(input int data);
// import "DPI-C" function int  crc32_calc();
class refmodel;
    
    mailbox #(transaction) in_chan;
	mailbox #(record)      out_chan [`OUT_PORT_NUM];

    extern function new(input mailbox #(transaction)in_chan, input mailbox #(record)out_chan  [`OUT_PORT_NUM]);
	extern virtual task run();
	extern virtual task send_out(ref record rd);
endclass

function refmodel::new(input mailbox #(transaction)in_chan, input mailbox #(record)out_chan  [`OUT_PORT_NUM]);
    this.in_chan  = in_chan ;
    this.out_chan = out_chan;
endfunction

task refmodel::run();
    record      rd;
    transaction tr;
    while(1) begin
        in_chan.get(tr);
        rd = new(tr.frame[0][20:17],tr.frame[0][3:0],tr.frame[0][6:4],tr.frame[0][16:7]);
        // crc32_init();
        // foreach(tr.frame[i]) begin
        //     crc32_indata(tr.frame[i]);
        // end
        // rd.crc32 = crc32_calc();
        rd.crc32 = 0;
        send_out(rd);
    end

endtask

task refmodel::send_out(ref record rd);
    out_chan[rd.da].put(rd);
endtask


`endif