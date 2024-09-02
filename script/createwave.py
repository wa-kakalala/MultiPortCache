# template = '''
# add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/wr_sop[%d]}
# add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/wr_eop[%d]}
# add wave -noupdate -expand -group port%d -color Magenta -height 15 {/tb_mpcache_top/mpcache_inst/wr_vld[%d]}
# add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/rd_data[%d]}
# '''
# template = '''
# add wave -noupdate -expand -group o_port%d -color Blue {/tb_mpcache_top/mpcache_inst/rd_sop[%d]}
# add wave -noupdate -expand -group o_port%d -color Blue {/tb_mpcache_top/mpcache_inst/rd_vld[%d]}
# add wave -noupdate -expand -group o_port%d -color Blue {/tb_mpcache_top/mpcache_inst/rd_data[%d]}
# add wave -noupdate -expand -group o_port%d -color Blue {/tb_mpcache_top/mpcache_inst/rd_eop[%d]}
# '''
template = '''
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/arb_sel}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/arb_sel_vld}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_clk}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_data}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_empty}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_nresp}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_ramspace}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_ready}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/i_resp}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_data}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_data_vld}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_eop}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_rd_en}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_req}
add wave -noupdate -expand -group channel_req_%d {/tb_mpcache_top/mpcache_inst/input_port_block[%d]/channel_req_inst/o_sop}
'''


print("start")
for port in range(0,16):
	port = 15-port
	print(template%(port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port,port))