vsim work.m9k_memory

force clock 1 0, 0 1000 -r 2000 
force rden 0 0
force wren 0 0
force address 16#000 0
force data 16#0000 0
add wave clock
add wave rden
add wave wren
add wave address
add wave data
add wave q

radix -hexadecimal

run 1 ns
