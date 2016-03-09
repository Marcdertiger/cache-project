vsim work.memory

force clock 1 0, 0 1000 -r 2000 
force rst 1 0, 0 8000
force Mre 0 0
force Mwe 0 0
force address 16#00 0
force data_in 16#0000 0
add wave clock
add wave rst
add wave Mre
add wave Mwe
add wave address
add wave data_in
add wave data_out

radix -hexadecimal

run 1 ns
