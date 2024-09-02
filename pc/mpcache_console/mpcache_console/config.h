#ifndef CONFIG_H
#define CONFIG_H
#include <iostream>
#include <fstream>
#include <string>
#include "lib/json.hpp"
using namespace std;
#define IN_PORT_NUM (16)
#define OUT_PORT_NUM (16)
typedef struct config_t{
    uint8_t port_id;
    uint8_t dst_in_use   [OUT_PORT_NUM] ;
    uint32_t dst_pkg_num [OUT_PORT_NUM] ;
} config_t;

class config
{
public:
    config_t cfg [IN_PORT_NUM];
    nlohmann::json json_system_cfg;
    config(string filepath,string system_cfg_file="");
    config(){};
    int8_t get_port_pkt(uint8_t port_id);

private:
    nlohmann::json json_obj;
    int8_t parse_json() ;
};

#endif // CONFIG_H
