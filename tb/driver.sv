`ifndef MPCACHE_DRIVER
`define MPCACHE_DRIVER
`include "mp_if.sv"
`include "transaction.sv"


class driver;
  mailbox #(transaction)gen2drv;
  event   drv2gen;
  virtual mp_if vmif;
  int portid        ;

  extern function new(input mailbox gen2drv, input event drv2gen,input virtual mp_if  vmif,int portid);
  extern task rst();
  extern task run();
  extern task send(ref transaction tr);
  
endclass:driver

function driver::new(input mailbox gen2drv, input event drv2gen,input virtual mp_if  vmif ,int portid);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;
    this.vmif    = vmif   ;
    this.portid  = portid ;
endfunction

task driver::run();   // 没有添加钩子函数
    transaction tr;
    int cellidx;
    cellidx = 0;
    rst();
    // 需要添加等待复位信号的处理
    wait(vmif.rst_n_in==1'b1);
    forever begin
        gen2drv.peek(tr);  // 从mailbox中读取一个信元
        $display("@%0t,[port %d] send %d cell",$time,portid,cellidx);
        $display("driver tr datalen: %d",tr.data.size());
        send(tr)        ;
        gen2drv.get(tr) ;  // 从mailbox中删除该信元
        repeat(2000) @(posedge vmif.clk);
        ->drv2gen;         // 通知发生器信元处理完成
        cellidx++;
    end
endtask

task driver::send(ref transaction tr);
    tr.pack();
    tr.display_frame();
    @(posedge vmif.clk);
    vmif.wr_sop[portid]         <= 'b1;
    @(posedge vmif.clk);
    vmif.wr_sop[portid]         <= 'b0;
    for( int i=0;i<tr.frame.size();i++) begin
        vmif.wr_vld[portid]     <=  1'b1;
        vmif.wr_data[portid]    <= tr.frame[i];
        @(posedge vmif.clk);
    end
    vmif.wr_vld[portid]     <=  1'b0;
    vmif.wr_data[portid]    <= 'b0;
    vmif.wr_eop[portid]     <= 1'b1;
    @(posedge vmif.clk);
    vmif.wr_eop[portid]     <= 1'b0;
endtask

task driver::rst();
    vmif.wr_eop[portid]         <= 'b0;         
    vmif.wr_sop[portid]         <= 'b0;           
    vmif.wr_vld[portid]         <= 'b0;            
    vmif.wr_data[portid]        <= 'b0;  
endtask

`endif