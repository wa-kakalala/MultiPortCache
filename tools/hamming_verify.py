
'''


'''
import sys
sys.path.append(r"D:\Documents\pythonD\ac_python_class") #

from ac_signal import *


in_data = signal(32, 0xeeff_aabb)
d = [ in_data[i].v() for i in range(32)]
# print(d)


p0 = d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[11]^d[13]^d[15]^d[17]^d[19]^d[21]^d[23]^d[25]^d[26]^d[28]^d[30]
p1 = d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[10]^d[12]^d[13]^d[16]^d[17]^d[20]^d[21]^d[24]^d[25]^d[27]^d[28]^d[31]
p2 = d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[10]^d[14]^d[15]^d[16]^d[17]^d[22]^d[23]^d[24]^d[25]^d[29]^d[30]^d[31]
p3 = d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[10]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25]
p4 = d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25]
p5 = d[26]^d[27]^d[28]^d[29]^d[30]^d[31]

print(p5, p4, p3, p2, p1, p0)


now_data = signal(32, 0xeeff_aabb)
d = [ now_data[i].v() for i in range(32)]


hamm = signal(6, 0x00)
h = [hamm[i].v() for i in range(6) ]

h[0] = p0^ d[0]^d[1]^d[3]^d[4]^d[6]^d[8]^d[10]^d[11]^d[13]^d[15]^d[17]^d[19]^d[21]^d[23]^d[25]^d[26]^d[28]^d[30]
h[1] = p1^ d[0]^d[2]^d[3]^d[5]^d[6]^d[9]^d[10]^d[12]^d[13]^d[16]^d[17]^d[20]^d[21]^d[24]^d[25]^d[27]^d[28]^d[31]
h[2] = p2^ d[1]^d[2]^d[3]^d[7]^d[8]^d[9]^d[10]^d[14]^d[15]^d[16]^d[17]^d[22]^d[23]^d[24]^d[25]^d[29]^d[30]^d[31]
h[3] = p3^ d[4]^d[5]^d[6]^d[7]^d[8]^d[9]^d[10]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25]
h[4] = p4^ d[11]^d[12]^d[13]^d[14]^d[15]^d[16]^d[17]^d[18]^d[19]^d[20]^d[21]^d[22]^d[23]^d[24]^d[25]
h[5] = p5^ d[26]^d[27]^d[28]^d[29]^d[30]^d[31]

error_position =0
for i in range(6):
    error_position += (h[i]<<i) 


print(f"0b{h[5]}{h[4]}{h[3]}{h[2]}{h[1]}{h[0]}")
print(error_position)
