program tb_dual_sram#(
    parameter DWIDTH = 32              ,
    parameter AWIDTH =  5
  )(dpram_if dif);

  typedef enum{PORTA, PORTB} PORT;

  task automatic write_to_ram(input logic[AWIDTH-1:0] addr,input logic[DWIDTH-1:0] data,input PORT port);
    if( port == PORTA )
    begin
      dif.en_a_in <= 1'b1;
      dif.we_a_in <= 1'b1;
      dif.addr_a_in <= addr;
      dif.d_a_in    <= data;
      $display("@%0t: PortA write at %h with value %d !",$time,addr,data);
      @(posedge dif.clk_a_in);
      dif.en_a_in <= 1'b0;
      dif.we_a_in <= 1'b0;
    end
    else if(  port == PORTB )
    begin
      dif.en_b_in <= 1'b1;
      dif.we_b_in <= 1'b1;
      dif.addr_b_in <= addr;
      dif.d_b_in    <= data;
      $display("@%0t: PortB write at %h with value %d !",$time,addr,data);
      @(posedge dif.clk_b_in);
      dif.en_b_in <= 1'b0;
      dif.we_b_in <= 1'b0;
    end
    else
    begin
      $display("@%0t: Write event with error port number !",$time);
    end
  endtask

  task automatic read_from_ram(input logic[AWIDTH-1:0] addr,input PORT port);
    if( port == PORTA )
    begin
      dif.en_a_in <= 1'b1;
      dif.we_a_in <= 1'b0;
      dif.addr_a_in <= addr;
      @(posedge dif.clk_a_in);
      dif.en_a_in <= 1'b0;
      $display("@%0t: PortA read at %h with value : %d!",$time,addr,dif.d_a_out);
    end
    else if(  port == PORTB )
    begin
      dif.en_b_in <= 1'b1;
      dif.we_b_in <= 1'b0;
      dif.addr_b_in <= addr;
      @(posedge dif.clk_a_in);
      dif.en_b_in <= 1'b0;
      $display("@%0t: PortB read at %h with value : %d!",$time,addr,dif.d_b_out);
      dif.en_b_in <= 1'b0;
    end
    else
    begin
      $display("@%0t: Read event with error port number !",$time);
    end
  endtask

  initial
  begin
    dif.en_a_in    = 'b0     ;
    dif.we_a_in    = 'b0     ;
    dif.addr_a_in  = 'b0     ;
    dif.d_a_in     = 'b0     ;

    dif.en_b_in    = 'b0     ;
    dif.we_b_in    = 'b0     ;
    dif.addr_b_in  = 'b0     ;
    dif.d_b_in     = 'b0     ;

  end

  initial
  begin
    @(posedge dif.clk_a_in);
    write_to_ram('d10,3,PORTA);
    @(posedge dif.clk_b_in);
    write_to_ram('d16,5,PORTB);
    @(posedge dif.clk_a_in);
    read_from_ram('d10,PORTA);
    @(posedge dif.clk_b_in);
    read_from_ram('d16,PORTB);

    repeat(10) @(posedge dif.clk_a_in);
    $stop;



  end

endprogram
