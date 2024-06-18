program tb_multi_sram#(
    parameter DWIDTH      =  32                    ,
    parameter NRAMWIDHT   =  5                     ,
    parameter AWIDTH      =  13                 
  )(multi_sram_if msif);

  typedef enum{PORTA, PORTB} PORT;

  task automatic write_to_ram(input logic[AWIDTH-1:0] addr,input logic[DWIDTH-1:0] data,input PORT port);
    if( port == PORTA )
    begin
      msif.en_a_in <= 1'b1;
      msif.we_a_in <= 1'b1;
      msif.addr_a_in <= addr;
      msif.d_a_in    <= data;
      //$display("@%0t: PortA write at %h with value %d !",$time,addr,data);
      @(posedge msif.clk_a_in);
      msif.en_a_in <= 1'b0;
      msif.we_a_in <= 1'b0;
    end
    else if(  port == PORTB )
    begin
      msif.en_b_in <= 1'b1;
      msif.we_b_in <= 1'b1;
      msif.addr_b_in <= addr;
      msif.d_b_in    <= data;
      //$display("@%0t: PortB write at %h with value %d !",$time,addr,data);
      @(posedge msif.clk_b_in);
      msif.en_b_in <= 1'b0;
      msif.we_b_in <= 1'b0;
    end
    else
    begin
      $display("@%0t: Write event with error port number !",$time);
    end
  endtask

  task automatic read_from_ram(input logic[AWIDTH-1:0] addr,input PORT port);
    if( port == PORTA )
    begin
      msif.en_a_in <= 1'b1;
      msif.we_a_in <= 1'b0;
      msif.addr_a_in <= addr;
      @(posedge msif.clk_a_in);
      msif.en_a_in <= 1'b0;
      //$display("@%0t: PortA read at %h with value : %d!",$time,addr,msif.d_a_out);
    end
    else if(  port == PORTB )
    begin
      msif.en_b_in <= 1'b1;
      msif.we_b_in <= 1'b0;
      msif.addr_b_in <= addr;
      @(posedge msif.clk_a_in);
      msif.en_b_in <= 1'b0;
      //$display("@%0t: PortB read at %h with value : %d!",$time,addr,msif.d_b_out);
    end
    else
    begin
      $display("@%0t: Read event with error port number !",$time);
    end
  endtask

  initial
  begin
    msif.en_a_in    = 'b0     ;
    msif.we_a_in    = 'b0     ;
    msif.addr_a_in  = 'b0     ;
    msif.d_a_in     = 'b0     ;

    msif.en_b_in    = 'b0     ;
    msif.we_b_in    = 'b0     ;
    msif.addr_b_in  = 'b0     ;
    msif.d_b_in     = 'b0     ;

  end

  initial
  begin
    @(posedge msif.clk_a_in);
    for( int i=0;i<('d2 << NRAMWIDHT+AWIDTH);i++)begin
        write_to_ram(i,i,PORTA);
    end
    
    @(posedge msif.clk_b_in);
    for( int i=0;i<('d2 << NRAMWIDHT+AWIDTH);i++)begin
        read_from_ram(i,PORTB);
        if( msif.d_b_out != i ) begin
            $display("@%0t: PortB read at %h with value : %d!",$time,i,msif.d_b_out);
            $display("error");
            $stop();
        end

        @(posedge  msif.clk_b_in);
    end
   
    $display("all pass");
    $stop;



  end

endprogram
