`ifndef MPCACHE_ENV
`define MPCACHE_ENV

class env_cfg;
    
    static int port_ncells[$]= {
        16,
        16,
        16,
        16,

        16,
        16,
        16,
        16,

        16,
        16,
        16,
        16,

        16,
        16,
        16,
        16
    };

    static int port_enable[$] = {
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
endclass:env_cfg

`endif