vsim work.simplecomparch

force sys_clk 1 0, 0 1000 -r 2000 
force sys_rst 1 0, 0 8000
force mem_clk_en 1
add wave sys_clk
add wave sys_rst
add wave sys_output
add wave sys_clk_div
add wave D_mem_ready
add wave D_mem_addr
add wave D_mdout_bus
add wave D_mdin_bus
add wave D_Mre
add wave D_Mwe
add wave D_PCld
add wave D_oe
add wave D_current_state
add wave D_IR_word
add wave D_rf_0
add wave D_rf_1
add wave D_rf_2
add wave D_rf_3
add wave D_rf_4
add wave D_rf_5
add wave D_rf_6
add wave D_rf_7
add wave D_rf_8
add wave D_ExecTime

radix -hexadecimal

run 100ns
