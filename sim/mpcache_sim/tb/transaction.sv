`ifndef MPCACHE_TRANSACTION
`define MPCACHE_TRANSACTION

class basetr;

endclass

class transaction extends basetr;
    rand bit [3:0] da     ;
    rand bit [2:0] prority;
    rand bit [9:0] len    ;
    // 15 bit zeros -> reserved
    rand bit [7:0] data[$];

    static bit [14:0] prefix = 0;

    bit [31:0] frame[$]   ;   // 将数据封装成frame

    constraint da_cons{
		da inside {[0:15]};
	};

    constraint prority_cons{
		prority inside {[0:7]};
	};

    constraint len_cons{
		len inside {[63:1023]};
        //len == 4;
	};

    constraint data_cons{
		data.size() == len-4+1;
	};

    extern function new();
    extern virtual function void display(input string prefix="");
    extern function void post_randomize();
    extern virtual function transaction copy(input transaction to=null);
    extern virtual function void pack();
    extern virtual function void display_frame();


endclass

function transaction::new();

endfunction 

function void transaction::display(input string prefix="");
    $display("[%s]-> da = %d,prority= %d,len = %d",prefix, this.da, this.prority, this.len);
endfunction

function transaction transaction::copy(input transaction to=null);
    transaction tmp;
	if (to == null) begin
		tmp = new();
    end
	// $cast(tmp, to);
	tmp.da = this.da;
    tmp.len = this.len;
	tmp.prority  = this.prority;
    // $display("data len in copy : %d",this.data.size());
	foreach(this.data[i])begin
		tmp.data.push_back(this.data[i]);
	end
	return tmp;
endfunction

function void transaction::pack();
    int leave;
    int idx ;
    frame.push_back({prefix,len,prority,da});
    prefix ++;
    leave = data.size() % 4;
    if( leave != 0 ) begin
        for( int i =0;i<4-leave;i++) begin
            data.push_back(8'b0);
        end
    end
    for( int idx = 0;idx<data.size() ;idx+=4) begin
        frame.push_back({data[idx+3],data[idx+2],data[idx+1],data[idx]});
    end
    idx = 1;
    for( int i=1;i<frame.size();i++) begin
        frame[i] = idx++;
    end
endfunction

function void transaction::display_frame();
    $display("frame len : %d ",frame.size());
endfunction

function void transaction::post_randomize();
    static int da_port = 0;
    
    da = da_port ++;
endfunction

`endif




