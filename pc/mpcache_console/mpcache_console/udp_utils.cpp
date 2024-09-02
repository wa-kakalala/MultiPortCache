#include "udp_utils.h"
#include <QMutex>
QMutex mutex;
udp_sender::udp_sender(config cfg,string client_ip,int client_port,QUdpSocket *udpSocket,QObject *parent):QObject(parent)
{
    this->client_ip = client_ip;
    this->client_port = client_port;
    this->cfg = cfg;
//    std::cout << "sizeof recv_pkt_item_t:" << sizeof(recv_pkt_item_t) << endl;
//    udpSocket = new QUdpSocket(this);
//    if( !udpSocket->bind(QHostAddress(QString::fromStdString(server_ip)), server_port)){
//        std::cout << "bind port error !!" << endl;
//    }
    this->udpSocket = udpSocket;
}


// 生成 send_pkt_t 的函数
send_pkt_t udp_sender::generate_pkt(uint8_t src_port, uint8_t dst_port,uint8_t ctrl_flag) {
    send_pkt_t pkt;

    if( ctrl_flag == BLOCK_CTRL){
        pkt.byte_0 = 0x00;
        pkt.byte_1 = 0x00;
        pkt.byte_2 = 0x00;
        pkt.byte_3 = 0x00;
        return pkt;
    }else if( ctrl_flag == WORK_CTRL ){
        pkt.byte_0 = 0xff;
        pkt.byte_1 = 0xff;
        pkt.byte_2 = 0xff;
        pkt.byte_3 = 0xff;
        return pkt;
    }

    uint8_t priority = rand() % 8;
    uint16_t length = rand() % (1023 - 63 + 1) + 63;

    // 设置头部字节
//    pkt.hdr_first_byte = 0xaa;
//    pkt.hdr_second_byte = 0xaa;

//    // 设置源端口和目的端口
//    pkt.src_port = src_port;
//    pkt.dst_port = dst_port;

//    // 设置随机优先级 (0-7)
//    pkt.priority = rand() % 8;

//    // 设置随机长度 (63-1023)，并分为高8位和低8位
//    uint16_t length = rand() % (1023 - 63 + 1) + 63;
//    pkt.length_h = (length >> 8) & 0xff; // 高8位
//    pkt.length_l = length & 0xff;        // 低8位

//    // time_interval_min
//    // time_interval_max
    int time_interval_min = 0;
    int time_interval_max = 0;
    if(cfg.json_system_cfg.contains("time_interval_min")){
        time_interval_min = cfg.json_system_cfg["time_interval_min"];
    }

    if(cfg.json_system_cfg.contains("time_interval_max")){
        time_interval_max = cfg.json_system_cfg["time_interval_max"];
    }

    if( time_interval_max == 0 || time_interval_min==0 || time_interval_min > time_interval_max ){
        time_interval_max = 100;
        time_interval_min = 60;
    }

    // 设置随机间隔时间 (60-100)，并分为高8位和低8位
    uint16_t inter = time_interval_min + rand() % (time_interval_max-time_interval_min+1);
    pkt.byte_0 = (src_port&0x0f) | ((dst_port<<4) & 0xf0);
    pkt.byte_1 = (priority & 0b111 ) | ((length << 3) & 0b11111000);
    pkt.byte_2 = ((length >> 5 ) & 0b11111) | ((inter << 5) & 0b11100000);
    pkt.byte_3 = (inter>>3) & 0b01111111;
//    pkt.inter_h = (inter >> 8) & 0xff;   // 高8位
//    pkt.inter_l = inter & 0xff;          // 低8位

//    // 设置尾部字节
//    pkt.tail_first_byte = 0xbb;
//    pkt.tail_second_byte = 0xbb;

    return pkt;
}

bool gotoyx(short y,short x){
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    if (NULL == hConsole) {
        return false;
    }

    COORD coord = { (SHORT)x, (SHORT)y };
    return ::SetConsoleCursorPosition(hConsole, coord);
}

void udp_sender::udp_send_pkt(){
    running = true;
    QByteArray data = "Hello, UDP!";
    int dst_port_list[IN_PORT_NUM][OUT_PORT_NUM] = {{0}};
    data.clear();
    send_pkt_t send_pkt_block = generate_pkt(0,0,WORK_CTRL);
    data.append(reinterpret_cast<const char*>(&send_pkt_block), sizeof(send_pkt_t));
    system("cls");
    HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
    CONSOLE_CURSOR_INFO cinfo;
    cinfo.bVisible = 0; // 隐藏光标
    cinfo.dwSize = 1;
    SetConsoleCursorInfo(hConsole, &cinfo);
    while(1) {
        // QThread::sleep(2);
        for( uint8_t pkt_repeat =0;pkt_repeat< 20;pkt_repeat++) {
            for( uint8_t i = 0;i< IN_PORT_NUM;i++ ){
                int8_t dst_port = cfg.get_port_pkt(i);
                if( dst_port == -1) continue;
                dst_port_list[dst_port][i] ++;

                send_pkt_t send_pkt = generate_pkt(i,dst_port);
                data.append(reinterpret_cast<const char*>(&send_pkt), sizeof(send_pkt_t));
            }
        }

        if(data.size() < 80 ) {
            for( int j=0;j<20;j++){
                send_pkt_t send_pkt_work = generate_pkt(0,0,WORK_CTRL);
                data.append(reinterpret_cast<const char*>(&send_pkt_work), sizeof(send_pkt_t));
            }

            udpSocket->writeDatagram(data, QHostAddress(QString::fromStdString(client_ip)), client_port);
            break;
        }
        udpSocket->writeDatagram(data, QHostAddress(QString::fromStdString(client_ip)), client_port);
        data.clear();
        // show info
        mutex.lock();
        std::cout << std::string(200, ' ') << "\r";
        gotoyx(0,0);
        std::cout << std::string(105, '-') << std::endl;
        //std::cout << "\033[2;1H";  // 移动到第2行第1列
        std::cout << std::string(200, ' ') << "\r";
        gotoyx(1,0);
        std::cout << std::left << "src_port   :";
        for( uint8_t i=0;i<IN_PORT_NUM;i++){
            std::cout << std::setw(6) << static_cast<int>(i);
        }
        std::cout << std::endl;
        std::cout << std::string(105, '-') << std::endl;

        int cmd_total = 0;
        for(int row = 4;row < 4+OUT_PORT_NUM;row++){
            //std::cout << "\033["<< row << ";1H";  // 移动到第3行第1列
            std::cout << std::string(80, ' ') << "\r";
            std::cout << std::left << "dst_port " <<std::setw(2) << row-4<<":";
            for (int &port_num : dst_port_list[row-4]) {
                std::cout << std::setw(6) << static_cast<int>(port_num);
                cmd_total += (int)(port_num);
            }
            std::cout << std::endl;

        }
        std::cout << std::string(105, '-') << std::endl ;

        std::cout << std::string(80, ' ') << "\r";
        std::cout << "total cmd   :" << cmd_total << std::endl;
        std::cout << std::string(105, '-') << std::endl ;

        mutex.unlock();
    }
}

void udp_sender::stop_sending(){
    running = false;
}

udp_recver::udp_recver(string server_ip, int server_port,QObject *parent):QObject(parent){
    this->server_ip = server_ip;
    this->server_port = server_port;
    udpSocket = new QUdpSocket(this);
    for(int i=0;i<IN_PORT_NUM;i++){
        send_max_speed[i] = 0.0;
    }
    for(int i=0;i<OUT_PORT_NUM;i++){
        recv_max_speed[i] = 0.0;
    }
    // 绑定端口，监听所有地址上的 udp 数据
    // QHostAddress::Any
    udpSocket->bind( QHostAddress(QString::fromStdString(server_ip)), server_port);

    // 连接 readyRead 信号到槽函数
    connect(udpSocket, &QUdpSocket::readyRead, this, &udp_recver::receive_data);
}


QByteArray buffer_global;


void udp_recver::receive_data() {
    // 当有数据时，执行接收处理
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray buffer;
        buffer.resize(udpSocket->pendingDatagramSize());

        QHostAddress sender;
        quint16 senderPort;

        float port_recv_speed[IN_PORT_NUM];
        uint16_t port_recv_pkt_num[IN_PORT_NUM];

        float port_send_speed[IN_PORT_NUM];
        uint16_t port_send_pkt_num[IN_PORT_NUM];

        int send_pkt_total = 0;
        int recv_pkt_total = 0;

        // 读取数据包
        udpSocket->readDatagram(buffer.data(), buffer.size(), &sender, &senderPort);

        if( buffer == buffer_global) return;

        int size = buffer.size();
        uint8_t * pkt_hdr = new uint8_t[size];
        memcpy(pkt_hdr, buffer.constData(), size);
        uint8_t * p_pkt_hdr = pkt_hdr;
        if( (p_pkt_hdr[0]) != 0xaa || (p_pkt_hdr[1]!= 0xaa)) {
            return ;
        }
        p_pkt_hdr += 2;

        recv_pkt_item_t * pkt_item;

        for( int i=0;i<IN_PORT_NUM;i++) {
            pkt_item = (recv_pkt_item_t *) p_pkt_hdr;
            port_recv_pkt_num[i] = qToBigEndian(pkt_item->pkt_num);

            recv_pkt_total += port_recv_pkt_num[i];
            if( qToBigEndian(pkt_item->speed_clk_num) == 0 ) {
                port_recv_speed[i] = 0.0;
            }else {
                port_recv_speed[i] = (float)(qToBigEndian(pkt_item->speed_clk_valid)) / qToBigEndian(pkt_item->speed_clk_num) * 32 * 125 / 1000 ;
                if(port_recv_speed[i] > recv_max_speed[i]) recv_max_speed[i] = port_recv_speed[i];
            }
            p_pkt_hdr += sizeof(recv_pkt_item_t);
        }

        for( int i=0;i<IN_PORT_NUM;i++) {
            pkt_item = (recv_pkt_item_t *) p_pkt_hdr;
            port_send_pkt_num[i] = qToBigEndian(pkt_item->pkt_num);
            send_pkt_total += port_send_pkt_num[i];
            if( qToBigEndian(pkt_item->speed_clk_num) == 0 ) {
                port_send_speed[i] = 0.0;
            }else {
                port_send_speed[i] = (float)(qToBigEndian(pkt_item->speed_clk_valid)) / qToBigEndian(pkt_item->speed_clk_num) * 32 * 125 / 1000 ;
                if(port_send_speed[i] > send_max_speed[i]) send_max_speed[i] = port_send_speed[i];
            }
            p_pkt_hdr += sizeof(recv_pkt_item_t);
        }

        if( (p_pkt_hdr[0]) != 0xbb || (p_pkt_hdr[1]!= 0xbb)) {
            return ;
        }

        delete[] pkt_hdr;

        buffer_global = buffer;
        buffer_global.detach();

        mutex.lock();
        // 打印接收到的数据和发送者信息
        // std::cout << "\033[26;1H";  // 移动到第7行第1列
        gotoyx(24,0);
        std::cout << std::string(37, '*') << " port send speed "<< std::string(37, '*')<< std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "src_port  : ";
        for( uint8_t i=0;i<IN_PORT_NUM;i++){
            std::cout << std::setw(5) << static_cast<int>(i);
        }
        std::cout << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "pkt_num   : ";
        for (uint16_t &pkt_num : port_send_pkt_num) {
            std::cout << std::setw(5) << static_cast<int>(pkt_num);
        }
        std::cout << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "send_speed: ";
        for (float &speed : port_send_speed) {
            std::cout << std::setw(5) << std::fixed << std::setprecision(2)<< static_cast<float>(speed);
        }
        std::cout << std::endl;
        std::cout << std::string(35, '*') << " port recv num&speed "<< std::string(35, '*')<< std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "dst_port  : ";
        for( uint8_t i=0;i<IN_PORT_NUM;i++){
            std::cout << std::setw(5) << static_cast<int>(i);
        }
        std::cout << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "pkt_num   : ";
        for (uint16_t &pkt_num : port_recv_pkt_num) {
            std::cout << std::setw(5) << static_cast<int>(pkt_num);
        }
        std::cout << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "recv_speed: ";

        for (float &speed : port_recv_speed) {
            std::cout << std::setw(5) << std::fixed << std::setprecision(2)<< static_cast<float>(speed);
        }
        std::cout << std::endl;
        std::cout << std::string(91, '*') << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "send_pkt_total: ";
        std::cout << std::setw(5) << send_pkt_total << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "recv_pkt_total: ";
        std::cout << std::setw(5) << recv_pkt_total << std::endl;

        std::cout << std::string(91, '*') << std::endl;
        std::cout << std::string(80, ' ') << "\r";

        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "send_max: ";
        for (float &speed : send_max_speed) {
            std::cout << std::setw(5) << std::fixed << std::setprecision(2)<< static_cast<float>(speed);
        }
        std::cout << std::endl;
        std::cout << std::string(80, ' ') << "\r";
        std::cout << std::left << std::setw(10) << "recv_max: ";
        for (float &speed : recv_max_speed) {
            std::cout << std::setw(5) << std::fixed << std::setprecision(2)<< static_cast<float>(speed);
        }
        std::cout << std::endl;
        mutex.unlock();
    }
}


