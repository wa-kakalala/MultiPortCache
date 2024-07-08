

module gen_random_byte #(
    parameter   RW = 32 // RW, random seed width, must be larger than rand_data_bytes
)
(  
    input                   rst_n,    /*rst_n is necessary to prevet locking up*/  
    input                   clk,      /*clock signal*/  
    input                   i_load,     /*load seed to rand_num,active high */  
    input      [RW-1:0]     i_seed,       
    output wire [7:0]        o_rand_byte  /*random number output*/  
);  


    integer i=0;
    
    wire [RW-1:0] en_re; //
    assign en_re = {(RW/8){8'ha3}};  


    reg [RW-1:0] rand_num;
    
    
    always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            rand_num    <='b0;  
        else if(i_load)  
            rand_num <= i_seed;    /*load the initial value when load is active*/  
        else  
            begin  
                rand_num[0] <= rand_num[RW-1];
                for(i=1; i<RW; i=i+1) begin
                    rand_num[i] <= en_re[i]? rand_num[i- 1]^rand_num[RW-1] : rand_num[i-1];
                end
            end
    end

    assign o_rand_byte = rand_num[7:0];

endmodule  