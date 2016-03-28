vsim work.simplecomparch_qii_14

force cpu_clk 1 0, 0 1000 -r 2000 
force cpu_rst 0 0, 1 8000
add wave output_button
add wave cpu_clk
add wave cpu_rst
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

add wave D_ExecTime

radix -hexadecimal

run 100ns
