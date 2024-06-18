`ifndef MPCACHE_ENV
`define MPCACHE_ENV

class env_cfg;
    
    static int port_ncells[$]= {
        1,
        1,
        1,
        1,

        1,
        1,
        1,
        1,

        1,
        1,
        1,
        1,

        1,
        1,
        1,
        1
    };

    static int port_enable[$] = {
        1,
        0,
        0,
        0, 

        0,
        0,
        0,
        0, 

        0,
        0,
        0,
        0, 

        0,
        0,
        0,
        0
    };
endclass:env_cfg

`endif