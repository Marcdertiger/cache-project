vsim work.simplecomparch

force sys_clk 1 0, 0 1000 -r 2000 
force sys_rst 1 0, 0 8000
force mem_clk_en 1
add wave sys_clk
add wave sys_rst
add wave sys_output
add wave mem_clk_en
add wave D_mem_addr
add wave D_mdout_bus
add wave D_Mre
add wave D_PCld
add wave D_oe

radix -hexadecimal

run 100ns
