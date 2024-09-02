#include "config.h"

config::config(string filepath,string system_cfg_file)
{
    std::ifstream infile(filepath);
    if (!infile.is_open()) {
        std::cerr << "failed to open the file." << std::endl;
    }
    // 读取文件内容
    // std::string fileContent((std::istreambuf_iterator<char>(infile)), std::istreambuf_iterator<char>());
    // std::cout << "File content: " << fileContent << std::endl;
    infile >> json_obj;
    infile.close();
    parse_json();

    if(system_cfg_file.empty()) return;

    std::ifstream syscfg_infile(system_cfg_file);
    if (!syscfg_infile.is_open()) {
        std::cerr << "failed to open the file." << std::endl;
    }
    syscfg_infile >> json_system_cfg;

    syscfg_infile.close();
}

int8_t config::parse_json(){
    map<string,uint8_t> portstr2int = {
        {"port_0", 0},   {"port_1", 1},   {"port_2", 2},   {"port_3", 3},
        {"port_4", 4},   {"port_5", 5},   {"port_6", 6},   {"port_7", 7},
        {"port_8", 8},   {"port_9", 9},   {"port_10", 10}, {"port_11", 11},
        {"port_12", 12}, {"port_13", 13}, {"port_14", 14}, {"port_15", 15}
    };
    for( int i=0;i<IN_PORT_NUM;i++) {
        cfg[i].port_id = 255;;
        for( int j=0;j<OUT_PORT_NUM;j++){
            cfg[i].dst_in_use[j] = 0;
            cfg[i].dst_pkg_num[j] = 0;
        }
    }
    // 遍历顶层的键
    for (auto it = json_obj.begin(); it != json_obj.end(); ++it) {
        // std::cout << "key: " << it.key() << std::endl;
        int src_port = portstr2int[it.key()];
        cfg[src_port].port_id = src_port;
        std::vector<nlohmann::json> portArray = json_obj[it.key()].get<std::vector<nlohmann::json>>();
        for (std::vector<nlohmann::json>::iterator it = portArray.begin(); it != portArray.end(); ++it) {
            nlohmann::json item = *it;
            int dst_port = item["dst_port"].get<int>();
            int pkt      = item["pkt"].get<int>();
            cfg[src_port].dst_in_use[dst_port] = 1;
            cfg[src_port].dst_pkg_num[dst_port] = pkt;
        }
    }

    // show info
//    for( int i=0;i<IN_PORT_NUM;i++) {
//        std::cout << "------------" << endl;
//        std::cout << (int)(cfg[i].port_id) << endl;
//        for( int j=0;j<OUT_PORT_NUM;j++){
//            std::cout << (int)(cfg[i].dst_in_use[j]) << " ";
//        }
//        std::cout << endl;
//        for( int j=0;j<OUT_PORT_NUM;j++){
//            std::cout << cfg[i].dst_pkg_num[j] << " ";
//        }
//        std::cout << endl;
//        std::cout << "------------" << endl;
//    }
    return 0;
}

int8_t config::get_port_pkt(uint8_t port_id){
    std::vector<int> active_indices;
    // 找到dst_in_use为1的有效索引
    for (int i = 0; i < OUT_PORT_NUM; i++) {
        if (cfg[port_id].dst_in_use[i] == 1 && cfg[port_id].dst_pkg_num[i] > 0) {
            active_indices.push_back(i);
        }
    }

    // 如果没有有效的包可以发送，直接返回
    if (active_indices.empty()) {
        return -1;
    }

    // 从有效索引中随机挑选一个
    int random_index = rand() % active_indices.size();
    int selected_index = active_indices[random_index];
    cfg[port_id].dst_pkg_num[selected_index]--;

    return selected_index;
}
