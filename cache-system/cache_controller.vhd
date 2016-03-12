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
		mem_ready_controller : IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		reset		: IN STD_LOGIC;
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC; --deleted := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rden		: IN STD_LOGIC  := '1';
		wren		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		D_FIFO_Index : out std_logic_vector(2 downto 0);
		
		D_TRAM_data_out : out std_logic_vector(2 downto 0);
		D_TRAM_tag : out std_logic_vector(9 downto 0);
		D_SRAM_output_data : out STD_LOGIC_VECTOR (15 DOWNTO 0);
		D_current_state : out std_logic_vector(3 downto 0);
		
		D_tag_table_0 : out std_logic_vector(9 downto 0);
		D_tag_table_1 : out std_logic_vector(9 downto 0);
		D_tag_table_2 : out std_logic_vector(9 downto 0);
		D_tag_table_3 : out std_logic_vector(9 downto 0);
		D_tag_table_4 : out std_logic_vector(9 downto 0);
		D_tag_table_5 : out std_logic_vector(9 downto 0);
		D_tag_table_6 : out std_logic_vector(9 downto 0);
		D_tag_table_7 : out std_logic_vector(9 downto 0);
		
		mem_ready	: out std_logic
		
	);
END cache_controller;

architecture fsm of cache_controller is

type state_type is ( S0,S1,S2, S3);
  signal state: state_type;
signal TRAM_read : std_logic;
signal TRAM_write : std_logic;
signal TRAM_tag : std_logic_vector(9 downto 0);
signal TRAM_data_out : std_logic_vector(2 downto 0);
signal SRAM_read  : std_logic;
signal SRAM_write  : std_logic;
signal SRAM_word  : std_logic_vector(1 downto 0);
signal current_state : std_logic_vector(3 downto 0);

signal main_memory : std_logic_vector(7 downto 0);

signal SRAM_output_data : STD_LOGIC_VECTOR (15 DOWNTO 0);
signal MAIN_output_data : STD_LOGIC_VECTOR (15 DOWNTO 0);

  
begin

process (clock,reset, address)
begin
	if reset='1' then
		TRAM_read  <= '0';
		TRAM_write <= '0';
		TRAM_tag <= "0000000000";
		state <= S0;
	elsif mem_ready_controller = '0' then
		current_state <= x"0";
		--check if there is a hit or a miss
		--then go to s1 or s2
		--
		mem_ready <= '0';
		
		--read from tag_table in TRAM
		TRAM_read  <= '1';
		TRAM_write <= '0';
		TRAM_tag <= address;
		state <= S1;
		
   elsif (clock'event and clock='1' and mem_ready_controller = '1') then
		case state is 
		when S0 =>
			current_state <= x"0";
			--check if there is a hit or a miss
			--then go to s1 or s2
			--
			mem_ready <= '0';
			
			--read from tag_table in TRAM
			TRAM_read  <= '1';
			TRAM_write <= '0';
			TRAM_tag <= address;
			state <= S1;
			
		when S1 => --there is a hit
			current_state <= x"1";
			SRAM_read  <= '1';
			SRAM_write <= '0';
			SRAM_word  <= "01"; --HARD CODED FOR NOW
			
			--shut off read
			TRAM_read  <= '0';
			TRAM_write <= '0';
			
			state <= S2;
		when S2 =>
			current_state <= x"3";
			
			--shut off read
			SRAM_read  <= '0';
			SRAM_write <= '0';
			mem_ready <= '1';
			state <= S3;
			
		when S3 =>
			q <= SRAM_output_data;
			state <= S0;
			
			
		when others =>
		end case;
	end if;

end process;

Unit1: memory_4KB port map(
	main_memory,
	clken,
	clock,
	data,
	rden,
	wren,
	MAIN_output_data);

Unit2: TRAM port map(
		clock,
		reset,
		TRAM_read,
		TRAM_write,
		TRAM_tag,
		TRAM_data_out,
		D_FIFO_Index,
		D_tag_table_0,
		D_tag_table_1,
		D_tag_table_2,
		D_tag_table_3,
		D_tag_table_4,
		D_tag_table_5,
		D_tag_table_6,
		D_tag_table_7);
	
Unit3: SRAM port map(	
		clock,
		reset,
		SRAM_read,
		SRAM_write,
		SRAM_word,
		TRAM_data_out,
		data,
		SRAM_output_data);
		
		D_TRAM_data_out <= TRAM_data_out;
		D_SRAM_output_data <= SRAM_output_data;
		D_TRAM_tag <= TRAM_tag;
		D_current_state <= current_state;

end fsm;
 
 
 
 