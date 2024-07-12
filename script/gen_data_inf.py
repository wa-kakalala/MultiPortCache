import random
import os

import struct



random.seed(10)

# 包含了所有 packet 信息的 txt
txt_file_path = "D:\\Desktop\\data_gen_data\\in_packet_inf.txt"
txt_file = open(txt_file_path, "w")

for sa in range(0,16):
    # 不同的 data gen 有不同的 dat 文件
    dat_file_path = "D:\\Desktop\\data_gen_data\\dat{:}.dat".format(sa)
    dat_file = open( dat_file_path, 'w')
    
    # 每个 data gen 生成包个数
    for i in range(100):
        da = random.randint(0,0)
        prior = random.randint(0,7)
        len = random.randint(64,1024)
        wait_cnt = random.randint(0, 1024)

        # write .dat/.mem file
        gen_dat = (da<<0) + (prior<<4) + (len<<7) + (wait_cnt<<17)
        gen_dat = format(gen_dat, '08x') #32bit 格式
        print( gen_dat, file = dat_file )

        header_dat = (da<<0) + (prior<<4) + (len<<7)
        header_dat = format(header_dat, '08x') #32bit 格式

        # write txt file to record this packet
        print( f"SA={sa:02}, DA={da:02}, prior={prior:02}, len={len:4},    wait time={wait_cnt:4},   data gen inf:{gen_dat},   header: {header_dat}", file = txt_file)

    #
    dat_file.close()


txt_file.close()

        