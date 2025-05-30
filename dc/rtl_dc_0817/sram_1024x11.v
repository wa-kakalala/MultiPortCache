//
//      CONFIDENTIAL  AND  PROPRIETARY SOFTWARE OF ARM Physical IP, INC.
//      
//      Copyright (c) 1993-2024  ARM Physical IP, Inc.  All  Rights Reserved.
//      
//      Use of this Software is subject to the terms and conditions  of the
//      applicable license agreement with ARM Physical IP, Inc.  In addition,
//      this Software is protected by patents, copyright law and international
//      treaties.
//      
//      The copyright notice(s) in this Software does not indicate actual or
//      intended publication of this Software.
//      
//      name:			Advantage Dual-Port SRAM Generator
//           			TSMC CLN90G Process
//      version:		2005Q4V1
//      comment:		
//      configuration:	 -instname "sram_1024x11" -words 1024 -bits 11 -frequency 250 -ring_width 2.0 -mux 16 -write_mask off -wp_size 8 -top_layer "met5-9" -power_type rings -horiz met3 -vert met4 -redundancy off -rcols 2 -rrows 2 -bmux off -ser none -ema on -cust_comment "" -bus_notation on -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,VSS:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type VSS -drive 6 -dpccm on -asvm off -corners ff_1.1_-40.0,ff_1.1_125.0,tt_1.0_25.0,ss_0.9_125.0
//
//      Verilog model for Synchronous Dual-Port Ram
//
//      Instance Name:              sram_1024x11
//      Words:                      1024
//      Bits:                       11
//      Mux:                        16
//      Drive:                      6
//      Write Mask:                 Off
//      Extra Margin Adjustment:    On
//      Accelerated Retention Test: Off
//      Redundant Rows:             0
//      Redundant Columns:          0
//      Test Muxes                  Off
//
//      Creation Date:  2024-08-16 17:12:29Z
//      Version: 	2005Q4V1
//
//      Modeling Assumptions: This model supports full gate level simulation
//          including proper x-handling and timing check behavior.  Unit
//          delay timing is included in the model. Back-annotation of SDF
//          (v2.1) is supported.  SDF can be created utilyzing the delay
//          calculation views provided with this generator and supported
//          delay calculators.  All buses are modeled [MSB:LSB].  All 
//          ports are padded with Verilog primitives.
//
//      Modeling Limitations: None.
//
//      Known Bugs: None.
//
//      Known Work Arounds: N/A
//
`timescale 1 ns/1 ps
`celldefine
  module sram_1024x11 (
                QA,
                QB,
                CLKA,
                CENA,
                WENA,
                AA,
                DA,
                CLKB,
                CENB,
                WENB,
                AB,
                DB,
                EMAA,
                EMAB
                );
   parameter                BITS = 11;
   parameter                WORD_DEPTH = 1024;
   parameter                ADDR_WIDTH = 10;
   parameter                WORDX = {BITS{1'bx}};
   parameter                WORD1 = {BITS{1'b1}};
   parameter                ADDRX = {ADDR_WIDTH{1'bx}};
   parameter                ADDR1 = {ADDR_WIDTH{1'b1}};
   parameter                WEN_WIDTH = 1;
   parameter                WP_SIZE    = 11 ;
   parameter                RCOLS = 0;
   parameter                MASKX = {WEN_WIDTH{1'bx}};
   parameter                MASK1 = {WEN_WIDTH{1'b1}};
   parameter                MASK0 = {WEN_WIDTH{1'b0}};
   parameter                MUX = 16;
   parameter                COL_ADDR_WIDTH = 4;
   parameter                RROWS = 0;
   parameter                UPM_WIDTH = 3;
   parameter                UPM0 = {UPM_WIDTH{1'b0}};
   parameter                RCA_WIDTH = 1;
   parameter                RED_COLUMNS = 2;
	
   output [10:0]            QA;
   output [10:0]            QB;
   input                    CLKA;
   input                    CENA;
   input                    WENA;
   input [9:0]              AA;
   input [10:0]             DA;
   input                    CLKB;
   input                    CENB;
   input                    WENB;
   input [9:0]              AB;
   input [10:0]             DB;
   input [2:0]              EMAA;
   input [2:0]              EMAB;

   reg [BITS+RED_COLUMNS-1:0]             mem [0:WORD_DEPTH-1];
   reg [BITS+RED_COLUMNS-1:0]             rows [(MUX*4)-1:0];   // added 2 bits for column redundancy

   reg                      NOT_CONTA;
   reg                      NOT_CONTB;

   reg                      NOT_CENA;
   reg                      NOT_WENA;
   reg                      NOT_AA9;
   reg                      NOT_AA8;
   reg                      NOT_AA7;
   reg                      NOT_AA6;
   reg                      NOT_AA5;
   reg                      NOT_AA4;
   reg                      NOT_AA3;
   reg                      NOT_AA2;
   reg                      NOT_AA1;
   reg                      NOT_AA0;
   reg [ADDR_WIDTH-1:0]     NOT_AA;
   reg                      NOT_DA10;
   reg                      NOT_DA9;
   reg                      NOT_DA8;
   reg                      NOT_DA7;
   reg                      NOT_DA6;
   reg                      NOT_DA5;
   reg                      NOT_DA4;
   reg                      NOT_DA3;
   reg                      NOT_DA2;
   reg                      NOT_DA1;
   reg                      NOT_DA0;
   reg [BITS-1:0]           NOT_DA;
   reg                      NOT_CENB;
   reg                      NOT_WENB;
   reg                      NOT_AB9;
   reg                      NOT_AB8;
   reg                      NOT_AB7;
   reg                      NOT_AB6;
   reg                      NOT_AB5;
   reg                      NOT_AB4;
   reg                      NOT_AB3;
   reg                      NOT_AB2;
   reg                      NOT_AB1;
   reg                      NOT_AB0;
   reg [ADDR_WIDTH-1:0]     NOT_AB;
   reg                      NOT_DB10;
   reg                      NOT_DB9;
   reg                      NOT_DB8;
   reg                      NOT_DB7;
   reg                      NOT_DB6;
   reg                      NOT_DB5;
   reg                      NOT_DB4;
   reg                      NOT_DB3;
   reg                      NOT_DB2;
   reg                      NOT_DB1;
   reg                      NOT_DB0;
   reg [BITS-1:0]           NOT_DB;
   reg                      NOT_EMAA2;
   reg                      NOT_EMAA1;
   reg                      NOT_EMAA0;
   reg [UPM_WIDTH-1:0]      NOT_EMAA;
   reg                      NOT_EMAB2;
   reg                      NOT_EMAB1;
   reg                      NOT_EMAB0;
   reg [UPM_WIDTH-1:0]      NOT_EMAB;

   reg                      NOT_CLKA_PER;
   reg                      NOT_CLKA_MINH;
   reg                      NOT_CLKA_MINL;
   reg                      NOT_CLKB_PER;
   reg                      NOT_CLKB_MINH;
   reg                      NOT_CLKB_MINL;

   reg                      LAST_NOT_CENA;
   reg                      LAST_NOT_WENA;
   reg [ADDR_WIDTH-1:0]     LAST_NOT_AA;
   reg [BITS-1:0]           LAST_NOT_DA;
   reg                      LAST_NOT_CENB;
   reg                      LAST_NOT_WENB;
   reg [ADDR_WIDTH-1:0]     LAST_NOT_AB;
   reg [BITS-1:0]           LAST_NOT_DB;
   reg [UPM_WIDTH-1:0]      LAST_NOT_EMAA;
   reg [UPM_WIDTH-1:0]      LAST_NOT_EMAB;

   reg                      LAST_NOT_CLKA_PER;
   reg                      LAST_NOT_CLKA_MINH;
   reg                      LAST_NOT_CLKA_MINL;
   reg                      LAST_NOT_CLKB_PER;
   reg                      LAST_NOT_CLKB_MINH;
   reg                      LAST_NOT_CLKB_MINL;
   reg                      LAST_NOT_CONTA;
   reg                      LAST_NOT_CONTB;
   wire                     contA_flag;
   wire                     contA_EMAA2eq0andEMAA1eq0andEMAA0eq0;
   wire                     contA_EMAA2eq0andEMAA1eq0andEMAA0eq1;
   wire                     contA_EMAA2eq0andEMAA1eq1andEMAA0eq0;
   wire                     contA_EMAA2eq0andEMAA1eq1andEMAA0eq1;
   wire                     contA_EMAA2eq1andEMAA1eq0andEMAA0eq0;
   wire                     contA_EMAA2eq1andEMAA1eq0andEMAA0eq1;
   wire                     contA_EMAA2eq1andEMAA1eq1andEMAA0eq0;
   wire                     contA_EMAA2eq1andEMAA1eq1andEMAA0eq1;
   wire                     contB_flag;
   wire                     contB_EMAB2eq0andEMAB1eq0andEMAB0eq0;
   wire                     contB_EMAB2eq0andEMAB1eq0andEMAB0eq1;
   wire                     contB_EMAB2eq0andEMAB1eq1andEMAB0eq0;
   wire                     contB_EMAB2eq0andEMAB1eq1andEMAB0eq1;
   wire                     contB_EMAB2eq1andEMAB1eq0andEMAB0eq0;
   wire                     contB_EMAB2eq1andEMAB1eq0andEMAB0eq1;
   wire                     contB_EMAB2eq1andEMAB1eq1andEMAB0eq0;
   wire                     contB_EMAB2eq1andEMAB1eq1andEMAB0eq1;
   wire                     cont_flag;
   wire [BITS-1:0]          _QA;
   wire [BITS-1:0]          _QB;
   wire                     _CLKA;
   wire                     _CENA;
   wire                     _WENA;
   wire [ADDR_WIDTH-1:0]    _AA;
   wire [BITS-1:0]          _DA;
   wire                     _CLKB;
   wire                     _CENB;
   wire                     _WENB;
   wire [ADDR_WIDTH-1:0]    _AB;
   wire [BITS-1:0]          _DB;
   wire [UPM_WIDTH-1:0]     _EMAA;
   wire [UPM_WIDTH-1:0]     _EMAB;

   wire                     CENA_flag;
   wire                     TCENA_flag;
   wire                     flagA;
   wire                     DA_flag;
   wire                     cyc_flagA;
   wire                     EMAA2eq0andEMAA1eq0andEMAA0eq0;
   wire                     EMAA2eq0andEMAA1eq0andEMAA0eq1;
   wire                     EMAA2eq0andEMAA1eq1andEMAA0eq0;
   wire                     EMAA2eq0andEMAA1eq1andEMAA0eq1;
   wire                     EMAA2eq1andEMAA1eq0andEMAA0eq0;
   wire                     EMAA2eq1andEMAA1eq0andEMAA0eq1;
   wire                     EMAA2eq1andEMAA1eq1andEMAA0eq0;
   wire                     EMAA2eq1andEMAA1eq1andEMAA0eq1;
   wire                     CENB_flag;
   wire                     TCENB_flag;
   wire                     flagB;
   wire                     DB_flag;
   wire                     cyc_flagB;
   wire                     EMAB2eq0andEMAB1eq0andEMAB0eq0;
   wire                     EMAB2eq0andEMAB1eq0andEMAB0eq1;
   wire                     EMAB2eq0andEMAB1eq1andEMAB0eq0;
   wire                     EMAB2eq0andEMAB1eq1andEMAB0eq1;
   wire                     EMAB2eq1andEMAB1eq0andEMAB0eq0;
   wire                     EMAB2eq1andEMAB1eq0andEMAB0eq1;
   wire                     EMAB2eq1andEMAB1eq1andEMAB0eq0;
   wire                     EMAB2eq1andEMAB1eq1andEMAB0eq1;

   reg                      LATCHED_CENA;
   reg                      LATCHED_WENA;
   reg [ADDR_WIDTH-1:0]     LATCHED_AA;
   reg [BITS-1:0]           LATCHED_DA;
   reg                      LATCHED_CENB;
   reg                      LATCHED_WENB;
   reg [ADDR_WIDTH-1:0]     LATCHED_AB;
   reg [BITS-1:0]           LATCHED_DB;
   reg [UPM_WIDTH-1:0]      LATCHED_EMAA;
   reg [UPM_WIDTH-1:0]      LATCHED_EMAB;

   reg [BITS-1:0]           QAi;
   reg [BITS-1:0]           LAST_QAi;
   reg [BITS-1:0]           QBi;
   reg [BITS-1:0]           LAST_QBi;


   reg                      LAST_CLKA;
   reg                      LAST_CLKB;

   reg [BITS+RED_COLUMNS-1:0]           last_status [(MUX*2)-1:0];


   task update_Anotifier_buses;
   begin
      NOT_AA = {
               NOT_AA9,
               NOT_AA8,
               NOT_AA7,
               NOT_AA6,
               NOT_AA5,
               NOT_AA4,
               NOT_AA3,
               NOT_AA2,
               NOT_AA1,
               NOT_AA0};
      NOT_DA = {
               NOT_DA10,
               NOT_DA9,
               NOT_DA8,
               NOT_DA7,
               NOT_DA6,
               NOT_DA5,
               NOT_DA4,
               NOT_DA3,
               NOT_DA2,
               NOT_DA1,
               NOT_DA0};
      NOT_EMAA = {
               NOT_EMAA2,
               NOT_EMAA1,
               NOT_EMAA0};
   end
   endtask

   task update_Bnotifier_buses;
   begin
      NOT_AB = {
               NOT_AB9,
               NOT_AB8,
               NOT_AB7,
               NOT_AB6,
               NOT_AB5,
               NOT_AB4,
               NOT_AB3,
               NOT_AB2,
               NOT_AB1,
               NOT_AB0};
      NOT_DB = {
               NOT_DB10,
               NOT_DB9,
               NOT_DB8,
               NOT_DB7,
               NOT_DB6,
               NOT_DB5,
               NOT_DB4,
               NOT_DB3,
               NOT_DB2,
               NOT_DB1,
               NOT_DB0};
      NOT_EMAB = {
               NOT_EMAB2,
               NOT_EMAB1,
               NOT_EMAB0};
   end
   endtask


   task mem_cycle;
      inout [BITS-1:0] 	            q;
      inout [BITS-1:0] 	            other_q;
      input 			    cen;
      input [WEN_WIDTH-1:0] 	    wen;
      input [ADDR_WIDTH-1:0]        a;
      input [BITS-1:0]              d;
      input [UPM_WIDTH-1:0]         ema;
      input                         artn;
      input                         ten;
      input                         ben;
      input                         tcen;
      input [WEN_WIDTH-1:0]         twen;
      input [ADDR_WIDTH-1:0]        ta;
      input [BITS-1:0]              td;
      input                         rren;
      input                         rra;
      input [BITS-1:0]              cren;
      input [RCA_WIDTH-1:0]         rca;
      input                         contention_flag;
      input [BITS-1:0]              other_cren;
      input                         port;  // 0 for A port, 1 for B port
      
      integer 		    mask_section ;
      integer 		    lsb ;
      integer 		    msb ;
      reg 		    CENi;
      reg [WEN_WIDTH-1:0]   WENi;
      reg [ADDR_WIDTH-1:0]  Ai;
      reg [BITS-1:0] 	    Di;
      reg 		    ValidDummyPinsi;

      begin
	 CENi = ten ? cen : tcen;
	 Ai = ten ? a : ta;
	 WENi = ten ? wen : twen;
	 Di = ten ? d : td;
	 ValidDummyPinsi = (^({ema,artn}) !== 1'bx);
	 
	 if ( (artn !== 1'b1) & (WENi !== MASK1) & (WENi !== MASK0))
           begin
              $display("ARTN is active and all bits of WEN are not active or inactive");
              $display("Setting WEN bus to x");
	      WENi = MASKX;
	   end
	 if (!valid_cren(cren))
	   begin
              $display("CREN is in an invalid state");
              $display("Setting CREN bus to x");
	      cren = WORDX;
	   end

	 for (mask_section=0;mask_section<WEN_WIDTH; mask_section=mask_section+1)
	 begin
	    lsb = (mask_section)*(WP_SIZE) ;
	    msb = BITS <= (lsb+WP_SIZE-1) ? (BITS-1) : (lsb+WP_SIZE-1) ;
	    casez({WENi[mask_section],CENi,ValidDummyPinsi})
	      3'b101: begin
		 read_mem(q,other_q,Ai,Di,rren,rra,cren,rca,
                          msb,lsb,0,contention_flag,port);
	      end
	      3'b001: begin
		 write_mem(other_q,Ai,Di,rren,rra,cren,rca,
                           msb,lsb,0,contention_flag,other_cren,port);
		 write_thru(q,Ai,Di,rren,rra,cren,rca,
                            msb,lsb,0);
	      end
	      3'b?1?: ;
              3'b10?,
	      3'b1x?: begin
		 read_mem(q,other_q,Ai,Di,rren,rra,cren,rca,
                          msb,lsb,1,contention_flag,port);
	      end
              3'b00?,
	      3'b0x?: begin
		 write_mem(other_q,Ai,Di,rren,rra,cren,rca,
                           msb,lsb,1,contention_flag,other_cren,port);
		 write_thru(q,Ai,Di,rren,rra,cren,rca,
                            msb,lsb,1);
	      end
              3'bx0?,
	      3'bxx?: begin
		 write_mem(other_q,Ai,Di,rren,rra,cren,rca,
                           msb,lsb,1,contention_flag,other_cren,port);
		 read_mem(q,other_q,Ai,Di,rren,rra,cren,rca,
                          msb,lsb,1,contention_flag,port);
	      end
	    endcase 
	 end
      end
   endtask

   task read_mem;
      inout [BITS-1:0] q;
      inout [BITS-1:0] other_q;
      input [ADDR_WIDTH-1:0] a;
      input [BITS-1:0] d;
      input rren;
      input radd;
      input [BITS-1:0] cren;
      input [RCA_WIDTH-1:0] rca;
      input msb;
      input lsb;
      input xout;
      input contention;
      input port;
      integer msb;
      integer lsb;
      reg [BITS+RED_COLUMNS-1:0] tmpdata;
      reg [BITS+RED_COLUMNS-1:0] other_status;
      reg [BITS+RED_COLUMNS-1:0] status;
      integer m;
      integer n;
      begin
	 if (rren === 1'bx)
	   begin
	      for (n=lsb; n<=msb; n=n+1) q[n] = 1'bx ;
              x_mem;
              x_rows;
	   end
	 else
	   begin
	      if (!valid_address(a,rren,radd))
		begin
		   for (n=lsb; n<=msb; n=n+1) q[n] = 1'bx ;
		   if (rren === 1'b1)
		     begin
			x_mem;
		     end
		   else if (rren === 1'b0)
		     begin
                        casez({radd,a[COL_ADDR_WIDTH]})
                           2'bxx: x_rows;
                           2'bx?: begin
                                    x_row(0,a[COL_ADDR_WIDTH]);
                                    x_row(1,a[COL_ADDR_WIDTH]);
                                  end
                           2'b?x: begin
                                    x_row(radd,0);
                                    x_row(radd,1);
                                  end
                           default:
			          x_row(radd,a[COL_ADDR_WIDTH]);
                        endcase
		     end
		end
	      else
		begin
		   if (rren === 1'b1)
		     tmpdata = mem[a];
		   else if (rren === 1'b0)
		     tmpdata = rows[{a[COL_ADDR_WIDTH],radd,a[COL_ADDR_WIDTH-1:0]}];
		   status = last_status[{port,a[COL_ADDR_WIDTH-1:0]}];
		   other_status = last_status[{!port,a[COL_ADDR_WIDTH-1:0]}];
		   for (n=lsb; n<=msb; n=n+1)
		   begin
		      if (cren[n] === 1'b1)
			begin
			   if ((other_status[n] === 1'b0) & contention)
			     begin
				q[n] = 1'bx;
			     end
			   else
			     begin
				q[n] = xout ? 1'bx : tmpdata[n];
				status[n] = 1'b1;
			     end
			end
		      else if (cren[n] === 1'b0)
			begin
                           if ((n == BITS-1) & (^(rca) !== 1'bx))
                             begin
				if ((other_status[n+rca+1] === 1'b0) & contention)
				  begin
			             q[n] = 1'bx;
				  end
				else
				  begin
			             q[n] = xout ? 1'bx : tmpdata[n+rca+1];
				     status[n+rca+1] = 1'b1;
				  end
                             end
                           else if ((n == BITS-1) & (^(rca) === 1'bx))
                             begin
				for (m=0; m<RED_COLUMNS; m=m+1)
				begin
				   status[n+m+1] = 1'b1;
				end
			        q[n] = 1'bx;
                             end
                           else
                             begin
				if ((other_status[n+1] === 1'b0) & contention)
				  begin
			             q[n] = 1'bx;
				  end
				else
				  begin
			             q[n] = xout ? 1'bx : tmpdata[n+1];
				     status[n+1] = 1'b1;
				  end
                             end
			end
		      else
			begin
                           if ((n == BITS-1) & (^(rca) !== 1'bx))
                             begin
				status[n] = 1'b1;
				status[n+rca+1] = 1'b1;
				q[n] = 1'bx;
                             end
                           else if ((n == BITS-1) & (^(rca) === 1'bx))
			     begin
				for (m=0; m<RED_COLUMNS; m=m+1)
				begin
				   status[n+m+1] = 1'b1;
				end
				status[n] = 1'b1;
				q[n] = 1'bx;
			     end 
			   else
			     begin
				q[n] = 1'bx;
				status[n] = 1'b1;
				status[n+1] = 1'b1;
			     end
			end
		   end
		   if (rren === 1'b1)
		     mem[a] = tmpdata;
		   else if (rren === 1'b0)
		     rows[{a[COL_ADDR_WIDTH],radd,a[COL_ADDR_WIDTH-1:0]}] = tmpdata;
		   last_status[{port,a[COL_ADDR_WIDTH-1:0]}] = status;
		   if (msb == BITS-1)
		     begin
			if (rren === 1'b1)
                          begin
			     for (m=0; m<RED_COLUMNS; m=m+1)
			     begin
				replace_bit_in_mem(a,BITS+m,tmpdata[BITS+m]);
                             end
                          end
			else if (rren === 1'b0)
                          begin
			     for (m=0; m<RED_COLUMNS; m=m+1)
			     begin
				replace_bit_in_rows(a,BITS+m,tmpdata[BITS+m],radd,a[COL_ADDR_WIDTH]);
                             end
                          end
			update_status(status,port);
		     end
		end
	   end
      end	      
   endtask

   task write_mem;
      inout [BITS-1:0] other_q;
      input [ADDR_WIDTH-1:0] a;
      input [BITS-1:0] d;
      input rren;
      input radd;
      input [BITS-1:0] cren;
      input [RCA_WIDTH-1:0] rca;
      input msb;
      input lsb;
      input xout;
      input contention;
      input [BITS-1:0] other_cren;
      input port;
      integer msb;
      integer lsb;
      integer m;
      integer n;
      reg [BITS+RED_COLUMNS-1:0] tmpdata;
      reg [BITS+RED_COLUMNS-1:0] other_status;
      reg [BITS+RED_COLUMNS-1:0] status;
      reg [ADDR_WIDTH-1:0] tmpaddr;
      begin
	 if (rren === 1'bx)
	   begin
	      x_mem;
	      x_rows;
	   end
	 else
	   begin
	      if (!valid_address(a,rren,radd))
		begin
		   if (rren === 1'b1)
		     begin
			x_mem;
		     end
		   else if (rren === 1'b0)
		     begin
                        casez({radd,a[COL_ADDR_WIDTH]})
                           2'bxx: x_rows;
                           2'bx?: begin
                                    x_row(0,a[COL_ADDR_WIDTH]);
                                    x_row(1,a[COL_ADDR_WIDTH]);
                                  end
                           2'b?x: begin
                                    x_row(radd,0);
                                    x_row(radd,1);
                                  end
                           default:
			          x_row(radd,a[COL_ADDR_WIDTH]);
                        endcase
		     end
		end
	      else
		begin
		   if (rren === 1'b1)
		     tmpdata = mem[a];
		   else if (rren === 1'b0)
		     tmpdata = rows[{a[COL_ADDR_WIDTH],radd,a[COL_ADDR_WIDTH-1:0]}];
		   status = last_status[{port,a[COL_ADDR_WIDTH-1:0]}];
		   other_status = last_status[{!port,a[COL_ADDR_WIDTH-1:0]}];
		   for (n=lsb; n<=msb; n=n+1)
		   begin
		      if (cren[n] === 1'b1)
			begin
			   if ((other_status[n] === 1'b0) & contention)
			     tmpdata[n] = 1'bx;
			   else if ((other_status[n] === 1'b1) & contention)
			     begin
				if (other_cren[n] === 1'b1)
				  other_q[n] = 1'bx;
				else if (other_cren[n-1] === 1'b0)
				  other_q[n-1] = 1'bx;
			     end
			   else
			     begin
				tmpdata[n] = xout ? 1'bx : d[n];
				status[n] = 1'b0;
			     end
			   if ((n < BITS-1) & (cren[n+1] === 1'b0))
                             begin
				if ((other_status[n+1] === 1'b0) & contention)
				  tmpdata[n+1] = 1'bx;
				else if ((other_status[n+1] === 1'b1) & contention)
				  begin
				     if (other_cren[n] === 1'b0)
				       other_q[n] = 1'bx;
				     else if (other_cren[n+1] === 1'b1)
				       other_q[n+1] = 1'bx;
				  end
				else
				  begin
                                     tmpdata[n+1] = xout ? 1'bx : d[n];
				     status[n+1] = 1'b0;
				  end
                             end
			   else if ((n < BITS-1) & (cren[n+1] === 1'bx))
                             begin
                                tmpdata[n+1] = 1'bx;
				status[n+1] = 1'b0;
				if ((other_status[n+1] === 1'b1) & contention)
				  if (other_cren[n] === 1'b0)
				    other_q[n] = 1'bx;
				  else if (other_cren[n+1] === 1'b1)
				    other_q[n+1] = 1'bx;
                             end
			end
		      else if (cren[n] === 1'b0)
			begin
                           if ((n == BITS-1) & (^(rca) !== 1'bx))
                             begin
				if ((other_status[n+rca+1] === 1'b0) & contention)
				  tmpdata[n+rca+1] = 1'bx;
				else if ((other_status[n+rca+1] === 1'b1) & contention)
				  begin
				     if (other_cren[n] === 1'b0)
				       other_q[n] = 1'bx;
				  end
				else
				  begin
                                     tmpdata[n+rca+1] = xout ? 1'bx : d[n];
				     status[n+rca+1] = 1'b0;
				  end
                             end
                           else if ((n == BITS-1) & (^(rca) === 1'bx))
                             begin
				for (m=0; m<RED_COLUMNS; m=m+1)
				begin
                                   tmpdata[n+m+1] = 1'bx;
				   status[n+m+1] = 1'b0;
				   if ((other_status[n+m+1] === 1'b1) & contention)
				     if (other_cren[n] === 1'b0)
				       other_q[n] = 1'bx;
				end
                             end
                           else
                             begin
				if ((other_status[n+1] === 1'b0) & contention)
				  tmpdata[n+1] = 1'bx;
				else if ((other_status[n+1] === 1'b1) & contention)
				  begin
				     if (other_cren[n] === 1'b0)
				       other_q[n] = 1'bx;
				     else if (other_cren[n+1] === 1'b1)
				       other_q[n+1] = 1'bx;
				  end
				else
				  begin
                                     tmpdata[n+1] = xout ? 1'bx : d[n];
				     status[n+1] = 1'b0;
				  end
                             end
			   if (n === 0)
                             begin
				if ((other_status[0] === 1'b0) & contention)
				  tmpdata[0] = 1'bx;
				else if ((other_status[0] === 1'b1) & contention)
				  begin
				     if (other_cren[0] === 1'b1)
				       other_q[0] = 1'bx;
				  end
				else
				  begin
                                     tmpdata[0] = xout ? 1'bx : 1'b0;
				     status[0] = 1'b0;
				  end
			     end
		        end
		      else
			begin
                           if ((n == BITS-1) & (^(rca) !== 1'bx))
                             begin
                                tmpdata[n] = 1'bx;
                                tmpdata[n+rca+1] = 1'bx;
				status[n] = 1'b0;
				status[n+rca+1] = 1'b0;
				if ((other_status[n] === 1'b1) & contention)
				  if (other_cren[n] === 1'b1)
				    other_q[n] = 1'bx;
				  else if (other_cren[n-1] === 1'b0)
				    other_q[n-1] = 1'bx;
				if ((other_status[n+rca+1] === 1'b1) & contention)
				  other_q[n] = 1'bx;
                             end
                           else if ((n == BITS-1) & (^(rca) === 1'bx))
                             begin
                                tmpdata[n] = 1'bx;
				status[n] = 1'b0;
				for (m=0; m<RED_COLUMNS; m=m+1)
				begin
                                   tmpdata[n+m+1] = 1'bx;
				   status[n+m+1] = 1'b0;
                                   if ((other_status[n+m+1] === 1'b1) & contention)
				     other_q[n] = 1'bx;
				end
				if ((other_status[n] === 1'b1) & contention)
				  if (other_cren[n] === 1'b1)
				    other_q[n] = 1'bx;
				  else if (other_cren[n-1] === 1'b0)
				    other_q[n-1] = 1'bx;
                             end
                           else
                             begin
                                tmpdata[n] = 1'bx;
                                tmpdata[n+1] = 1'bx;
				status[n] = 1'b0;
				status[n+1] = 1'b0;
				if ((other_status[n] === 1'b1) & contention)
				  if (other_cren[n] === 1'b1)
				    other_q[n] = 1'bx;
				  else if (other_cren[n-1] === 1'b0)
				    other_q[n-1] = 1'bx;
				if ((other_status[n+1] === 1'b1) & contention)
				  if (other_cren[n+1] === 1'b1)
				    other_q[n+1] = 1'bx;
				  else if (other_cren[n] === 1'b0)
				    other_q[n] = 1'bx;
                             end
			end
		   end
		   if (rren === 1'b1)
		     mem[a]=tmpdata;
		   else if (rren === 1'b0)
		     rows[{a[COL_ADDR_WIDTH],radd,a[COL_ADDR_WIDTH-1:0]}] = tmpdata;
		   last_status[{port,a[COL_ADDR_WIDTH-1:0]}] = status;
		   // copy the redundent columns to all all combinations of ymux addresses
		   if (msb == BITS-1)
		     begin
			if (rren === 1'b1)
                          begin
			     for (m=0; m<RED_COLUMNS; m=m+1)
			     begin
				replace_bit_in_mem(a,BITS+m,tmpdata[BITS+m]);
                             end
                          end
			else if (rren === 1'b0)
                          begin
			     for (m=0; m<RED_COLUMNS; m=m+1)
			     begin
				replace_bit_in_rows(a,BITS+m,tmpdata[BITS+m],radd,a[COL_ADDR_WIDTH]);
                             end
                          end
			update_status(status,port);
		     end		     
		end
	   end
      end
   endtask

   task write_thru;
      inout [BITS-1:0] q;
      input [ADDR_WIDTH-1:0] a;
      input [BITS-1:0] d;
      input rren;
      input radd;
      input [BITS-1:0] cren;
      input [RCA_WIDTH-1:0] rca;
      input msb;
      input lsb;
      input xout;
      integer msb;
      integer lsb;
      integer n;
      begin
         if (^cren !== 1'bx)
	   for (n=lsb;n<=msb;n=n+1) q[n] = xout ? 1'bx : d[n] ;
         else
	   for (n=lsb;n<=msb;n=n+1) q[n] = 1'bx ;
      end
   endtask

   task update_Alast_notifiers;
   begin
      LAST_NOT_CENA = NOT_CENA;
      LAST_NOT_WENA = NOT_WENA;
      LAST_NOT_AA = NOT_AA;
      LAST_NOT_DA = NOT_DA;
      LAST_NOT_EMAA = NOT_EMAA;
      LAST_NOT_CLKA_PER = NOT_CLKA_PER;
      LAST_NOT_CLKA_MINH = NOT_CLKA_MINH;
      LAST_NOT_CLKA_MINL = NOT_CLKA_MINL;
      LAST_NOT_CONTA = NOT_CONTA;
   end
   endtask

   task update_Blast_notifiers;
   begin
      LAST_NOT_CENB = NOT_CENB;
      LAST_NOT_WENB = NOT_WENB;
      LAST_NOT_AB = NOT_AB;
      LAST_NOT_DB = NOT_DB;
      LAST_NOT_EMAB = NOT_EMAB;
      LAST_NOT_CLKB_PER = NOT_CLKB_PER;
      LAST_NOT_CLKB_MINH = NOT_CLKB_MINH;
      LAST_NOT_CLKB_MINL = NOT_CLKB_MINL;
      LAST_NOT_CONTB = NOT_CONTB;
   end
   endtask

   task latch_Ainputs;
   begin
      LATCHED_CENA = _CENA;
      LATCHED_WENA = _WENA;
      LATCHED_AA = _AA;
      LATCHED_DA = _DA;
      LATCHED_EMAA = _EMAA;
   end
   endtask

   task latch_Binputs;
   begin
      LATCHED_CENB = _CENB;
      LATCHED_WENB = _WENB;
      LATCHED_AB = _AB;
      LATCHED_DB = _DB;
      LATCHED_EMAB = _EMAB;
   end
   endtask

   task x_Ainputs;
      integer n;
   begin
	 LATCHED_CENA = (NOT_CENA!==LAST_NOT_CENA) ? 1'bx : LATCHED_CENA ;
	 LATCHED_WENA = (NOT_WENA!==LAST_NOT_WENA) ? 1'bx : LATCHED_WENA ;
	 for (n=0; n<ADDR_WIDTH; n=n+1)
	 begin
	    LATCHED_AA[n] = (NOT_AA[n]!==LAST_NOT_AA[n]) ? 1'bx : LATCHED_AA[n] ;
	 end
	 for (n=0; n<BITS; n=n+1)
	 begin
	    LATCHED_DA[n] = (NOT_DA[n]!==LAST_NOT_DA[n]) ? 1'bx : LATCHED_DA[n] ;
	 end
	 for (n=0; n<UPM_WIDTH; n=n+1)
	 begin
	    LATCHED_EMAA[n] = (NOT_EMAA[n]!==LAST_NOT_EMAA[n]) ? 1'bx : LATCHED_EMAA[n] ;
	 end
   end
   endtask

   task x_Binputs;
      integer n;
   begin
	 LATCHED_CENB = (NOT_CENB!==LAST_NOT_CENB) ? 1'bx : LATCHED_CENB ;
	 LATCHED_WENB = (NOT_WENB!==LAST_NOT_WENB) ? 1'bx : LATCHED_WENB ;
	 for (n=0; n<ADDR_WIDTH; n=n+1)
	 begin
	    LATCHED_AB[n] = (NOT_AB[n]!==LAST_NOT_AB[n]) ? 1'bx : LATCHED_AB[n] ;
	 end
	 for (n=0; n<BITS; n=n+1)
	 begin
	    LATCHED_DB[n] = (NOT_DB[n]!==LAST_NOT_DB[n]) ? 1'bx : LATCHED_DB[n] ;
	 end
	 for (n=0; n<UPM_WIDTH; n=n+1)
	 begin
	    LATCHED_EMAB[n] = (NOT_EMAB[n]!==LAST_NOT_EMAB[n]) ? 1'bx : LATCHED_EMAB[n] ;
	 end
   end
   endtask

   task update_status;
      input [BITS+RED_COLUMNS-1:0] val;
      input port;
      reg [BITS+RED_COLUMNS-1:0] tmpdata;
      reg [COL_ADDR_WIDTH-1:0] tmpaddr;
      integer n;
      begin
	 for (n=0; n<=MUX-1; n=n+1)
	 begin
	    tmpaddr = n;
	    tmpdata = last_status[{port,tmpaddr}];
	    tmpdata[BITS+RED_COLUMNS-1:BITS] = val[BITS+RED_COLUMNS-1:BITS];
	    last_status[{port,tmpaddr}] = tmpdata;
	 end
      end
   endtask // update_status

   task clear_status;
      input port;
      reg [COL_ADDR_WIDTH:0] tmpaddr;
      integer n;
      begin
	 for (n=0; n<=MUX-1; n=n+1)
	 begin
	    tmpaddr = n;
	    tmpaddr[COL_ADDR_WIDTH] = port;
	    last_status[tmpaddr] = {WORDX,{RED_COLUMNS{1'bx}}};
	 end
      end
   endtask // clear_status

   task replace_bit_in_mem;
      input [ADDR_WIDTH-1:0] a;
      input pos;
      input data;
      integer pos;
      reg [BITS+RED_COLUMNS-1:0] tmpdata;
      reg [ADDR_WIDTH-1:0] tmpaddr;
      integer n;
      begin
	 tmpdata = mem[a];
	 tmpdata[pos] = data;
	 mem[a] = tmpdata;
	 // copy the redundent columns to all all combinations of ymux addresses
	 if (pos >= BITS)
	   begin
	      for (n=0; n<MUX; n=n+1)
	      begin
		 tmpaddr = n;
		 tmpaddr[ADDR_WIDTH-1:COL_ADDR_WIDTH] = a[ADDR_WIDTH-1:COL_ADDR_WIDTH];
		 tmpdata = mem[tmpaddr];
		 tmpdata[pos] = data;
		 mem[tmpaddr] = tmpdata;
	      end
	   end
      end
   endtask // replace_bit_in_mem


   task replace_bit_in_rows;
      input [ADDR_WIDTH-1:0] a;
      input pos;
      input data;
      input radd;
      input bank_address;
      integer pos;
      reg [BITS+RED_COLUMNS-1:0] tmpdata;
      reg [COL_ADDR_WIDTH-1:0] tmpaddr;
      integer n;
      begin
	 tmpdata = rows[{bank_address,radd,a[COL_ADDR_WIDTH-1:0]}];
	 tmpdata[pos] = data;
	 rows[{bank_address,radd,a[COL_ADDR_WIDTH-1:0]}] = tmpdata;
	 // copy the redundent columns to all all combinations of ymux addresses
	 if (pos >= BITS)
	   begin
	      for (n=0; n<MUX; n=n+1)
	      begin
		 tmpaddr = n;
		 tmpdata = rows[{bank_address,radd,tmpaddr}];
		 tmpdata[pos] = data;
		 rows[{bank_address,radd,tmpaddr}] = tmpdata;
	      end
	   end
      end
   endtask // replace_bit_in_rows

   task x_mem;
      integer n;
   begin
      for (n=0; n<WORD_DEPTH; n=n+1)
	 mem[n]={WORDX,{RED_COLUMNS{1'bx}}}; // add 2 bits for column redundancy
   end
   endtask

   task x_rows;
      integer n;
   begin
      for (n=0; n<MUX*4; n=n+1)
	 rows[n]={WORDX,{RED_COLUMNS{1'bx}}}; // add 2 bits for column redundancy
   end
   endtask

   task x_row;
      input radd;
      input bank_address;
      integer n;
      reg [COL_ADDR_WIDTH+1:0] tmpaddr;
      begin
	 for (n=0; n<MUX; n=n+1)
	 begin
	    tmpaddr = n;
	    tmpaddr[COL_ADDR_WIDTH] = radd;
            tmpaddr[COL_ADDR_WIDTH+1] = bank_address;
	    rows[tmpaddr]={WORDX,{RED_COLUMNS{1'bx}}}; // add 2 bit for column redundancy
	 end
      end
   endtask // x_rows

   task process_violationsA;
   begin
      if ((NOT_CLKA_PER!==LAST_NOT_CLKA_PER) ||
	  (NOT_CLKA_MINH!==LAST_NOT_CLKA_MINH) ||
	  (NOT_CLKA_MINL!==LAST_NOT_CLKA_MINL))
	 begin
            if (LATCHED_CENA !== 1'b1)
               begin
		  x_mem;
                  QAi = WORDX ;
	       end
	 end
      else
	 begin
	    update_Anotifier_buses;
	    x_Ainputs;
            mem_cycle(QAi,
                      QBi,
                      LATCHED_CENA,
	      	      LATCHED_WENA,
                      LATCHED_AA,
                      LATCHED_DA,
		      LATCHED_EMAA,
		      1'b1,
                      1'b1,
                      1'b1,
                      1'b1,
                      MASK1,
                      ADDR1,
                      WORD1,
                      1'b1,
                      1'b1,
                      WORD1,
                      1'b1,
                      (NOT_CONTA !== LAST_NOT_CONTA) ? 1'b1 : 1'b0,
                      WORD1,
                      0
                      );

	 end
      update_Alast_notifiers;
   end
   endtask

   task process_violationsB;
   begin
      if ((NOT_CLKB_PER!==LAST_NOT_CLKB_PER) ||
	  (NOT_CLKB_MINH!==LAST_NOT_CLKB_MINH) ||
	  (NOT_CLKB_MINL!==LAST_NOT_CLKB_MINL))
	 begin
            if (LATCHED_CENB !== 1'b1)
               begin
		  x_mem;
                  QBi = WORDX ;
	       end
	 end
      else
	 begin
	    update_Bnotifier_buses;
	    x_Binputs;
            mem_cycle(QBi,
                      QAi,
                      LATCHED_CENB,
	      	      LATCHED_WENB,
                      LATCHED_AB,
                      LATCHED_DB,
		      LATCHED_EMAB,
		      1'b1,
                      1'b1,
                      1'b1,
                      1'b1,
                      MASK1,
                      ADDR1,
                      WORD1,
                      1'b1,
                      1'b1,
                      WORD1,
                      1'b1,
                      (NOT_CONTB !== LAST_NOT_CONTB) ? 1'b1 : 1'b0,
                      WORD1,
                      1
                      );

	 end
      update_Blast_notifiers;
   end
   endtask

   function valid_address;
      input [ADDR_WIDTH-1:0] a;
      input rren;
      input radd;
   begin
      if (rren === 1'b1)
	valid_address = (^(a) !== 1'bx);
      else if (rren === 1'b0)
	valid_address = (^{radd,a[COL_ADDR_WIDTH:0]} !== 1'bx);
      else
	valid_address = 0;
   end
   endfunction

   function valid_cren;
      input [BITS-1:0] cren;
      reg [BITS-1:0] data;
      begin
         data = cren;
         while (data[0] == 1'b1)
           data = data >> 1;
	 if (~|data === 1'b1)
	   valid_cren = 1;
	 else
	   valid_cren = 0;
      end
   endfunction // valid_cren

   function is_contention;
      input [ADDR_WIDTH-1:0] aa;
      input [ADDR_WIDTH-1:0] ab;
      input [ADDR_WIDTH-1:0] taa;
      input [ADDR_WIDTH-1:0] tab;
      input rrena;
      input rrenb;
      input tena;
      input tenb;
      input rraa;
      input rrab;
      input [BITS-1:0] crena;
      input [BITS-1:0] crenb;
      input [RCA_WIDTH-1:0] rcaa;
      input [RCA_WIDTH-1:0] rcab;
      input [WEN_WIDTH-1:0] wena;
      input [WEN_WIDTH-1:0] wenb;
      input [WEN_WIDTH-1:0] twena;
      input [WEN_WIDTH-1:0] twenb;
      input cena;
      input cenb;
      input tcena;
      input tcenb;
      input artna;
      input artnb;
      reg [ADDR_WIDTH-1:0] adda;
      reg [ADDR_WIDTH-1:0] addb;
      reg [COL_ADDR_WIDTH-1:0] col_adda;
      reg [COL_ADDR_WIDTH-1:0] col_addb;
      reg [ADDR_WIDTH-1:COL_ADDR_WIDTH] row_adda;
      reg [ADDR_WIDTH-1:COL_ADDR_WIDTH] row_addb;
      reg add_colision;
      reg col_add_colision;
      reg row_add_colision;
      reg rra_colision;
      reg rca_colision;
      reg both_ports_reading;
      reg bank_address_colision;
      reg [WEN_WIDTH-1:0] wenai;
      reg [WEN_WIDTH-1:0] wenbi;
			    
      begin
	 wenai = (tena ? wena : twena);
	 wenbi = (tenb ? wenb : twenb);
	 if ( (artna !== 1'b1) & (wenai !== MASK1) & (wenai !== MASK0))
	   wenai = MASKX;
	 if ( (artnb !== 1'b1) & (wenbi !== MASK1) & (wenbi !== MASK0))
	   wenbi = MASKX;
	 if (!valid_cren(crena))
	   crena = WORDX;
	 if (!valid_cren(crenb))
	   crenb = WORDX;

	 col_adda = (tena ? aa[COL_ADDR_WIDTH-1:0] : taa[COL_ADDR_WIDTH-1:0]);
	 col_addb = (tenb ? ab[COL_ADDR_WIDTH-1:0] : tab[COL_ADDR_WIDTH-1:0]);
	 col_add_colision = (col_adda == col_addb) | (^col_adda === 1'bx) | (^col_addb === 1'bx);
	 rra_colision = (rraa == rrab) | ((rraa == rrab) === 1'bx);
	 adda = (tena ? aa : taa);
	 addb = (tenb ? ab : tab);
	 add_colision = (adda == addb) | (^adda === 1'bx) | (^addb === 1'bx);
         bank_address_colision = (adda[COL_ADDR_WIDTH] == addb[COL_ADDR_WIDTH]) | 
                                 ((adda[COL_ADDR_WIDTH] == addb[COL_ADDR_WIDTH]) === 1'bx) ;
	 
	 row_adda = (tena ? aa[ADDR_WIDTH-1:COL_ADDR_WIDTH] : taa[ADDR_WIDTH-1:COL_ADDR_WIDTH]);
	 row_addb = (tenb ? ab[ADDR_WIDTH-1:COL_ADDR_WIDTH] : tab[ADDR_WIDTH-1:COL_ADDR_WIDTH]);
	 row_add_colision = (row_adda == row_addb) | (^row_adda === 1'bx) | (^row_addb === 1'bx);
	 rca_colision = (rcaa == rcab) | (^rcaa === 1'bx) | (^rcab === 1'bx);
	 both_ports_reading = (wenai === MASK1) & 
			      (wenbi === MASK1);

	 is_contention =
			// if either rrena or rrenb are unkown the whole memory is corrupted.
			(((rrena === 1'bx) |
			  (rrenb === 1'bx) |
			  // in redundant row array
			  ((rrena !== 1'b1) & (rrenb !== 1'b1) & ((rraa === 1'bx) | (rrab === 1'bx)) &
                           bank_address_colision) |
			  ((rrena !== 1'b1) & (rrenb !== 1'b1) & col_add_colision & rra_colision &
                           bank_address_colision) |
			  // in normal array
			  ((rrena !== 1'b0) & (rrenb !== 1'b0) & add_colision) |
			  // redundant column in normal array
			  ((rrena !== 1'b0) & (rrenb !== 1'b0) & row_add_colision &
			   (crena[BITS-1] !== 1'b1) & (crenb[BITS-1] !== 1'b1) & rca_colision) |
			  // redundant column in rednundant row
			  ((rrena !== 1'b1) & (rrenb !== 1'b1) & rra_colision &
			   (crena[BITS-1] !== 1'b1) & (crenb[BITS-1] !== 1'b1) & 
			   ((wenai[WEN_WIDTH-1] !== 1'b1) | (wenbi[WEN_WIDTH-1] !== 1'b1)) & 
			   rca_colision & bank_address_colision)) &
			 !both_ports_reading &
			 ((tena ? cena : tcena) !== 1'b1) &
			 ((tenb ? cenb : tcenb) !== 1'b1)) ;
      end
   endfunction

   buf (QA[10], _QA[10]);
   buf (QA[9], _QA[9]);
   buf (QA[8], _QA[8]);
   buf (QA[7], _QA[7]);
   buf (QA[6], _QA[6]);
   buf (QA[5], _QA[5]);
   buf (QA[4], _QA[4]);
   buf (QA[3], _QA[3]);
   buf (QA[2], _QA[2]);
   buf (QA[1], _QA[1]);
   buf (QA[0], _QA[0]);
   buf (QB[10], _QB[10]);
   buf (QB[9], _QB[9]);
   buf (QB[8], _QB[8]);
   buf (QB[7], _QB[7]);
   buf (QB[6], _QB[6]);
   buf (QB[5], _QB[5]);
   buf (QB[4], _QB[4]);
   buf (QB[3], _QB[3]);
   buf (QB[2], _QB[2]);
   buf (QB[1], _QB[1]);
   buf (QB[0], _QB[0]);
   buf (_CLKA, CLKA);
   buf (_CENA, CENA);
   buf (_WENA, WENA);
   buf (_AA[9], AA[9]);
   buf (_AA[8], AA[8]);
   buf (_AA[7], AA[7]);
   buf (_AA[6], AA[6]);
   buf (_AA[5], AA[5]);
   buf (_AA[4], AA[4]);
   buf (_AA[3], AA[3]);
   buf (_AA[2], AA[2]);
   buf (_AA[1], AA[1]);
   buf (_AA[0], AA[0]);
   buf (_DA[10], DA[10]);
   buf (_DA[9], DA[9]);
   buf (_DA[8], DA[8]);
   buf (_DA[7], DA[7]);
   buf (_DA[6], DA[6]);
   buf (_DA[5], DA[5]);
   buf (_DA[4], DA[4]);
   buf (_DA[3], DA[3]);
   buf (_DA[2], DA[2]);
   buf (_DA[1], DA[1]);
   buf (_DA[0], DA[0]);
   buf (_CLKB, CLKB);
   buf (_CENB, CENB);
   buf (_WENB, WENB);
   buf (_AB[9], AB[9]);
   buf (_AB[8], AB[8]);
   buf (_AB[7], AB[7]);
   buf (_AB[6], AB[6]);
   buf (_AB[5], AB[5]);
   buf (_AB[4], AB[4]);
   buf (_AB[3], AB[3]);
   buf (_AB[2], AB[2]);
   buf (_AB[1], AB[1]);
   buf (_AB[0], AB[0]);
   buf (_DB[10], DB[10]);
   buf (_DB[9], DB[9]);
   buf (_DB[8], DB[8]);
   buf (_DB[7], DB[7]);
   buf (_DB[6], DB[6]);
   buf (_DB[5], DB[5]);
   buf (_DB[4], DB[4]);
   buf (_DB[3], DB[3]);
   buf (_DB[2], DB[2]);
   buf (_DB[1], DB[1]);
   buf (_DB[0], DB[0]);
   buf (_EMAA[2], EMAA[2]);
   buf (_EMAA[1], EMAA[1]);
   buf (_EMAA[0], EMAA[0]);
   buf (_EMAB[2], EMAB[2]);
   buf (_EMAB[1], EMAB[1]);
   buf (_EMAB[0], EMAB[0]);

   assign _QA = QAi ;
   assign CENA_flag = 1'b1;          // use this for cen
   assign flagA = !_CENA;             // use this for normal mission-mode inputs
   assign DA_flag = !(_CENA || _WENA);
   assign cyc_flagA = !_CENA;         // use this for non-muxed inputs.
   assign EMAA2eq0andEMAA1eq0andEMAA0eq0 = !_EMAA[2] && !_EMAA[1] && !_EMAA[0];
   assign EMAA2eq0andEMAA1eq0andEMAA0eq1 = !_EMAA[2] && !_EMAA[1] && _EMAA[0];
   assign EMAA2eq0andEMAA1eq1andEMAA0eq0 = !_EMAA[2] && _EMAA[1] && !_EMAA[0];
   assign EMAA2eq0andEMAA1eq1andEMAA0eq1 = !_EMAA[2] && _EMAA[1] && _EMAA[0];
   assign EMAA2eq1andEMAA1eq0andEMAA0eq0 = _EMAA[2] && !_EMAA[1] && !_EMAA[0];
   assign EMAA2eq1andEMAA1eq0andEMAA0eq1 = _EMAA[2] && !_EMAA[1] && _EMAA[0];
   assign EMAA2eq1andEMAA1eq1andEMAA0eq0 = _EMAA[2] && _EMAA[1] && !_EMAA[0];
   assign EMAA2eq1andEMAA1eq1andEMAA0eq1 = _EMAA[2] && _EMAA[1] && _EMAA[0];
   assign contA_EMAA2eq0andEMAA1eq0andEMAA0eq0 = EMAA2eq0andEMAA1eq0andEMAA0eq0 && contA_flag;
   assign contA_EMAA2eq0andEMAA1eq0andEMAA0eq1 = EMAA2eq0andEMAA1eq0andEMAA0eq1 && contA_flag;
   assign contA_EMAA2eq0andEMAA1eq1andEMAA0eq0 = EMAA2eq0andEMAA1eq1andEMAA0eq0 && contA_flag;
   assign contA_EMAA2eq0andEMAA1eq1andEMAA0eq1 = EMAA2eq0andEMAA1eq1andEMAA0eq1 && contA_flag;
   assign contA_EMAA2eq1andEMAA1eq0andEMAA0eq0 = EMAA2eq1andEMAA1eq0andEMAA0eq0 && contA_flag;
   assign contA_EMAA2eq1andEMAA1eq0andEMAA0eq1 = EMAA2eq1andEMAA1eq0andEMAA0eq1 && contA_flag;
   assign contA_EMAA2eq1andEMAA1eq1andEMAA0eq0 = EMAA2eq1andEMAA1eq1andEMAA0eq0 && contA_flag;
   assign contA_EMAA2eq1andEMAA1eq1andEMAA0eq1 = EMAA2eq1andEMAA1eq1andEMAA0eq1 && contA_flag;
   assign _QB = QBi ;
   assign CENB_flag = 1'b1;          // use this for cen
   assign flagB = !_CENB;             // use this for normal mission-mode inputs
   assign DB_flag = !(_CENB || _WENB);
   assign cyc_flagB = !_CENB;         // use this for non-muxed inputs.
   assign EMAB2eq0andEMAB1eq0andEMAB0eq0 = !_EMAB[2] && !_EMAB[1] && !_EMAB[0];
   assign EMAB2eq0andEMAB1eq0andEMAB0eq1 = !_EMAB[2] && !_EMAB[1] && _EMAB[0];
   assign EMAB2eq0andEMAB1eq1andEMAB0eq0 = !_EMAB[2] && _EMAB[1] && !_EMAB[0];
   assign EMAB2eq0andEMAB1eq1andEMAB0eq1 = !_EMAB[2] && _EMAB[1] && _EMAB[0];
   assign EMAB2eq1andEMAB1eq0andEMAB0eq0 = _EMAB[2] && !_EMAB[1] && !_EMAB[0];
   assign EMAB2eq1andEMAB1eq0andEMAB0eq1 = _EMAB[2] && !_EMAB[1] && _EMAB[0];
   assign EMAB2eq1andEMAB1eq1andEMAB0eq0 = _EMAB[2] && _EMAB[1] && !_EMAB[0];
   assign EMAB2eq1andEMAB1eq1andEMAB0eq1 = _EMAB[2] && _EMAB[1] && _EMAB[0];
   assign contB_EMAB2eq0andEMAB1eq0andEMAB0eq0 = EMAB2eq0andEMAB1eq0andEMAB0eq0 && contB_flag;
   assign contB_EMAB2eq0andEMAB1eq0andEMAB0eq1 = EMAB2eq0andEMAB1eq0andEMAB0eq1 && contB_flag;
   assign contB_EMAB2eq0andEMAB1eq1andEMAB0eq0 = EMAB2eq0andEMAB1eq1andEMAB0eq0 && contB_flag;
   assign contB_EMAB2eq0andEMAB1eq1andEMAB0eq1 = EMAB2eq0andEMAB1eq1andEMAB0eq1 && contB_flag;
   assign contB_EMAB2eq1andEMAB1eq0andEMAB0eq0 = EMAB2eq1andEMAB1eq0andEMAB0eq0 && contB_flag;
   assign contB_EMAB2eq1andEMAB1eq0andEMAB0eq1 = EMAB2eq1andEMAB1eq0andEMAB0eq1 && contB_flag;
   assign contB_EMAB2eq1andEMAB1eq1andEMAB0eq0 = EMAB2eq1andEMAB1eq1andEMAB0eq0 && contB_flag;
   assign contB_EMAB2eq1andEMAB1eq1andEMAB0eq1 = EMAB2eq1andEMAB1eq1andEMAB0eq1 && contB_flag;

   assign cont_flag = is_contention(_AA,
                                    _AB,
                                    ADDR1,
                                    ADDR1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    WORD1,
                                    WORD1,
                                    1'b1,
                                    1'b1,
	      	                    _WENA,
	      	                    _WENB,
                                    MASK1,
                                    MASK1,
                                    _CENA,
                                    _CENB,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1);


   assign contB_flag = is_contention(_AA,
                                    LATCHED_AB,
                                    ADDR1,
                                    ADDR1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    WORD1,
                                    WORD1,
                                    1'b1,
                                    1'b1,
	      	                    _WENA,
	      	                    LATCHED_WENB,
                                    MASK1,
                                    MASK1,
                                    _CENA,
                                    LATCHED_CENB,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1);

   assign contA_flag = is_contention(LATCHED_AA,
                                    _AB,
                                    ADDR1,
                                    ADDR1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    WORD1,
                                    WORD1,
                                    1'b1,
                                    1'b1,
	      	                    LATCHED_WENA,
	      	                    _WENB,
                                    MASK1,
                                    MASK1,
                                    LATCHED_CENA,
                                    _CENB,
                                    1'b1,
                                    1'b1,
                                    1'b1,
                                    1'b1);

   always @(
	    NOT_CENA or
	    NOT_WENA or
	    NOT_AA9 or
	    NOT_AA8 or
	    NOT_AA7 or
	    NOT_AA6 or
	    NOT_AA5 or
	    NOT_AA4 or
	    NOT_AA3 or
	    NOT_AA2 or
	    NOT_AA1 or
	    NOT_AA0 or
	    NOT_DA10 or
	    NOT_DA9 or
	    NOT_DA8 or
	    NOT_DA7 or
	    NOT_DA6 or
	    NOT_DA5 or
	    NOT_DA4 or
	    NOT_DA3 or
	    NOT_DA2 or
	    NOT_DA1 or
	    NOT_DA0 or
	    NOT_CENB or
	    NOT_WENB or
	    NOT_AB9 or
	    NOT_AB8 or
	    NOT_AB7 or
	    NOT_AB6 or
	    NOT_AB5 or
	    NOT_AB4 or
	    NOT_AB3 or
	    NOT_AB2 or
	    NOT_AB1 or
	    NOT_AB0 or
	    NOT_DB10 or
	    NOT_DB9 or
	    NOT_DB8 or
	    NOT_DB7 or
	    NOT_DB6 or
	    NOT_DB5 or
	    NOT_DB4 or
	    NOT_DB3 or
	    NOT_DB2 or
	    NOT_DB1 or
	    NOT_DB0 or
	    NOT_EMAA2 or
	    NOT_EMAA1 or
	    NOT_EMAA0 or
	    NOT_EMAB2 or
	    NOT_EMAB1 or
	    NOT_EMAB0 or
            NOT_CONTA or
	    NOT_CLKA_PER or
	    NOT_CLKA_MINH or
	    NOT_CLKA_MINL
	    )
      begin
         process_violationsA;
      end
   always @(
	    NOT_CENA or
	    NOT_WENA or
	    NOT_AA9 or
	    NOT_AA8 or
	    NOT_AA7 or
	    NOT_AA6 or
	    NOT_AA5 or
	    NOT_AA4 or
	    NOT_AA3 or
	    NOT_AA2 or
	    NOT_AA1 or
	    NOT_AA0 or
	    NOT_DA10 or
	    NOT_DA9 or
	    NOT_DA8 or
	    NOT_DA7 or
	    NOT_DA6 or
	    NOT_DA5 or
	    NOT_DA4 or
	    NOT_DA3 or
	    NOT_DA2 or
	    NOT_DA1 or
	    NOT_DA0 or
	    NOT_CENB or
	    NOT_WENB or
	    NOT_AB9 or
	    NOT_AB8 or
	    NOT_AB7 or
	    NOT_AB6 or
	    NOT_AB5 or
	    NOT_AB4 or
	    NOT_AB3 or
	    NOT_AB2 or
	    NOT_AB1 or
	    NOT_AB0 or
	    NOT_DB10 or
	    NOT_DB9 or
	    NOT_DB8 or
	    NOT_DB7 or
	    NOT_DB6 or
	    NOT_DB5 or
	    NOT_DB4 or
	    NOT_DB3 or
	    NOT_DB2 or
	    NOT_DB1 or
	    NOT_DB0 or
	    NOT_EMAA2 or
	    NOT_EMAA1 or
	    NOT_EMAA0 or
	    NOT_EMAB2 or
	    NOT_EMAB1 or
	    NOT_EMAB0 or
            NOT_CONTB or
	    NOT_CLKB_PER or
	    NOT_CLKB_MINH or
	    NOT_CLKB_MINL
	    )
      begin
         process_violationsB;
      end

   always @( _CLKA )
      begin
         casez({LAST_CLKA,_CLKA})
	   2'b01: begin
	      latch_Ainputs;
              clear_status(0);
              mem_cycle(QAi,
                        QBi,
                        LATCHED_CENA,
	      	        LATCHED_WENA,
                        LATCHED_AA,
                        LATCHED_DA,
		        LATCHED_EMAA,
		        1'b1,
                        1'b1,
                        1'b1,
                        1'b1,
                        MASK1,
                        ADDR1,
                        WORD1,
                        1'b1,
                        1'b1,
                        WORD1,
                        1'b1,
                        1'b0,
                        WORD1,
                        0
                       );
	   end

	   2'b10,
	   2'bx?,
	   2'b00,
	   2'b11: ;

	   2'b?x: begin
	      x_mem;
              QAi = WORDX ;
	   end
	   
	 endcase
	 LAST_CLKA = _CLKA;
      end
   always @( _CLKB )
      begin
         casez({LAST_CLKB,_CLKB})
	   2'b01: begin
	      latch_Binputs;
              clear_status(1);
              mem_cycle(QBi,
                        QAi,
                        LATCHED_CENB,
	      	        LATCHED_WENB,
                        LATCHED_AB,
                        LATCHED_DB,
		        LATCHED_EMAB,
		        1'b1,
                        1'b1,
                        1'b1,
                        1'b1,
                        MASK1,
                        ADDR1,
                        WORD1,
                        1'b1,
                        1'b1,
                        WORD1,
                        1'b1,
                        1'b0,
                        WORD1,
                        1
                       );
	   end

	   2'b10,
	   2'bx?,
	   2'b00,
	   2'b11: ;

	   2'b?x: begin
	      x_mem;
              QBi = WORDX ;
	   end
	   
	 endcase
	 LAST_CLKB = _CLKB;
      end


   specify
      $setuphold(posedge CLKA &&& CENA_flag, posedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA &&& CENA_flag, negedge CENA, 1.000, 0.500, NOT_CENA);
      $setuphold(posedge CLKA &&& flagA, posedge WENA, 1.000, 0.500, NOT_WENA);
      $setuphold(posedge CLKA &&& flagA, negedge WENA, 1.000, 0.500, NOT_WENA);
      $setuphold(posedge CLKA &&& flagA, posedge AA[9], 1.000, 0.500, NOT_AA9);
      $setuphold(posedge CLKA &&& flagA, negedge AA[9], 1.000, 0.500, NOT_AA9);
      $setuphold(posedge CLKA &&& flagA, posedge AA[8], 1.000, 0.500, NOT_AA8);
      $setuphold(posedge CLKA &&& flagA, negedge AA[8], 1.000, 0.500, NOT_AA8);
      $setuphold(posedge CLKA &&& flagA, posedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& flagA, negedge AA[7], 1.000, 0.500, NOT_AA7);
      $setuphold(posedge CLKA &&& flagA, posedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& flagA, negedge AA[6], 1.000, 0.500, NOT_AA6);
      $setuphold(posedge CLKA &&& flagA, posedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& flagA, negedge AA[5], 1.000, 0.500, NOT_AA5);
      $setuphold(posedge CLKA &&& flagA, posedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& flagA, negedge AA[4], 1.000, 0.500, NOT_AA4);
      $setuphold(posedge CLKA &&& flagA, posedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& flagA, negedge AA[3], 1.000, 0.500, NOT_AA3);
      $setuphold(posedge CLKA &&& flagA, posedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& flagA, negedge AA[2], 1.000, 0.500, NOT_AA2);
      $setuphold(posedge CLKA &&& flagA, posedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& flagA, negedge AA[1], 1.000, 0.500, NOT_AA1);
      $setuphold(posedge CLKA &&& flagA, posedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& flagA, negedge AA[0], 1.000, 0.500, NOT_AA0);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[10], 1.000, 0.500, NOT_DA10);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[9], 1.000, 0.500, NOT_DA9);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[8], 1.000, 0.500, NOT_DA8);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[7], 1.000, 0.500, NOT_DA7);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[6], 1.000, 0.500, NOT_DA6);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[5], 1.000, 0.500, NOT_DA5);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[4], 1.000, 0.500, NOT_DA4);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[3], 1.000, 0.500, NOT_DA3);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[2], 1.000, 0.500, NOT_DA2);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[1], 1.000, 0.500, NOT_DA1);
      $setuphold(posedge CLKA &&& DA_flag, posedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& DA_flag, negedge DA[0], 1.000, 0.500, NOT_DA0);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[2], 1.000, 0.500, NOT_EMAA2);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[2], 1.000, 0.500, NOT_EMAA2);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[1], 1.000, 0.500, NOT_EMAA1);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[1], 1.000, 0.500, NOT_EMAA1);
      $setuphold(posedge CLKA &&& cyc_flagA, posedge EMAA[0], 1.000, 0.500, NOT_EMAA0);
      $setuphold(posedge CLKA &&& cyc_flagA, negedge EMAA[0], 1.000, 0.500, NOT_EMAA0);

      $setuphold(posedge CLKB &&& CENB_flag, posedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB &&& CENB_flag, negedge CENB, 1.000, 0.500, NOT_CENB);
      $setuphold(posedge CLKB &&& flagB, posedge WENB, 1.000, 0.500, NOT_WENB);
      $setuphold(posedge CLKB &&& flagB, negedge WENB, 1.000, 0.500, NOT_WENB);
      $setuphold(posedge CLKB &&& flagB, posedge AB[9], 1.000, 0.500, NOT_AB9);
      $setuphold(posedge CLKB &&& flagB, negedge AB[9], 1.000, 0.500, NOT_AB9);
      $setuphold(posedge CLKB &&& flagB, posedge AB[8], 1.000, 0.500, NOT_AB8);
      $setuphold(posedge CLKB &&& flagB, negedge AB[8], 1.000, 0.500, NOT_AB8);
      $setuphold(posedge CLKB &&& flagB, posedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& flagB, negedge AB[7], 1.000, 0.500, NOT_AB7);
      $setuphold(posedge CLKB &&& flagB, posedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& flagB, negedge AB[6], 1.000, 0.500, NOT_AB6);
      $setuphold(posedge CLKB &&& flagB, posedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& flagB, negedge AB[5], 1.000, 0.500, NOT_AB5);
      $setuphold(posedge CLKB &&& flagB, posedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& flagB, negedge AB[4], 1.000, 0.500, NOT_AB4);
      $setuphold(posedge CLKB &&& flagB, posedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& flagB, negedge AB[3], 1.000, 0.500, NOT_AB3);
      $setuphold(posedge CLKB &&& flagB, posedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& flagB, negedge AB[2], 1.000, 0.500, NOT_AB2);
      $setuphold(posedge CLKB &&& flagB, posedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& flagB, negedge AB[1], 1.000, 0.500, NOT_AB1);
      $setuphold(posedge CLKB &&& flagB, posedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& flagB, negedge AB[0], 1.000, 0.500, NOT_AB0);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[10], 1.000, 0.500, NOT_DB10);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[9], 1.000, 0.500, NOT_DB9);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[8], 1.000, 0.500, NOT_DB8);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[7], 1.000, 0.500, NOT_DB7);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[6], 1.000, 0.500, NOT_DB6);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[5], 1.000, 0.500, NOT_DB5);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[4], 1.000, 0.500, NOT_DB4);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[3], 1.000, 0.500, NOT_DB3);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[2], 1.000, 0.500, NOT_DB2);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[1], 1.000, 0.500, NOT_DB1);
      $setuphold(posedge CLKB &&& DB_flag, posedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& DB_flag, negedge DB[0], 1.000, 0.500, NOT_DB0);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[2], 1.000, 0.500, NOT_EMAB2);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[2], 1.000, 0.500, NOT_EMAB2);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[1], 1.000, 0.500, NOT_EMAB1);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[1], 1.000, 0.500, NOT_EMAB1);
      $setuphold(posedge CLKB &&& cyc_flagB, posedge EMAB[0], 1.000, 0.500, NOT_EMAB0);
      $setuphold(posedge CLKB &&& cyc_flagB, negedge EMAB[0], 1.000, 0.500, NOT_EMAB0);

      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq0andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq0andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq1andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq0andEMAA1eq1andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq0andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq0andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq1andEMAA0eq0, 3.000, NOT_CONTB);
      $setup(posedge CLKA, posedge CLKB &&& contA_EMAA2eq1andEMAA1eq1andEMAA0eq1, 3.000, NOT_CONTB);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq0andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq0andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq1andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq0andEMAB1eq1andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq0andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq0andEMAB0eq1, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq1andEMAB0eq0, 3.000, NOT_CONTA);
      $setup(posedge CLKB, posedge CLKA &&& contB_EMAB2eq1andEMAB1eq1andEMAB0eq1, 3.000, NOT_CONTA);
      $hold(posedge CLKA, posedge CLKB &&& cont_flag, 0.001, NOT_CONTB);

      $width(posedge CLKA, 1.000, 0, NOT_CLKA_MINH);
      $width(negedge CLKA, 1.000, 0, NOT_CLKA_MINL);
`ifdef NO_SDTC
      $period(posedge CLKA, 3.000, NOT_CLKA_PER);
`else
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq0andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq0andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq1andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq0andEMAA1eq1andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq0andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq0andEMAA0eq1, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq1andEMAA0eq0, 3.000, NOT_CLKA_PER);
      $period(posedge CLKA &&& EMAA2eq1andEMAA1eq1andEMAA0eq1, 3.000, NOT_CLKA_PER);
`endif

      $width(posedge CLKB, 1.000, 0, NOT_CLKB_MINH);
      $width(negedge CLKB, 1.000, 0, NOT_CLKB_MINL);
`ifdef NO_SDTC
      $period(posedge CLKB, 3.000, NOT_CLKB_PER);
`else
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq0andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq0andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq1andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq0andEMAB1eq1andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq0andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq0andEMAB0eq1, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq1andEMAB0eq0, 3.000, NOT_CLKB_PER);
      $period(posedge CLKB &&& EMAB2eq1andEMAB1eq1andEMAB0eq1, 3.000, NOT_CLKB_PER);
`endif

      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[10])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[9])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[8])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[7])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[6])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[5])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[4])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[3])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[2])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[1])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b0) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b0))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b0) && (EMAA[0] == 1'b1))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b0))
	(CLKA => QA[0])=(1.000, 1.000);
      if ((EMAA[2] == 1'b1) && (EMAA[1] == 1'b1) && (EMAA[0] == 1'b1))
	(CLKA => QA[0])=(1.000, 1.000);

      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[10])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[9])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[8])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[7])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[6])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[5])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[4])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[3])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[2])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[1])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b0) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b0))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b0) && (EMAB[0] == 1'b1))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b0))
	(CLKB => QB[0])=(1.000, 1.000);
      if ((EMAB[2] == 1'b1) && (EMAB[1] == 1'b1) && (EMAB[0] == 1'b1))
	(CLKB => QB[0])=(1.000, 1.000);

   endspecify

endmodule
`endcelldefine
