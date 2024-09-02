#ifndef UDP_UTILS_H
#define UDP_UTILS_H

#include <QCoreApplication>
#include <QUdpSocket>
#include <QByteArray>
#include <QHostAddress>
#include <iostream>
#include <QThread>
#include "config.h"
#include <iomanip>
#include <QtEndian>
#include <windows.h>

#define BLOCK_CTRL (1)
#define WORK_CTRL  (2)

typedef struct send_pkt_t {
//    uint8_t hdr_first_byte ;
//    uint8_t hdr_second_byte;

//    uint8_t src_port  ;
//    uint8_t dst_port  ;

//    uint8_t priority;

//    uint8_t length_h  ;
//    uint8_t length_l  ;

//    uint8_t inter_h   ;
//    uint8_t inter_l   ;    // 间隔时间

//    uint8_t tail_first_byte ;
//    uint8_t tail_second_byte;

      uint8_t byte_0  ;
      uint8_t byte_1  ;
      uint8_t byte_2  ;
      uint8_t byte_3  ;

} send_pkt_t;

#pragma pack(1)  // 强制 1 字节对齐
typedef struct recv_pkt_item_t {
    uint16_t pkt_num         ;
    uint32_t speed_clk_valid ;
    uint32_t speed_clk_num   ;
}recv_pkt_item_t;
#pragma pack()

using namespace std;
class udp_sender: public QObject {
    Q_OBJECT
public:
    udp_sender(config cfg,string client_ip,int client_port,QUdpSocket *udpSocket,QObject *parent = nullptr);

public slots:
    void udp_send_pkt();
    void stop_sending();
private:
    string client_ip;
    int client_port ;
    QUdpSocket *udpSocket;
    bool running;
    config cfg;

    send_pkt_t generate_pkt(uint8_t src_port, uint8_t dst_port,uint8_t ctrl_flag=0);
};

class udp_recver: public QObject {
    Q_OBJECT
public:
    QUdpSocket *udpSocket;
    udp_recver(string server_ip , int server_port,QObject *parent = nullptr);
public slots:
    void receive_data();

private:
    string server_ip;
    int server_port ;
    float send_max_speed[IN_PORT_NUM];
    float recv_max_speed[OUT_PORT_NUM];
};




#endif // UDP_UTILS_H
