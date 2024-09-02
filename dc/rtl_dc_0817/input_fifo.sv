/*
! 模块功能: 同步FIFO
* 思路:
  1.开辟一个寄存器组作为RAM实现数据存储
*/
module input_fifo #(
  parameter DATA_WIDTH    = 8 ,
  parameter ADDR_WIDTH    = 4 ,
  parameter [0:0] FWFT_EN = 1    // First_n word fall-through without latency
)(
  input  logic [DATA_WIDTH-1:0]  din,
  input  logic                   wr_en,
  output logic                   full,
  output logic                   almost_full,

  output logic [DATA_WIDTH-1:0]  dout,
  input  logic                   rd_en,
  output logic                   empty,
  output logic                   almost_empty,

  input  logic                   clk,
  input  logic                   rst_n
);

logic half_full_nc;
logic error_nc    ;
DW_fifo_s1_df # (
    .width ( DATA_WIDTH     ),
    .depth ( 1 <<ADDR_WIDTH )
)DW_fifo_s1_df_inst(
    .clk         (clk                ), 
    .rst_n       (rst_n              ), 
    .push_req_n  (wr_en              ),
    .pop_req_n   (rd_en              ),
    .diag_n      (1'b1               ), 
    .ae_level    ({ADDR_WIDTH{1'b0}} ), 
    .af_thresh   ((1 <<ADDR_WIDTH )-2), 
    .data_in     (din                ), 
    .empty       (empty              ), 
    .almost_empty(almost_empty       ),
    .half_full   (half_full_nc       ), 
    .almost_full (almost_full        ), 
    .full        (full               ), 
    .error       (error_nc           ), 
    .data_out    (dout               )
);



// //++ 生成读写指针 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// logic  [ADDR_WIDTH:0] rptr;
// always_ff @(posedge clk or negedge rst_n) begin
//   if (!rst_n)
//     rptr <= 'b0;
//   else if (rd_en & ~empty)
//     rptr <= rptr + 1'b1;
// end


// logic  [ADDR_WIDTH:0] wptr;
// always_ff @(posedge clk or negedge rst_n) begin
//   if (!rst_n)
//     wptr <= 'b0;
//   else if (wr_en & ~full)
//     wptr <= wptr + 1'b1;
// end

// /**
// * @ bref: why use rptr and wptr directly, and why declare rptr/wptr with width of ADDR_WIDTH+1 
// */
// logic [ADDR_WIDTH-1:0] raddr ;
// logic [ADDR_WIDTH-1:0] waddr ;


// logic [ADDR_WIDTH:0] rptr_p1 ;
// logic [ADDR_WIDTH:0] wptr_p1 ;

// assign raddr = rptr[ADDR_WIDTH-1:0];
// assign waddr = wptr[ADDR_WIDTH-1:0];
// assign rptr_p1 = rptr + 1'b1;
// assign wptr_p1 = wptr + 1'b1;

// //-- 生成读写指针 ------------------------------------------------------------


// //++ 生成empty与almost_empty信号 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// always_comb begin
//   if (!rst_n)
//     empty = 1'b1;
//   else if (rptr == wptr)
//     empty = 1'b1;
//   else
//     empty = 1'b0;
// end


// always_comb begin
//   if (!rst_n)
//     almost_empty = 1'b1;
//   else if (rptr_p1 == wptr || empty)
//     almost_empty = 1'b1;
//   else
//     almost_empty = 1'b0;
// end
// //-- 生成empty与almost_empty信号 ------------------------------------------------------------


// //++ 生成full与almost_full信号 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// always_comb begin
//   if (!rst_n)
//     full  = 1'b1;
//   else if ((wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH])
//           && (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0])
//           )
//     full  = 1'b1;
//   else
//     full  = 1'b0;
// end


// always_comb begin
//   if (!rst_n)
//     almost_full = 1'b1;
//   else if (((wptr_p1[ADDR_WIDTH] != rptr[ADDR_WIDTH])
//             && (wptr_p1[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0])
//             )
//           || full
//           )
//     almost_full = 1'b1;
//   else
//     almost_full = 1'b0;
// end
// //-- 生成full与almost_full信号 ------------------------------------------------------------


// //++ 寄存器组定义与读写 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// localparam DEPTH = 1 << ADDR_WIDTH; // 等价于 2**ADDR_WIDTH

// // (* ram_style ="distributed" *)
// (* ram_style ="block" *)
// logic [DATA_WIDTH-1:0] mem [0:DEPTH-1]; // 在Vivado中可选两种实现方式(* ram_style ="block" *)


// always_ff @(posedge clk) begin
//   if (wr_en && ~full)
//     mem[waddr] <= din;
// end


// generate
//   if (FWFT_EN == 1'b1) begin
//     // 这种写法会使得在empty为高时, dout为下一个地址的值, 此行为与Vivado FIFO不一致
//     // assign dout = mem[raddr];

//     // Vivado FIFO在FIFO为空时, dout保持最后一个有效值, 为实现这一特性, 采用了下方的写法
//     // 注意这两种写法的功能都是正确的
//     logic [DATA_WIDTH-1:0] dout_old;
//     always_ff @(posedge clk or negedge rst_n) begin
//        if( !rst_n ) begin
//         dout_old <= 'b0;
//     end else if (rd_en && ~empty)
//         dout_old <= mem[raddr]; // 存储上一个值
//       else 
//         dout_old <= 'b0;
//     end

//     logic [DATA_WIDTH-1:0] dout_r;
//     always @(*) begin              // if use always_comb --> some warning
//       if (~empty)
//         dout_r = mem[raddr];
//       else
//         dout_r = dout_old;
//     end

//     assign dout = dout_r;
//   end
//   else begin
//     logic [DATA_WIDTH-1:0] dout_r;

//     always_ff @(posedge clk or negedge rst_n) begin
//       if( !rst_n ) begin
//         dout_r <= 'b0;
//       end else if (rd_en && ~empty)
//         dout_r <= mem[raddr];
//       else 
//         dout_r <= 'b0;
//     end

//     assign dout = dout_r;
//   end
// endgenerate
//-- 寄存器组定义与读写 ------------------------------------------------------------
endmodule
