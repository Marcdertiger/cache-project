vsim work.simplecomparch

force sys_clk 1 0, 0 100 -r 200 
force sys_rst 1 0, 0 600

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /simplecomparch/sys_clk
add wave -noupdate /simplecomparch/sys_rst
add wave -noupdate /simplecomparch/mem_clk_en
add wave -noupdate /simplecomparch/sys_output
add wave -noupdate /simplecomparch/D_sys_clk_div
add wave -noupdate /simplecomparch/D_rfout_bus

add wave -noupdate /simplecomparch/D_dirty_bits
add wave -noupdate /simplecomparch/D_main_mem_enable
add wave -noupdate /simplecomparch/D_fifo_index

#add wave -noupdate /simplecomparch/D_RFwa
#add wave -noupdate /simplecomparch/D_RFr1a
#add wave -noupdate /simplecomparch/D_RFr2a
#add wave -noupdate /simplecomparch/D_RFwe
#add wave -noupdate /simplecomparch/D_RFr1e
#add wave -noupdate /simplecomparch/D_RFr2e
#add wave -noupdate /simplecomparch/D_RFs
#add wave -noupdate /simplecomparch/D_ALUs
#add wave -noupdate /simplecomparch/D_PCld
#add wave -noupdate /simplecomparch/D_jpz
add wave -noupdate /simplecomparch/D_oe
add wave -noupdate /simplecomparch/D_mdout_bus
add wave -noupdate /simplecomparch/D_mdin_bus
add wave -noupdate /simplecomparch/D_mem_addr
add wave -noupdate /simplecomparch/D_Mre
add wave -noupdate /simplecomparch/D_Mwe
add wave -noupdate /simplecomparch/D_current_state
add wave -noupdate /simplecomparch/D_cache_controller_state
add wave -noupdate /simplecomparch/D_IR_word
add wave -noupdate /simplecomparch/D_mem_ready
add wave -noupdate /simplecomparch/D_mem_ready_controller
add wave -noupdate /simplecomparch/D_cache_hit
add wave -noupdate /simplecomparch/D_rf_0

add wave -noupdate /simplecomparch/D_tag_table_0
add wave -noupdate /simplecomparch/D_tag_table_1
add wave -noupdate /simplecomparch/D_tag_table_2
add wave -noupdate /simplecomparch/D_tag_table_3
add wave -noupdate /simplecomparch/D_tag_table_4
add wave -noupdate /simplecomparch/D_tag_table_5
add wave -noupdate /simplecomparch/D_tag_table_6
add wave -noupdate /simplecomparch/D_tag_table_7

add wave -noupdate /simplecomparch/D_TRAM_tag

add wave -noupdate /simplecomparch/D_cache0
add wave -noupdate /simplecomparch/D_cache1
add wave -noupdate /simplecomparch/D_cache2
add wave -noupdate /simplecomparch/D_cache3
add wave -noupdate /simplecomparch/D_cache4
add wave -noupdate /simplecomparch/D_cache5
add wave -noupdate /simplecomparch/D_cache6
add wave -noupdate /simplecomparch/D_cache7


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 237
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {6468 ps}

radix -hexadecimal

run 500000ps