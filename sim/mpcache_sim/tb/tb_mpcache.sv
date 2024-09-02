`include "mp_if.sv"
`include "environment.sv"
program tb_mpcache(mp_if mif);
    environment env;

    initial begin
        env = new(mif);
        env.build();
        env.run();
        env.wrap_up();
        repeat(1000) @(posedge mif.clk);
        $stop;
    end
endprogram