template = '''
add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/wr_sop[%d]}
add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/wr_eop[%d]}
add wave -noupdate -expand -group port%d -color Magenta -height 15 {/tb_mpcache_top/mpcache_inst/wr_vld[%d]}
add wave -noupdate -expand -group port%d {/tb_mpcache_top/mpcache_inst/rd_data[%d]}
'''

print("start")
for port in range(1,16):
	port = 15-port
	print(template%(port,port,port,port,port,port,port,port))