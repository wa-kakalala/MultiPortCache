`include "./mpcache.svh"

module mpcache(
    input  logic                     clk_in                     ,
    input  logic                     rst_n_in                   ,
    
    input  logic [`IN_PORT_NUM-1:0 ] wr_eop                     ,
    input  logic [`IN_PORT_NUM-1:0 ] wr_sop                     ,
    input  logic [`IN_PORT_NUM-1:0 ] wr_vld                     ,
    input  logic [`DATA_WIDTH-1:0  ] wr_data [`IN_PORT_NUM-1:0] ,
    
    input  logic [`IN_PORT_NUM-1:0 ] ready                      ,

    output logic [`IN_PORT_NUM-1:0 ] rd_eop                     ,
    output logic [`IN_PORT_NUM-1:0 ] rd_sop                     ,
    output logic [`IN_PORT_NUM-1:0 ] rd_vld                     ,
    output logic [`DATA_WIDTH-1:0  ] rd_data [`IN_PORT_NUM-1:0] ,

    output logic [`IN_PORT_NUM-1:0 ] full                       ,
    output logic                     almost_full          
);

/**************** input_channel to pqm begin ****************/
logic                               inch2pqm_sop_nc            [`IN_PORT_NUM-1:0];
logic [`DA_WIDTH-1:0]               inch2pqm_da                [`IN_PORT_NUM-1:0];
logic [`PRORITY_WIDTH-4-1:0]        inch2pqm_prior             [`IN_PORT_NUM-1:0];
logic                               inch2pqm_hdr_vld           [`IN_PORT_NUM-1:0];
logic                               inch2pqm_blk_addr_vld      [`IN_PORT_NUM-1:0];
logic [`BLK_ADDR_WIDTH-1:0]         inch2pqm_blk_addr          [`IN_PORT_NUM-1:0];
logic                               inch2pqm_eop               [`IN_PORT_NUM-1:0];
/**************** input_channel to pqm  end  ****************/

/**************** input_channel to write sram begin ****************/
logic [`BLK_ADDR_WIDTH-1:0]         inch2wsram_sram_addr       [`IN_PORT_NUM-1:0];
logic                               inch2wsram_w_vld           [`IN_PORT_NUM-1:0];
logic [`DATA_WIDTH-1:0    ]         inch2wsram_sram_data       [`IN_PORT_NUM-1:0];
/**************** input_channel to write sram  end  ****************/

/**************** input_channel to mem_manager begin ****************/
logic                               inch2mem_addr_req          [`IN_PORT_NUM-1:0];
/**************** input_channel to mem_manager  end  ****************/

/**************** mem_manager to input_channel begin ****************/
logic                               mem2inch_ocp_rsp_nc        [`IN_PORT_NUM-1:0];                          
logic [`BLK_ADDR_WIDTH-4-1:0]       mem2inch_ocp_block_addr    [`IN_PORT_NUM-1:0];
logic                               mem2inch_ocp_vld           [`IN_PORT_NUM-1:0];             
logic                               mem2inch_full_nc           [`IN_PORT_NUM-1:0];           
logic                               mem2inch_almost_full_nc    [`IN_PORT_NUM-1:0];           
logic                               mem2inch_empty_nc          [`IN_PORT_NUM-1:0];           
/**************** mem_manager to input_channel  end  ****************/

/**************** pqm to que_arbitrator begin ****************/
logic [`OUT_PORT_NUM-1:0]                    pqm2qarb_pending  [`IN_PORT_NUM-1:0];                          
logic [`PRORITY_WIDTH-1:0]pqm2qarb_out_prior[`IN_PORT_NUM-1:0][`OUT_PORT_NUM-1:0];
/**************** pqm to que_arbitrator  end  ****************/

/**************** pqm to input_channel begin ****************/
logic                               pqm2inch_addr_in_rdy_nc    [`IN_PORT_NUM-1:0];                          
/**************** pqm to input_channel  end  ****************/

/**************** pqm to input_channel begin ****************/
logic [`BLK_ADDR_WIDTH-4-1:0]       pqm2mem_addr_rls           [`IN_PORT_NUM-1:0];
logic                               pqm2mem_addr_rls_vld       [`IN_PORT_NUM-1:0];                         
/**************** pqm to input_channel  end  ****************/

/**************** pqm to output_ctrl begin ****************/
logic [`BLK_ADDR_WIDTH-4-1:0]       pqm2outctl_addr_out        [`IN_PORT_NUM-1:0];
logic                               pqm2outctl_addr_out_vld    [`IN_PORT_NUM-1:0];    
logic                               pqm2outctl_frame_last_nc   [`IN_PORT_NUM-1:0];   
/**************** pqm to output_ctrl  end  ****************/
 
/**************** que_arbitrator to port_req begin ****************/
logic [$clog2(`IN_PORT_NUM)-1:0]    qarb2preq_port             [`IN_PORT_NUM-1:0];   
logic                               qarb2preq_port_vld         [`IN_PORT_NUM-1:0];   
logic                               qarb2preq_empty            [`IN_PORT_NUM-1:0];   
/**************** que_arbitrator to port_req  end  ****************/

/**************** port_req to que_arbitrator begin ****************/
logic                               preq2qarb_update           [`IN_PORT_NUM-1:0];  
logic [$clog2(`IN_PORT_NUM)-1:0]    preq2qarb_clr_port         [`IN_PORT_NUM-1:0];  
logic                               preq2qarb_clr_vld          [`IN_PORT_NUM-1:0];  
/**************** port_req to que_arbitrator  end  ****************/

/**************** port_req to output_ctrl begin ****************/
logic                               preq2outctl_port_vld       [`IN_PORT_NUM-1:0];  
logic [$clog2(`IN_PORT_NUM)-1:0]    preq2outctl_port           [`IN_PORT_NUM-1:0];  
/**************** port_req to output_ctrl  end  ****************/

/**************** port_req to port_arbitrator begin ****************/
logic [`OUT_PORT_NUM-1:0]           preq2parb_req              [`IN_PORT_NUM-1:0];  
/**************** port_req to port_arbitrator  end  ****************/

/**************** output_ctrl to pqm begin ****************/
logic                               outctl2pqm_port_vld        [`IN_PORT_NUM-1:0];  
logic [$clog2(`IN_PORT_NUM)-1:0]    outctl2pqm_port            [`IN_PORT_NUM-1:0];  
logic                               outctl2pqm_addr_rdy        [`IN_PORT_NUM-1:0];    // need to fix
/**************** output_ctrl to pqm  end  ****************/

/**************** output_ctrl to read_sram begin ****************/
logic [`BLK_ADDR_WIDTH-4-1:0 ]      outctl2rsram_blk_addr      [`IN_PORT_NUM-1:0];  
logic                               outctl2rsram_blk_addr_vld  [`IN_PORT_NUM-1:0];  
logic                               outctl2rsram_last_blk_vld  [`IN_PORT_NUM-1:0];  
logic [`BLK_R_TIMES_WIDTH-1:0    ]  outctl2rsram_last_r_times  [`IN_PORT_NUM-1:0];   
/**************** output_ctrl to read_sram  end  ****************/

/**************** port_arbitrator to port_req begin ****************/
logic                               parb2preq_port_ready       [`IN_PORT_NUM-1:0];
logic [`OUT_PORT_NUM-1:0]           parb2preq_resp             [`IN_PORT_NUM-1:0];
logic [`OUT_PORT_NUM-1:0]           parb2preq_nresp            [`IN_PORT_NUM-1:0];    
/**************** port_arbitrator to port_req begin ****************/

/**************** read sram to multi sram begin ****************/
logic                               rsram2msram_rd_en          [`IN_PORT_NUM-1:0];
logic [`BLK_ADDR_WIDTH-1:0]         rsram2msram_sram_rd_addr   [`IN_PORT_NUM-1:0];
/**************** read sram to multi sram begin ****************/

/****************   multi sram to read sram begin ****************/
logic [`DATA_WIDTH-1:0]             msram2rsram_d_b            [`IN_PORT_NUM-1:0];
/****************   multi sram to read sram  end  ****************/

/****************   read sram to output_ctrl begin ****************/
logic [`DATA_WIDTH-1:0]             rsram2outctl_pkt_hdr       [`IN_PORT_NUM-1:0];
logic                               rsram2outctl_pkt_hdr_vld   [`IN_PORT_NUM-1:0];
/****************   read sram to output_ctrl  end  ****************/    

/****************   read sram to pqm&output_ctrl begin ****************/
logic                               rsram2pqmoutctl_read_finish[`IN_PORT_NUM-1:0];
/****************   read sram to pqm&output_ctrl  end  ****************/  

/****************   read sram to port begin ****************/
logic                               rsram2port_rd_eop          [`IN_PORT_NUM-1:0];
logic                               rsram2port_rd_sop          [`IN_PORT_NUM-1:0];
logic                               rsram2port_rd_vld          [`IN_PORT_NUM-1:0];
logic [`DATA_WIDTH-1:0  ]           rsram2port_rd_data         [`IN_PORT_NUM-1:0];
/****************   read sram to port  end  ****************/

/****************   port_arbitrator to mux begin ****************/
logic [$clog2(`IN_PORT_NUM)-1:0]    parb2mux_sel               [`IN_PORT_NUM-1:0];
logic [`IN_PORT_NUM-1:0]            parb2mux_en                                  ;
/****************   port_arbitrator to mux  end  ****************/

/****************   channel_req to channel_arb begin ****************/
logic [`IN_PORT_NUM-1:0]            channreq2channarb_req      [`IN_PORT_NUM-1:0];
logic [`DATA_WIDTH-1:0]             channreq2channarb_data     [`IN_PORT_NUM-1:0];
logic [`IN_PORT_NUM-1:0]            channreq2channarb_sop                        ; 
logic [`IN_PORT_NUM-1:0]            channreq2channarb_dvld                       ;
logic [`IN_PORT_NUM-1:0]            channreq2channarb_eop                        ;   
logic [`IN_PORT_NUM-1:0]            channreq2channfifo_rd                        ;
/****************   channel_req to channel_arb  end  ****************/

/****************   channel fifo to channel_req begin ****************/
logic [`DATA_WIDTH-1:0]             chanfifo2channreq_data     [`IN_PORT_NUM-1:0];
logic                               chanfifo2channreq_empty    [`IN_PORT_NUM-1:0];
/****************   channel fifo to channel_req  end  ****************/

/****************   channel_arb to channel_req begin ****************/
logic [`IN_PORT_NUM-1:0]            channarb2channreq_resp     [`IN_PORT_NUM-1:0];
logic [`IN_PORT_NUM-1:0]            channarb2channreq_nresp    [`IN_PORT_NUM-1:0];
logic [`IN_PORT_NUM-1:0]            channarb2channreq_ready                      ;
/****************   channel_arb to channel_req  end  ****************/

/****************   channel_arb to mux16to1len begin ****************/
logic [`IN_PORT_NUM-1:0]            channarb2mux16to1en_en                       ;
logic [$clog2(`IN_PORT_NUM)-1:0]    channarb2mux16to1en_sel    [`IN_PORT_NUM-1:0];
/****************   channel_arb to mux16to1len  end  ****************/

/****************   mux16to1len to inputchann begin ****************/
logic [`IN_PORT_NUM-1:0]            mux16to1en2inputchann_sop                    ; 
logic [`DATA_WIDTH-1:0]             mux16to1en2inputchann_data [`IN_PORT_NUM-1:0];
logic [`IN_PORT_NUM-1:0]            mux16to1en2inputchann_dvld                   ;
logic [`IN_PORT_NUM-1:0]            mux16to1en2inputchann_eop                    ; 
/****************   mux16to1len to inputchann  end  ****************/

/****************   mem_manager to channel_req begin ****************/
logic [`BLK_ADDR_WIDTH-4+1-1:0]     memmanger2channreq_ramspace[`IN_PORT_NUM-1:0];
/****************   mem_manager to channel_req  end  ****************/

/**************** input_channel to channel_arb begin ****************/
logic [`IN_PORT_NUM-1:0]            inputchann2channarb                          ;
/**************** input_channel to channel_arb  end  ****************/

// input port logic generate
genvar port_idx;
generate
    for(port_idx = 0;port_idx<`IN_PORT_NUM;port_idx = port_idx+1) begin : input_port_block
        fifo # (
            .DATA_WIDTH    (32      ),
            .ADDR_WIDTH    (10      ),
            .FWFT_EN       (1'b0    ) // First_n word fall-through without latency
        )fifo_inst(
            .din           (wr_data                [port_idx]),
            .wr_en         (wr_vld                 [port_idx]),
            .full          (full                   [port_idx]),
            .almost_full   (),

            .dout          (chanfifo2channreq_data [port_idx]),
            .rd_en         (channreq2channfifo_rd  [port_idx]),
            .empty         (chanfifo2channreq_empty[port_idx]),
            .almost_empty  (),

            .clk           (clk_in                           ),
            .rst_n         (rst_n_in                         )  
        );

        channel_req # (
            .PORTNUM  (`IN_PORT_NUM  )  ,
            .DWIDTH   (`DATA_WIDTH   )  ,
            .RAMWIDTH (11            )  ,
            .NPACKLEN (8             )  ,
            .PORT_ID  (port_idx      )
        )channel_req_inst(
            .i_clk                   (clk_in                               ),
            .i_rst_n                 (rst_n_in                             ),
  
            .i_data                  (chanfifo2channreq_data  [port_idx]   ),

            .i_empty                 (chanfifo2channreq_empty [port_idx]   ),
            .i_resp                  ({
                                        channarb2channreq_resp[15][port_idx],channarb2channreq_resp[14][port_idx],channarb2channreq_resp[13][port_idx],channarb2channreq_resp[12][port_idx],
                                        channarb2channreq_resp[11][port_idx],channarb2channreq_resp[10][port_idx],channarb2channreq_resp[ 9][port_idx],channarb2channreq_resp[ 8][port_idx],
                                        channarb2channreq_resp[ 7][port_idx],channarb2channreq_resp[ 6][port_idx],channarb2channreq_resp[ 5][port_idx],channarb2channreq_resp[ 4][port_idx],
                                        channarb2channreq_resp[ 3][port_idx],channarb2channreq_resp[ 2][port_idx],channarb2channreq_resp[ 1][port_idx],channarb2channreq_resp[ 0][port_idx]  
                                     }),
            .i_nresp                 ({
                                        channarb2channreq_nresp[15][port_idx],channarb2channreq_nresp[14][port_idx],channarb2channreq_nresp[13][port_idx],channarb2channreq_nresp[12][port_idx],
                                        channarb2channreq_nresp[11][port_idx],channarb2channreq_nresp[10][port_idx],channarb2channreq_nresp[ 9][port_idx],channarb2channreq_nresp[ 8][port_idx],
                                        channarb2channreq_nresp[ 7][port_idx],channarb2channreq_nresp[ 6][port_idx],channarb2channreq_nresp[ 5][port_idx],channarb2channreq_nresp[ 4][port_idx],
                                        channarb2channreq_nresp[ 3][port_idx],channarb2channreq_nresp[ 2][port_idx],channarb2channreq_nresp[ 1][port_idx],channarb2channreq_nresp[ 0][port_idx]  
                                     }),
            .i_ramspace              (memmanger2channreq_ramspace          ),
            .i_ready                 (channarb2channreq_ready              ),
            
            .o_req                   (channreq2channarb_req   [port_idx]   ),

            .o_sop                   (channreq2channarb_sop   [port_idx]   ),
            .o_data                  (channreq2channarb_data  [port_idx]   ),
            .o_data_vld              (channreq2channarb_dvld  [port_idx]   ),
            .o_eop                   (channreq2channarb_eop   [port_idx]   ),

            .o_rd_en                 (channreq2channfifo_rd   [port_idx]   )
        ); 
    end

endgenerate
// input channel logic generate
genvar idx ;
generate 
    for(idx=0;idx<`IN_PORT_NUM;idx=idx+1) begin: input_block
        channel_arb # (
            .PORTNUM (`IN_PORT_NUM )   
        )channel_arb_inst(
            .i_clk         (clk_in                                ),
            .i_rst_n       (rst_n_in                              ),
            .i_chann_req   ({
                                channreq2channarb_req[15][idx],channreq2channarb_req[14][idx],channreq2channarb_req[13][idx],channreq2channarb_req[12][idx],
                                channreq2channarb_req[11][idx],channreq2channarb_req[10][idx],channreq2channarb_req[ 9][idx],channreq2channarb_req[ 8][idx],
                                channreq2channarb_req[ 7][idx],channreq2channarb_req[ 6][idx],channreq2channarb_req[ 5][idx],channreq2channarb_req[ 4][idx],
                                channreq2channarb_req[ 3][idx],channreq2channarb_req[ 2][idx],channreq2channarb_req[ 1][idx],channreq2channarb_req[ 0][idx]
                           }),
            .i_end         (inputchann2channarb     [idx]         ),
            .o_chan_resp   (channarb2channreq_resp  [idx]         ),
            .o_chan_nresp  (channarb2channreq_nresp [idx]         ),
            .o_chan_sel    (channarb2mux16to1en_sel [idx]         ),
            .o_chan_en     (channarb2mux16to1en_en  [idx]         ),
            .o_ready       (channarb2channreq_ready [idx]         )
        );

        mux16to1en mux16to1en_inst (
            .i_clk         (clk_in                                ),
            .i_rst_n       (rst_n_in                              ),
            
            .i_en          (channarb2mux16to1en_en  [idx]         ),
            .i_sel         (channarb2mux16to1en_sel [idx]         ),
            
            .i_rd_sop      (channreq2channarb_sop                 ),
            .i_rd_eop      (channreq2channarb_eop                 ),
            .i_rd_vld      (channreq2channarb_dvld                ),
            .i_rd_data     (channreq2channarb_data                ),

            .o_rd_sop      (mux16to1en2inputchann_sop  [idx]      ),
            .o_rd_eop      (mux16to1en2inputchann_eop  [idx]      ),
            .o_rd_vld      (mux16to1en2inputchann_dvld [idx]      ),
            .o_rd_data     (mux16to1en2inputchann_data [idx]      )
        );
        

        input_channel input_channel_inst(
            .i_clk           (clk_in                             ),
            .i_rst_n         (rst_n_in                           ),

            .i_sop           (mux16to1en2inputchann_sop  [idx]   ),
            .i_wr_vld        (mux16to1en2inputchann_dvld [idx]   ),
            .i_wr_data       (mux16to1en2inputchann_data [idx]   ),
            .i_eop           (mux16to1en2inputchann_eop  [idx]   ),

            .i_blk_addr_vld  (mem2inch_ocp_vld           [idx]   ),
            .i_blk_addr      ({mem2inch_ocp_block_addr[idx],4'b0}),

            .o_sop           (inch2pqm_sop_nc            [idx]   ),
            .o_da            (inch2pqm_da                [idx]   ),
            .o_prority       (inch2pqm_prior             [idx]   ),
            .o_hdr_vld       (inch2pqm_hdr_vld           [idx]   ),
            .o_blk_addr      (inch2pqm_blk_addr          [idx]   ),
            .o_blk_addr_vld  (inch2pqm_blk_addr_vld      [idx]   ),
            .o_eop           (inch2pqm_eop               [idx]   ),
             
            .o_sram_w_vld    (inch2wsram_w_vld           [idx]   ),
            .o_sram_addr     (inch2wsram_sram_addr       [idx]   ),   
            .o_sram_data     (inch2wsram_sram_data       [idx]   ),
    
            .o_addr_req      (inch2mem_addr_req          [idx]   ),
            .o_packet_end    (inputchann2channarb        [idx]   )
        );

        mem_manager #(
            .AWIDTH (10)                  
        )mem_manager_inst(
            .clk                             (clk_in                      ),
            .rst_n                           (rst_n_in                    ),

            // occupy rom
            .ocp_req                         (inch2mem_addr_req          [idx]),
            .ocp_rsp                         (mem2inch_ocp_rsp_nc        [idx]),
            .ocp_block_addr                  (mem2inch_ocp_block_addr    [idx]),
            .ocp_vld                         (mem2inch_ocp_vld           [idx]),
            
            //sram flag signal
            .full                            (mem2inch_full_nc           [idx]),
            .almost_full                     (mem2inch_almost_full_nc    [idx]),
            .empty                           (mem2inch_empty_nc          [idx]),

            // available block num
            .emp_block_num                   (memmanger2channreq_ramspace[idx]),

            //release rom
            .rls_block_addr                  (pqm2mem_addr_rls           [idx]),
            .rls_vld                         (pqm2mem_addr_rls_vld       [idx])
        );

        pqm #(
            .DW_IN  ( `DATA_WIDTH       ),
            .DW_OUT ( `DATA_WIDTH       ),
            .SM_AW  ( `BLK_ADDR_WIDTH-4 )
        )pqm_inst (
            .i_clk                   ( clk_in                         ),
            .i_rst                   ( ~rst_n_in                      ),

            .i_vld                   (inch2pqm_hdr_vld           [idx]),
            .i_da                    (inch2pqm_da                [idx]),
            .i_prior                 (inch2pqm_prior             [idx]),

            .i_addr_in_vld           (inch2pqm_blk_addr_vld      [idx]),
            .i_addr_in               (inch2pqm_blk_addr          [idx][`BLK_ADDR_WIDTH-1:4]),
            .i_frame_last            (inch2pqm_eop               [idx]),              
                   
            .o_addr_in_rdy           (pqm2inch_addr_in_rdy_nc    [idx]),
            
            .i_out_vld               (outctl2pqm_port_vld        [idx]),
            .i_out_port              (outctl2pqm_port            [idx]),       

            .o_addr_rls_vld          (pqm2mem_addr_rls_vld       [idx]),
            .o_addr_rls              (pqm2mem_addr_rls           [idx]),

            .o_frame_last            (pqm2outctl_frame_last_nc   [idx]),

            .i_addr_out_rdy          (outctl2pqm_addr_rdy        [idx]), //rsram2pqmoutctl_read_finish[idx]

            .o_addr_out_vld          (pqm2outctl_addr_out_vld    [idx]),
            .o_addr_out              (pqm2outctl_addr_out        [idx]),
                 
            .o_out_pending           (pqm2qarb_pending           [idx]),
            .o_out_prior_0           (pqm2qarb_out_prior[0 ]     [idx]),
            .o_out_prior_1           (pqm2qarb_out_prior[1 ]     [idx]),
            .o_out_prior_2           (pqm2qarb_out_prior[2 ]     [idx]),
            .o_out_prior_3           (pqm2qarb_out_prior[3 ]     [idx]),
            .o_out_prior_4           (pqm2qarb_out_prior[4 ]     [idx]),
            .o_out_prior_5           (pqm2qarb_out_prior[5 ]     [idx]),
            .o_out_prior_6           (pqm2qarb_out_prior[6 ]     [idx]),
            .o_out_prior_7           (pqm2qarb_out_prior[7 ]     [idx]),
            .o_out_prior_8           (pqm2qarb_out_prior[8 ]     [idx]),
            .o_out_prior_9           (pqm2qarb_out_prior[9 ]     [idx]),
            .o_out_prior_10          (pqm2qarb_out_prior[10]     [idx]),
            .o_out_prior_11          (pqm2qarb_out_prior[11]     [idx]),
            .o_out_prior_12          (pqm2qarb_out_prior[12]     [idx]),
            .o_out_prior_13          (pqm2qarb_out_prior[13]     [idx]),
            .o_out_prior_14          (pqm2qarb_out_prior[14]     [idx]),
            .o_out_prior_15          (pqm2qarb_out_prior[15]     [idx])
        );

        que_arbitrator que_arbitrator_inst(
            .i_clk                  (clk_in                           ),
            .i_rst_n                (rst_n_in                         ),
 
            .i_pending              (pqm2qarb_pending            [idx]),
            .i_prior                (pqm2qarb_out_prior          [idx]),
            
            .i_update               (preq2qarb_update            [idx]),
            .i_clr_vld              (preq2qarb_clr_vld           [idx]),
            .i_clr_port             (preq2qarb_clr_port          [idx]),
        
            .o_port_vld             (qarb2preq_port_vld          [idx]),
            .o_port                 (qarb2preq_port              [idx]),  
            .o_empty                (qarb2preq_empty             [idx])
        );

        port_req #(
            .PORTNUM ( 16 )
        ) port_req_inst (
            .i_clk         (clk_in                            ),
            .i_rst_n       (rst_n_in                          ),
            .i_que_vld     (|(pqm2qarb_pending[idx])          ),
            .i_empty       (qarb2preq_empty              [idx]),
            .i_port_ready  ({
                                parb2preq_port_ready[15],parb2preq_port_ready[14] ,parb2preq_port_ready[13] ,parb2preq_port_ready[12], 
                                parb2preq_port_ready[11],parb2preq_port_ready[10] ,parb2preq_port_ready[ 9] ,parb2preq_port_ready[ 8],
                                parb2preq_port_ready[ 7],parb2preq_port_ready[ 6] ,parb2preq_port_ready[ 5] ,parb2preq_port_ready[ 4],
                                parb2preq_port_ready[ 3],parb2preq_port_ready[ 2] ,parb2preq_port_ready[ 1] ,parb2preq_port_ready[ 0]        
                            }),
            .i_resp        ({
                                parb2preq_resp[15][idx], parb2preq_resp[14][idx], parb2preq_resp[13][idx], parb2preq_resp[12][idx],     
                                parb2preq_resp[11][idx], parb2preq_resp[10][idx], parb2preq_resp[ 9][idx], parb2preq_resp[ 8][idx], 
                                parb2preq_resp[ 7][idx], parb2preq_resp[ 6][idx], parb2preq_resp[ 5][idx], parb2preq_resp[ 4][idx], 
                                parb2preq_resp[ 3][idx], parb2preq_resp[ 2][idx], parb2preq_resp[ 1][idx], parb2preq_resp[ 0][idx]       
                            }),
            .i_nresp       ({
                                parb2preq_nresp[15][idx], parb2preq_nresp[14][idx], parb2preq_nresp[13][idx], parb2preq_nresp[12][idx],     
                                parb2preq_nresp[11][idx], parb2preq_nresp[10][idx], parb2preq_nresp[ 9][idx], parb2preq_nresp[ 8][idx], 
                                parb2preq_nresp[ 7][idx], parb2preq_nresp[ 6][idx], parb2preq_nresp[ 5][idx], parb2preq_nresp[ 4][idx], 
                                parb2preq_nresp[ 3][idx], parb2preq_nresp[ 2][idx], parb2preq_nresp[ 1][idx], parb2preq_nresp[ 0][idx]       
                            }),
            .i_port        (qarb2preq_port               [idx]),
            .i_port_vld    (qarb2preq_port_vld           [idx]),
            .i_r_finish    (rsram2port_rd_eop            [idx]),
 
            .o_update      (preq2qarb_update             [idx]),
            
    
            .o_port_vld    (preq2outctl_port_vld         [idx]), 
            .o_port        (preq2outctl_port             [idx]),
            
            .o_clr_vld     (preq2qarb_clr_vld            [idx]),
            .o_clr_port    (preq2qarb_clr_port           [idx]),
            
            .o_req         (preq2parb_req                [idx])
        );

        output_ctrl #(
            .PORTNUM        ( 16 ),
            .BLK_ADDR_WIDTH ( 10 ),
            .LEN_WIDTH      ( 10 ),
            .TIMES_WIDTH    ( 4  ),
            .QUE_LEN_WIDTH  ( 5  )
        ) output_ctrl_inst (
            .i_clk          ( clk_in                          ),
            .i_rst_n        ( rst_n_in                        ),

            .i_port_vld     (preq2outctl_port_vld        [idx]),                      
            .i_port         (preq2outctl_port            [idx]),

            .i_blk_addr_vld (pqm2outctl_addr_out_vld     [idx]), 
            .i_blk_addr     (pqm2outctl_addr_out         [idx]),

            .i_len_vld      (rsram2outctl_pkt_hdr_vld    [idx]),
            .i_len          (rsram2outctl_pkt_hdr  [idx][16:7]),

            .i_r_done       (rsram2pqmoutctl_read_finish[idx] ),

            .o_blk_addr_vld (outctl2rsram_blk_addr_vld   [idx]),
            .o_blk_addr     (outctl2rsram_blk_addr       [idx]),

            .o_port_vld     (outctl2pqm_port_vld         [idx]),
            .o_port         (outctl2pqm_port             [idx]),
            .o_addr_rdy     (outctl2pqm_addr_rdy         [idx]),

            .o_last_blk_vld (outctl2rsram_last_blk_vld   [idx]),
            .o_last_r_times (outctl2rsram_last_r_times   [idx])
        );

        read_sram read_sram_inst (
            .i_clk                (clk_in  ),
            .i_rst_n              (rst_n_in),
            .i_blk_addr           ({outctl2rsram_blk_addr[idx],4'b0}),
            .i_blk_addr_vld       (outctl2rsram_blk_addr_vld  [idx] ),
            .i_last_blk_vld       (outctl2rsram_last_blk_vld  [idx] ),
            .i_last_blk_n         (outctl2rsram_last_r_times  [idx] ),
            .i_sram_rd_data       (msram2rsram_d_b            [idx] ),
            .o_read_finish        (                                 ),
            .o_read_almost_finish (rsram2pqmoutctl_read_finish[idx] ),
            .o_sram_rd_en         (rsram2msram_rd_en          [idx] ),
            .o_sram_rd_addr       (rsram2msram_sram_rd_addr   [idx] ),
            .o_rd_sop             (rsram2port_rd_sop          [idx] ),
            .o_rd_eop             (rsram2port_rd_eop          [idx] ),
            .o_rd_vld             (rsram2port_rd_vld          [idx] ),
            .o_rd_data            (rsram2port_rd_data         [idx] ),
            .o_pkt_hdr            (rsram2outctl_pkt_hdr       [idx] ),
            .o_pkt_hdr_vld        (rsram2outctl_pkt_hdr_vld   [idx] ),
            .o_crc                (                                 ),
            .o_crc_vld            (                                 )
        );

        multi_sram # (
            .DWIDTH     ( 32   )                ,
            .NRAMWIDHT  ( 1    )                ,
            .AWIDTH     ( 13   )                
         )multi_sram_inst(
            /*================ Port A ================*/
            .clk_a_in      (clk_in                         ),
            .en_a_in       (inch2wsram_w_vld         [idx] ),
            .we_a_in       (inch2wsram_w_vld         [idx] ),
            .addr_a_in     (inch2wsram_sram_addr     [idx] ),
            .d_a_in        (inch2wsram_sram_data     [idx] ),
            .d_a_out       (),
            /*================ Port B ================*/
            //.clk_b_in      (clk_in                         ),
            .en_b_in       (rsram2msram_rd_en        [idx] ),
            .we_b_in       (1'b0                           ),
            .addr_b_in     (rsram2msram_sram_rd_addr [idx] ),
            .d_b_in        (32'b0                          ),
            .d_b_out       (msram2rsram_d_b          [idx] )
        );
    end
endgenerate

// output port logic generate
genvar idx_o ;
generate
    for(idx_o=0;idx_o<`IN_PORT_NUM;idx_o=idx_o+1) begin: output_block
        port_arbitrator #(
             .PORTNUM ( `OUT_PORT_NUM )
        )port_arbitrator_inst (
            .i_clk         (clk_in                       ),
            .i_rst_n       (rst_n_in                     ),
            .i_req         ({ 
                                preq2parb_req[15][idx_o],preq2parb_req[14][idx_o],preq2parb_req[13][idx_o],preq2parb_req[12][idx_o],
                                preq2parb_req[11][idx_o],preq2parb_req[10][idx_o],preq2parb_req[ 9][idx_o],preq2parb_req[ 8][idx_o],
                                preq2parb_req[ 7][idx_o],preq2parb_req[ 6][idx_o],preq2parb_req[ 5][idx_o],preq2parb_req[ 4][idx_o],
                                preq2parb_req[ 3][idx_o],preq2parb_req[ 2][idx_o],preq2parb_req[ 1][idx_o],preq2parb_req[ 0][idx_o]
                            }),
            .i_eop         (rd_eop                  [idx_o]),
            .i_ready       (ready[idx_o]      ),

            .o_port_ready  (parb2preq_port_ready   [idx_o] ),
            .o_resp        (parb2preq_resp         [idx_o] ),
            .o_nresp       (parb2preq_nresp        [idx_o] ),
            .o_en          (parb2mux_en            [idx_o] ),
            .o_sel         (parb2mux_sel           [idx_o] )
        );


        mux16to1 mux16to1_inst(
            .i_clk                       (clk_in                                   ),
            .i_rst_n                     (rst_n_in                                 ),
            .i_en                        (parb2mux_en          [idx_o]             ),
            .i_sel                       (parb2mux_sel         [idx_o]             ),
            .i_rd_sop                    (rsram2port_rd_sop                        ),
            .i_rd_eop                    (rsram2port_rd_eop                        ),
            .i_rd_vld                    (rsram2port_rd_vld                        ),
            .i_rd_data                   (rsram2port_rd_data                       ),
            .o_rd_eop                    (rd_eop               [idx_o]             ),
            .o_rd_sop                    (rd_sop               [idx_o]             ),
            .o_rd_vld                    (rd_vld               [idx_o]             ),
            .o_rd_data                   (rd_data              [idx_o]             )   
        );      

    end
endgenerate

endmodule