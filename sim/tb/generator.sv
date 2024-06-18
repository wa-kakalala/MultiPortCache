
`ifndef MPCACHE_GENERATOR
`define MPCACHE_GENERATOR

`include "transaction.sv"

`define SV_RAND_CHECK(r) \
do begin \
    if( !(r) ) begin \
        $display("%s:%0d: Randomization failed \"%s\"",\
            `__FILE__,`__LINE__,`"r`"); \
        $finish; \
    end \
end while(0)

class generator;
    transaction blueprint;
    mailbox #(transaction) gen2drv ;
    event   drv2gen ;

    int     ncells  ;  // 要产生的信元个数

    extern function new(input mailbox gen2drv,input event drv2gen,input int ncells);
    extern virtual task run();

endclass:generator

function generator::new(input mailbox gen2drv,input event drv2gen,input int ncells);
    this.gen2drv = gen2drv;
    this.drv2gen = drv2gen;
    this.ncells  = ncells ;
    blueprint    = new();
endfunction

task generator::run();
    transaction tr;
    repeat(ncells) begin
        `SV_RAND_CHECK(blueprint.randomize());
        blueprint.display("frame info");
        $cast(tr,blueprint.copy());
        gen2drv.put(tr);
        $display("@%0t,generator new cell",$time);
        @drv2gen;   // 等待driver完成
    end

endtask

`endif
