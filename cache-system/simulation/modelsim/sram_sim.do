vsim work.sram

force clock 1 0, 0 100 -r 200 
force rst 1 0, 0 400

quietly WaveActivateNextPane {} 0
add wave clock
add wave rst
add wave Mre
add wave Mwe
add wave word
add wave tag
add wave data_in
add wave data_out


radix -hexadecimal

run 5ns