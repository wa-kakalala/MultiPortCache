/**************************************
@ filename    : monitor.sv
@ author      : yyrwkk
@ create time : 2024/05/19 15:32:35
@ version     : v1.0.0
**************************************/
`ifndef MPCACHE_MONITOR
`define MPCACHE_MONITOR

`include "mp_if.sv"
`include "transaction.sv"

class monitor;
	virtual mp_if  vmif;
    mailbox#(transaction) mon2check;
	int port;
	
	extern function new( input mailbox mon2chk_chan,input virtual mp_if vmif,input int port);
	extern virtual task run();
	extern virtual task send_chk(ref transaction tr);
endclass

function monitor::new( input mailbox mon2chk_chan,input virtual mp_if vmif,input int port);
    this.mon2check = mon2check;
	this.vmif = vmif          ;
    this.port = port          ;
endfunction : new

task monitor::run();
    transaction tr;
	//$display("At %0t, [MON NOTE]: run start!", $time);
    int start_flag = 0;
	while(1) begin
		@(posedge vmif.clk);
        if( vmif.wr_sop[port] == 1&& start_flag == 0) begin
            $display("@%0t the port -> %d, send a packet",$time,port);
            start_flag = 1;
            tr = new();
        end
        if( start_flag==1 && vmif.wr_vld[port]) begin
            tr.frame.push_back(vmif.wr_data[port]);
        end
        if( vmif.wr_eop[port] == 1 && start_flag == 1) begin
            start_flag = 0;
            send_chk(tr);
        end
	end
endtask : run
	
task monitor::send_chk(ref transaction tr);
    mon2check.put(tr);
endtask : send_chk	

`endif