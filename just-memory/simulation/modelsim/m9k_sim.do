vsim work.m9k_memory

force address 16#000
force data 16#0000
force wren 0 0
force rden 0 0
force clock 1 0, 0 10 -r 20 
force address 16#001 20
force data 16#5567 40
force wren 0 600

force wren 0 260

force address 16#005 600
force rden 1 500


add wave clock
add wave rden
add wave q
add wave address
add wave data
add wave wren

run 1ns
