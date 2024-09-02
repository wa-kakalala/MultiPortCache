###########################################
# filename    : check_data.py
# author      : yyrwkk
# create time : 2024/07/12 22:31:13
# version     : v1.0.0
###########################################
import os 
input_file_name_format = "./data/in/in_file_%d.txt"
output_file_name_format = "./data/out/out_file_%d.txt"

class Info:
    packet_num = 0
    packet_num_err = 0
    
in_port_info = [ Info() for i in range(16) ]
out_port_info = [ Info() for i in range(16) ]

output_data_table = []
for i in range( 16 ):
    output_data_table.append({})

############### get output data
for i in range(16):
    file_path = output_file_name_format%(i)
    if not os.path.exists(file_path):
        continue
    f = open(file_path,"r")
    for line in f.readlines():
        output_data_table[i][line[0:8]] = line
    out_port_info[i].packet_num = len(output_data_table[i])
    f.close()
############### check data
for i in range(16):
    file_path = input_file_name_format%(i)
    if not os.path.exists(file_path):
        continue
    f = open(file_path,"r")
    packet_cnt = 0
    packet_err = 0
    pkt_count = 0
    for line in f.readlines():
        out_port = int(line[7],16)
        if line[0:8] in output_data_table[out_port] :
            if output_data_table[out_port][line[0:8]] == line:
                del output_data_table[out_port][line[0:8]]
            else:
                print("Not Equal: input port %d , index %d ,output port %d"%(i,packet_cnt,out_port))
                packet_err  = packet_err +1
        else :
            print( " no in ..............")
            print("port [%d] -> [%d]"%(i,packet_cnt))
            print(line)
            packet_err  = packet_err +1
        packet_cnt = packet_cnt + 1
    in_port_info[i].packet_num = packet_cnt
    in_port_info[i].packet_num_err = packet_err
    f.close

############### update err packet
for i in range(16):
    out_port_info[i].packet_num_err = len(output_data_table[i])

############### output info
print("============== in port info ==============")
total = 0
for i in range(16):
    print("in port [%2d]"%(i))
    print("packet num :%5d , packet err: %5d"%(in_port_info[i].packet_num,in_port_info[i].packet_num_err))
    total = total + in_port_info[i].packet_num
print("total: %d"%(total))

total = 0
print("============== out port info ==============")

for i in range(16):
    print("out port [%2d]"%(i))
    print("packet num :%5d , packet err: %5d"%(out_port_info[i].packet_num,out_port_info[i].packet_num_err))
    total = total + out_port_info[i].packet_num
print("total: %d"%(total))























