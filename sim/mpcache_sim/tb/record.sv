/**************************************
@ filename    : record.sv
@ author      : yyrwkk
@ create time : 2024/05/19 15:57:06
@ version     : v1.0.0
**************************************/
`ifndef MPCACHE_RECORD
`define MPCACHE_RECORD
class record;
    int src   ;
    int da    ;
    int prior ;
    int len   ;

    int crc32 ;

    extern function new(int src, int da, int prior,int len );
    extern virtual function int compare(input record r);
endclass

function record::new(int src, int da, int prior,int len    );
    this.src = src;
    this.da = da;
    this.prior = prior;
    this.len = len;
endfunction

function int record::compare(input record r);
    if( (this.src == r.src) && (this.da == r.da) && (this.prior == r.prior) && (this.len == r.len) && (this.crc32 == r.crc32 ) ) return 1;
    else return 0;
endfunction

`endif