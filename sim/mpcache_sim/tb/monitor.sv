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
    int port;
    int fd  ;
    int max_speed_clk ;
    int speed_clk     ;
    extern function new( input virtual mp_if vmif,input int port);
    extern virtual task run();
endclass

function monitor::new(input virtual mp_if vmif,input int port);
    this.vmif = vmif;
    this.port = port; 
    // this.fd   = $fopen( $sformatf("E:/MultiPortCache/sim/mpcache_sim/data/out/out_file_%0d.txt", port),"w");
    this.fd      = $fopen( $sformatf("E:/MultiPortCache/script/check_data/data/out/out_file_%0d.txt", port),"w");
    speed_clk = 0;
    max_speed_clk = 0;
endfunction

task monitor::run();
    int speed_cnt;
    while(1) begin
        @(posedge vmif.clk);
        speed_cnt += 1;

        if( vmif.rd_vld[port] === 1'b1 ) begin
            $fwrite(fd,"%h",vmif.rd_data[port]);
            speed_clk += 1;
        end else if( vmif.rd_eop[port] === 1'b1) begin
            $fwrite(fd,"\n");
        end

        if( speed_cnt == 512 ) begin
            $display("@%0t port %2d -> recv speed %.2f Gbps [ref clk : %3d MHz]",$time,port, speed_clk/512.0 * 32.0 * 250.0 / 1000.0,250);

            if( speed_clk > max_speed_clk ) max_speed_clk = speed_clk;
            speed_cnt = 0;
            speed_clk = 0;
        end
    end
endtask

// class monitor;
// 	virtual mp_if  vmif;
//     mailbox#(transaction) mon2check;
// 	int port;
	
// 	extern function new( input mailbox mon2chk_chan,input virtual mp_if vmif,input int port);
// 	extern virtual task run();
// 	//extern virtual task send_chk(ref transaction tr);
// endclass

// function monitor::new( input mailbox mon2chk_chan,input virtual mp_if vmif,input int port);
//     //this.mon2check = mon2check;
// 	this.vmif = vmif          ;
//     this.port = port          ;
// endfunction : new

// task monitor::run();
//     transaction tr;
// 	//$display("At %0t, [MON NOTE]: run start!", $time);
//     int start_flag = 0;
// 	while(1) begin
// 		@(posedge vmif.clk);
//         if( vmif.wr_sop[port] == 1&& start_flag == 0) begin
//             $display("@%0t the port -> %d, send a packet",$time,port);
//             start_flag = 1;
//             tr = new();
//         end
//         if( start_flag==1 && vmif.wr_vld[port]) begin
//             tr.frame.push_back(vmif.wr_data[port]);
//         end
//         if( vmif.wr_eop[port] == 1 && start_flag == 1) begin
//             start_flag = 0;
//             send_chk(tr);
//         end
// 	end
// endtask : run
	
// task monitor::send_chk(ref transaction tr);
//     mon2check.put(tr);
// endtask : send_chk	

`endif