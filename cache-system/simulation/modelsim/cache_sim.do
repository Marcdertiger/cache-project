vsim work.cache_controller

force clock 1 0, 0 100 -r 200 
force reset 1 0, 0 400
force clken 1
force mem_read 0
force address 1111111111
add wave clock
add wave mem_read
add wave reset
add wave address
add wave rden
add wave wren
add wave q
add wave D_FIFO_Index
add wave D_TRAM_data_out
add wave D_TRAM_tag 
add wave D_SRAM_output_data
add wave D_current_state 
add wave D_tag_table_0 
add wave D_tag_table_1 
add wave D_tag_table_2 
add wave D_tag_table_3 
add wave D_tag_table_4 
add wave D_tag_table_5 
add wave D_tag_table_6 
add wave D_tag_table_7 

radix -hexadecimal

run 10ns
