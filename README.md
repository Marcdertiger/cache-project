# Associative Cache Project for ECE 3242

## Getting Started
This project does not have a quartus qsf file. Therefore we need to reconfigure the Quartus project
to use ModelSim and VHDL, and also change the directory for simulation from simulation/modelsim to ./modelsim

## Reference System

### Creating 1/8 Clock

The clock that drives the memory runs at 1/8 the speed of the system clock, 
and will be called the divided clock. Therefore the VHDL code to slow down
the clock counts from 0 to 3, and then toggles to divided clock.

### Simulating the Divided Clock

A University Waveform file was created that tests the divided clock. 
It is called divided_clock _test_sim.vwf.
To run the simulation you may need to change the simulation from ModelSim 
to Quartus, this option can be found under Simulation>Options in the simulation
editor and then clicking the "Quartus" radio button.

### Getting a Simple Program to Run

With the new M9K memory module it takes one clock cycle longer to read from memory than the memory implemented in memory.vhd. So two new states were added: S1wait, to wait on fetch instruction, and S11wait, to wait for memory output. **The fibonacci program does not work right yet though.** It seems to be the JUMP instruction that isn't working.

### Timing of M9K memory for reading

To read from the m9k memory takes one more clock cycle than it does in the memory of the provided architecture.
![M9K memory](https://raw.githubusercontent.com/davejmurphy/cache-project/master/m9k_sim.PNG?token=AGFDIxUzVx8qfR9N9X3kv4ObQsWfYIE-ks5W6W1TwA%3D%3D)
![Castillos memory](https://raw.githubusercontent.com/davejmurphy/cache-project/master/castillo_mem_sim.PNG?token=AGFDI-Ijfs7xhMDHU0pbmbwHNoPhzm6Cks5W6W0_wA%3D%3D)

### Sources

This source details cache architecture.
http://download.intel.com/design/intarch/papers/cache6.pdf

### Matrix addition program

The program is written asusming we have access to move the value from memory to a register (inverse of MOV3 operation). It also relies on a branch op code that only banches while we have not added all 25 elements of the 5x5 matrices.

mem[0..50] reserved for the program operations.

mem[50..74] matrix 0.

mem[75..99] matrix 1.

mem[100..124] matrix additon result.

Matrices are stored in memory one column after the other. 

### Cache Memory
Have implemented a cache controller interface between the SimpleCompArch and cache memory. 
You can do static read from cache memory.
Current: when program counter points to 000, get F000 (static) from cache memory.
Main memory is NOT included yet.
--WAIT_STATE: can SAVE one clock cycle with customized 
-- states for each wait state.
-- i.e. execute the next_state when count = 1
--		-> no wasted clock cycles

