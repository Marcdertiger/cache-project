---- Cache Controller
--
---- Replacement policy : write back
---- Architecture		 : Look through architecture
--
---- Has an input signals from the cpu
---- Has an output signals to the system (where appropriate to communicate to the main memory)
---- Has two port access to SRAM and TRAM**********
--
---- TRAM: where the tag of the cached lines are found
---- SRAM: cached memory
--
---- needs to do : 
----		1. takes in address from cpu and checks if tag is in it.
----		2. HIT	: tag is in TRAM -> respond to cpu request without starting main memory access.
----			MISS	: Cache passes the bus cycle onto system bus
----					 -Main memory responds to cpu request ( to the cache controller)
----					 -CC takes info from data line and saves it in SRAM and TRAM.
--
--
library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;			   
use work.MP_lib.all; 

ENTITY cache_controller IS
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC; --deleted := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)	
		
	);
END cache_controller;

architecture fsm of cache_controller is

type state_type is ( S0,S1);
  signal state: state_type;
  
  
begin
 
 
 
--	--process (clock, enable?, address)
-- 
-- 
-- 
--	when S0 ->
--		--check if there is a hit or a miss
--		--then go to s1 or s2 
--		
--		
--	when S1 -> there is a hit
--
--
--
--	when S2 -> no hit
--
--
--	end process

Unit1: memory_4KB port map(
	address,
	clken,
	clock,
	data,
	rden,
	wren,
	q);

end fsm;
 
 
 
 