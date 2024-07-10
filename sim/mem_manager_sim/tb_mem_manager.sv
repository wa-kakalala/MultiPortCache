


//~ `New testbench
`timescale  1ns / 1ps

module tb_mem_manager;

    // rom_manager Parameters
    parameter PERIOD     = 10          ;
    parameter AWIDTH     = 10          ;

    // rom_manager Inputs
    logic   clk                                  = 0 ;
    logic   rst_n                                = 0 ;

    logic   ocp_req                              = 0 ;
    logic   [AWIDTH-1:0]  rls_block_addr         = 0 ;
    logic   rls_vld                              = 0 ;

    // rom_manager Outputs
    logic  ocp_rsp                              ;
    logic  [AWIDTH-1:0]  ocp_block_addr         ;
    logic  ocp_vld                              ;
    logic  full                                 ;
    logic  almost_full                          ;
    logic  empty                                ;

    logic [AWIDTH-1:0] the_rls_addr = 'h0; 




    mem_manager #(
        .AWIDTH    ( AWIDTH    )
        )
    u_mem_manager (
        .clk                     ( clk                          ),
        .rst_n                   ( rst_n                        ),
        
        
        .rls_block_addr          ( rls_block_addr  [AWIDTH-1:0] ),
        .rls_vld                 ( rls_vld                      ),

        .ocp_req                 ( ocp_req                      ),
        .ocp_rsp                 ( ocp_rsp                      ),
        .ocp_block_addr          ( ocp_block_addr  [AWIDTH-1:0] ),
        .ocp_vld                 ( ocp_vld                      ),

        .emp_block_num           (                              ),


        .full                    ( full                         ),
        .almost_full             ( almost_full                  ),
        .empty                   ( empty                        )
    );


    task req_addr(
    );
        automatic int random_n;
        random_n = $urandom_range(1, 10);
        // one clk
        @(posedge clk) begin
            ocp_req <= 1;
        end
        @(posedge clk ) begin
            ocp_req <= 0;
        end

        //wait for ocp vld
        wait( ocp_vld );

        #(random_n* PERIOD);

    endtask


    task rls_addr(
        input [AWIDTH-1:0] addr
    );

        automatic int random_n;
        random_n = $urandom_range(1, 10);

        
        @(posedge clk) begin
            rls_block_addr <= addr;
            rls_vld <= 1'b1;
        end

        @(posedge clk ) begin
            rls_block_addr <= 'b0;
            rls_vld <= 1'b0;
        end

        #(random_n* PERIOD);

    endtask


    task req_rls_addr(
        input [AWIDTH-1:0] rls_addr
    );
        // one clk 
        @(posedge clk) begin
            rls_block_addr <= rls_addr;
            rls_vld <= 1'b0;
            ocp_req <= 'b1;//
        end
        @(posedge clk) begin
            rls_block_addr <= rls_addr;
            rls_vld <= 1'b1;
            ocp_req <= 'b0;
        end
        @(posedge clk ) begin
            rls_block_addr <= rls_addr;
            rls_vld <= 1'b0;
            ocp_req <= 'b0;
        end


        //wait
        #(2* PERIOD);

    endtask
    




    initial
    begin
        forever #(PERIOD/2)  clk=~clk;
    end

    initial
    begin
        #(PERIOD*2) rst_n  =  1;
    end


    initial
    begin
        #117;

        // for(int i=0; i<1300; i++) begin
        //     req_addr();
        // end

        // rls_addr('h07 );

        // rls_addr('h13 );

        // rls_addr('h29);

        // for(int i=0; i<1000; i++) begin
        //     req_addr();
        // end
        //  #1000;

        
        for(int i=0; i<1220; i++) begin
            req_rls_addr(the_rls_addr+i);
        end

        #1000;

        $stop;
    end

endmodule