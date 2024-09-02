#include <QCoreApplication>
#include "lib/json.hpp"
#include <iostream>
#include <string>
#include <QDir>
#include "config.h"
#include "udp_utils.h"
int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    // 获取命令行参数
    QStringList args = a.arguments();

    // 检查参数数量是否正确
    if (args.size() !=6 && args.size() !=7) {  // args[0] 是程序名称，后面5个是需要的参数
        qCritical() << "Usage: program <server_ip> <server_port> <client_ip> <client_port> <json_file>";
        return -1;
    }
    QString serverIp = args[1];
    quint16 serverPort = args[2].toUShort();
    QString clientIp = args[3];
    quint16 clientPort = args[4].toUShort();
    QString json_file = args[5];

    string syscfg_path ="";
    if( args.size() == 7){
        syscfg_path = args[6].toStdString();
    }
    config cfg(json_file.toStdString(),syscfg_path);

    // QString appDir = QDir::currentPath();
    // QDir projectDir = QDir(appDir);
    // projectDir.cdUp();
    // config cfg(projectDir.path().toStdString() + "/mpcache_console/config/config.json");

    // 创建接收器对象
    // udp_recver udp_recvor("192.168.19.121",33333);
    udp_recver udp_recvor(serverIp.toStdString(),serverPort);

    // 创建线程和发送器对象
    QThread udpThread;
    // udp_sender udp_sendor("192.168.19.121",44444 );
    udp_sender udp_sendor(cfg,clientIp.toStdString(),clientPort,udp_recvor.udpSocket);
    // 将工作对象移动到线程中
    udp_sendor.setParent(nullptr);
    udp_sendor.moveToThread(&udpThread);
    udpThread.start();
    // 启动发送数据的线程
    QMetaObject::invokeMethod(&udp_sendor, "udp_send_pkt",
                              Qt::QueuedConnection);

    int ret =  a.exec();
    QMetaObject::invokeMethod(&udp_sendor, "stopSending", Qt::QueuedConnection);
    udpThread.quit();
    udpThread.wait();
    return ret;
}





