/**************************************
@ filename    : checker.sv
@ author      : yyrwkk
@ create time : 2024/05/19 16:32:26
@ version     : v1.0.0
**************************************/
`ifndef MPCACHE_CHECKER
`define MPCACHE_CHECKER
`include "mpcache.svh"
`include "record.sv"

class mpchecker;
    mailbox #(record) expect_box[`OUT_PORT_NUM];
    mailbox #(record) real_box  [`OUT_PORT_NUM];

    record  record_que  [`OUT_PORT_NUM][$];

    extern function new(input mailbox#(record) expect_box[`OUT_PORT_NUM],input mailbox#(record) real_box  [`OUT_PORT_NUM]);
    extern virtual task run();
endclass

function mpchecker::new(input mailbox#(record) expect_box[`OUT_PORT_NUM],input mailbox#(record) real_box  [`OUT_PORT_NUM]);
    this.expect_box = expect_box;
    this.real_box   = real_box  ;

endfunction

task mpchecker::run();
    record rd;
    int datalen = 0;
    int err_flag = 0;

    while(1) begin
        for( int i=0;i<`OUT_PORT_NUM;i++) begin
            if(expect_box[i].try_get(rd)) begin
                record_que[i].push_back(rd);
            end
        end
        for( int i=0;i<`OUT_PORT_NUM;i++) begin
            if(real_box[i].try_get(rd)) begin
                err_flag = 1;
                datalen = record_que[i].size();
                for( int j=0;j< datalen; j++ ) begin
                    if( rd.compare(record_que[i][j])) begin
                        err_flag = 0;
                        // 删除该元素j
                        record_que[i].delete(j); 
                        break;
                    end
                end
                if( err_flag ) begin
                    $display("@%0t,[not match]: %d->%d len: %d ",$time,rd.src,rd.da,rd.len);
                end

            end
        end 
    end

endtask

`endif