vsim hkjashldfkjh.work.simplecomparch

force sys_clk 1 0, 0 10 -r 20 
force sys_rst 1 0, 0 45
force mem_clk_en 1
add wave sys_clk
add wave sys_rst
add wave sys_output
add wave mem_clk_en
run 1ns
