
//~ `New testbench
`timescale  1ns / 1ps

module tb_bit_map2;

    // bit_map2 Parameters
    parameter PERIOD = 10          ;
    parameter WIDTH  = 8           ;
    parameter DEPTH  = 8         ;
    parameter ROW_W  = $clog2(WIDTH);
    parameter COL_W  = $clog2(DEPTH);

    // bit_map2 Inputs
    logic   clk                                  = 0 ;
    logic   rst                                  = 1 ;

    logic   wr_en_1                                = 0 ;
    logic   [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ]  wr_addr_1 = 0 ;
    logic   wr_val_1                               = 0 ;

    logic   wr_en_2                                = 0 ;
    logic   [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ]  wr_addr_2 = 0 ;
    logic   wr_val_2                               = 0 ;


    logic   [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ]  emp_ready_addr  ;
    logic   full                               ;
    logic   almost_full                         ;


    initial
    begin
        forever #(PERIOD/2)  clk=~clk;
    end

    initial
    begin
        #(PERIOD*5) rst  =  0;
    end

    bit_map_rom #(
        .WIDTH ( WIDTH ),
        .DEPTH ( DEPTH )
        )
    u_bit_map (
        .clk                     ( clk                                   ),
        .rst                     ( rst                                   ),
        .wr_en_1                   ( wr_en_1                                 ),
        .wr_addr_1                 ( wr_addr_1                               ),
        .wr_val_1                  ( wr_val_1                                ),
        
        .wr_en_2                   ( wr_en_2                                 ),
        .wr_addr_2                 ( wr_addr_2                               ),
        .wr_val_2                  ( wr_val_2                                ),

        .emp_ready_addr            ( emp_ready_addr                          ),
        .full                      ( full                                    ),
        .almost_full               ( almost_full                             )
    );


    task write_interface1( 
        input [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ]  addr,
        input                               val
         );
        @(posedge clk) begin
            wr_en_1 <= 1'b1;
            wr_addr_1 <= addr;
            wr_val_1  <= val;
        end
    endtask

    task wr_en_interface1( 
         );
            wr_en_1  = 1'b1;
    endtask

    task wr_cls_interface1( 
         );
            @(posedge clk) begin
                wr_en_1  <= 1'b0;
            end
    endtask


    task write_interface2( 
        input [$clog2(DEPTH)+$clog2(WIDTH)-1 : 0 ]  addr,
        input                               val
         );
        @(posedge clk) begin
            wr_en_2 <= 1'b1;
            wr_addr_2 <= addr;
            wr_val_2  <= val;
        end
    endtask

    task wr_en_interface2( 
         );
            wr_en_2  = 1'b1;
    endtask

    task wr_cls_interface2( 
         );
            @(posedge clk) begin
                wr_en_2  <= 1'b0;
            end
    endtask

    


    initial
    begin
        #100;

        // for(int i=0; i<64; i++) begin
        //     write(i*4, 1);
        //     #(2*PERIOD);
        // end
        

        // rst = 1;
        // #(2*PERIOD);

        // rst = 0;
        // #(2*PERIOD);

        for(int i=0; i<63; i++) begin
            write_interface1(i, 1);
            // write_interface2(800-i, 1);
        end
        write_interface1(63, 1);
        wr_cls_interface1();
        write_interface2(55, 0);
        wr_cls_interface2();
        #(2*PERIOD);
        write_interface2(40, 0);
        wr_cls_interface2();
        #(2*PERIOD);
        write_interface2(22, 0);
        wr_cls_interface2();
        #(2*PERIOD);
        write_interface2(10, 0);
        wr_cls_interface2();
        #(2*PERIOD);
        write_interface2(6, 0);
        wr_cls_interface2();
        #(2*PERIOD);
        // wr_cls_interface1();


        // for(int i=0; i<300; i++) begin
        //     write_interface1(i, 0);
        //     write_interface2(800-i, 0);
        //     #(2*PERIOD);
        // end



        $stop;
    end

endmodule

