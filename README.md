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
