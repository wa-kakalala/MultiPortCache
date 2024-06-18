#include <stdio.h>
#include "svdpi.h"

typedef unsigned char	u8;
typedef unsigned short  u16;
typedef unsigned int    u32;
typedef unsigned long	u64;

//data 是要CRC计算的数据都是 8 bit 的 16 进制
u8 data[] = {
	0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee,		//目的 MAC 地址 
	0x54, 0xe1, 0xad, 0x7e, 0xc5, 0x11,		//源 MAC 地址 
	0x08, 0x00,								//帧类型 
	0x45,									//版本号 4，首部长度 20 字节 ==> 5
	0x00,									//服务类型，默认
	0x00, 0x2e,								//总长度（首部 + 数据）
	0x12, 0x34, 							//16 标识位 
	0x40, 0x00,								//3 比特标志不分片 010 ，13 比特片偏移 
	0x40,									//生存时间 64 
	0x11,									//上层协议，以 UDP 为例 17
	0xa4, 0x43,								//IP 首部检验和 
	0xc0, 0xa8, 0x01, 0x51,					//源 IP 地址		192.168.1.81 
	0xc0, 0xa8, 0x01, 0xa6,					//目的地 IP 地址 	192.168.1.166
	0x17, 0xc1,								//源端口 
	0x1b, 0xa9,								//目的地端口 
	0x00, 0x1a,								//UDP 长度 
	0x6c, 0x2c,								//UDP 检验和 
	0x51, 0x51, 0x51, 0x51, 0x51, 0x51,		//传输数据 
	0x51, 0x51, 0x51, 0x51, 0x51, 0x51,
	0x51, 0x51, 0x51, 0x51, 0x51, 0x51
};

//方法一 
u8 reverse8(u8 data) {
    u8 i;
    u8 temp = 0;
    for (i = 0; i < 8; i++)	    				// 8 bit反转
        temp |= ((data >> i) & 0x01) << (7 - i);
    return temp;
}
u32 reverse32(u32 data) {
    u8 i;
    u32 temp = 0;
    for (i = 0; i < 32; i++)					// 32 bit反转
        temp |= ((data >> i) & 0x01) << (31 - i);
    return temp;
}
//正向计算
u32 crc32(u8* addr, int num) {
    u8 data;
    u32 crc = 0xffffffff;						//初始值
    int i;
    for (; num > 0; num--) {
        data = *addr++;
        data = reverse8(data);					//字节反转
        crc = crc ^ (data << 24);				//与crc初始值高8位异或 
        for (i = 0; i < 8; i++) {				//循环8位
            if (crc & 0x80000000)				//左移移出的位为1，左移后与多项式异或
                crc = (crc << 1) ^ 0x04c11db7;
            else {
                crc <<= 1;						//否则直接左移
            }
        }
    }
    crc = reverse32(crc);						//字节反转
    crc = crc ^ 0xffffffff;	                	//最后返与结果异或值异或
    return crc;                                 //返回最终校验值
}

//反向计算
u32 crc32_reverse(u8 array[], int len) {
	u8 data;
	u32 crc = 0xffffffff;
	for (int i = 0; i < len; i++) {
		data = array[i];
		crc = crc ^ data;
		for (int bit = 0; bit < 8; bit++) {				//循环8位
            if (crc & 0x00000001)				//右移移出的位为1，右移后与多项式异或
                crc = (crc >> 1) ^ 0xedb88320;
            else {
                crc >>= 1;						//否则直接右移
            }
        }
	}
	return crc ^ 0xffffffff;
} 

u8 data_arr[1025];
int data_len = 0;

void crc32_indata(int data) {
    data_arr[data_len ++] = data & 0xff;
    data_arr[data_len ++] = (data >> 8 ) & 0xff;
    data_arr[data_len ++] = (data >> 16) & 0xff;
    data_arr[data_len ++] = (data >> 24) & 0xff;
}

void crc32_init(){
    data_len = 0;
}

int crc32_calc(){
    data_len = 0;
    crc32(data_arr, data_len);
}

