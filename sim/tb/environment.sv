`ifndef MPCACHE_ENVIRONMENT
`define MPCACHE_ENVIRONMENT

`include "env_cfg.sv"
`include "generator.sv"
`include "driver.sv"
`include "mp_if.sv"
`include "monitor.sv"
`include "record.sv"
`include "refmodel.sv"
`include "mpchecker.sv"

// ref: https://gitee.com/gjm9999/systemverilog_testbench_demo/tree/master/modelsim_demo/source

class environment;
    virtual mp_if vmif;
    generator gen[16];
    driver    drv[16];
     

    mailbox #(transaction) gen2drv[16];
    event     drv2gen[16];

    mailbox #(transaction) in_mon2rm   ;
    mailbox #(transaction) out_mon2rm  ;

    mailbox #(record     ) expect_rd[16];
    mailbox #(record     )   real_rd[16];

    monitor in_mon  [16];
    monitor out_mon [16];

    refmodel expect_rm;
    refmodel real_rm  ;
    mpchecker mpcheck ;

    extern function new(input virtual mp_if vmif);

    extern virtual function void build();  
      
    extern virtual task run();
    extern virtual task wrap_up();

endclass:environment


function environment::new(input virtual mp_if vmif);
    this.vmif = vmif;
endfunction

function void environment::build(); 
    for( int i=0;i<16;i++) begin
        gen2drv[i] = new();
        gen[i] = new( gen2drv[i],drv2gen[i],env_cfg::port_ncells[i]);
        drv[i] = new(gen2drv[i],drv2gen[i],vmif,i);
        // in_mon[i] = new(in_mon2rm,vmif,i);
        // out_mon[i]   = new(out_mon2rm,vmif,i);
        // expect_rd[i] = new();
        // real_rd[i] = new();
    end
    // in_mon2rm = new();
    // out_mon2rm=new();
    // expect_rm = new(in_mon2rm,expect_rd);
    // real_rm = new(out_mon2rm,real_rd);
    // mpcheck = new(expect_rd,real_rd);
endfunction

task environment::run();
    int num_gen_running = 16;
    foreach(gen[i]) begin
        int j = i;  
        fork
            begin 
                if( env_cfg::port_enable[j]) begin
                    gen[j].run();     // 等待发生器结束
                end
                num_gen_running --;   // 减少驱动器的个数
            end
            begin
                $display("@%0t,the [%d] driver begin to work",$time,j);
                drv[j].run();
            end
        join_none
    end
    // fork
    //     expect_rm.run();
    //     real_rm.run();
    //     mpcheck.run();
    // join_none

    // 等待所有发生器结束或者超时
    fork:timeout_block
        begin
            wait(num_gen_running == 0);
            $display("@%0t [TEST NOTE]: simulation finish~~~~~~~~~~~~~~~~~~", $time);
        end
        begin
           repeat(100_000_000) @(vmif.clk);
           $display("@%0t: Error, Generator timeout",$time); 
        end
    join_any
    disable timeout_block;
    
endtask

task environment::wrap_up();
    // 暂时为空，调用记分板(scoreboard)生成报告
endtask
`endif