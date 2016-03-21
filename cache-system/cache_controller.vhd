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
		pass_control_to_controller : IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
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
		D_cache_controller_state : out std_logic_vector(3 downto 0);
		
		D_tag_table_0 : out std_logic_vector(9 downto 0);
		D_tag_table_1 : out std_logic_vector(9 downto 0);
		D_tag_table_2 : out std_logic_vector(9 downto 0);
		D_tag_table_3 : out std_logic_vector(9 downto 0);
		D_tag_table_4 : out std_logic_vector(9 downto 0);
		D_tag_table_5 : out std_logic_vector(9 downto 0);
		D_tag_table_6 : out std_logic_vector(9 downto 0);
		D_tag_table_7 : out std_logic_vector(9 downto 0);
		
		D_mem_data_out : out std_logic_vector(63 downto 0);
		D_mem_read : out std_logic;
		
		pass_control_to_cache	: out std_logic;
		
		D_cache_hit : out std_logic;
		
		D_Line0 : out std_logic_vector(63 downto 0);
		D_Line1 : out std_logic_vector(63 downto 0);
		D_Line2 : out std_logic_vector(63 downto 0);
		D_Line3 : out std_logic_vector(63 downto 0)
		
	);
END cache_controller;

architecture fsm of cache_controller is

type state_type is ( S0,S1,S2, S_MEM1, S_MEM2);
  signal state: state_type;
signal TRAM_read : std_logic;
signal TRAM_write : std_logic;
signal TRAM_tag : std_logic_vector(9 downto 0);
signal TRAM_data_out : std_logic_vector(2 downto 0);
signal SRAM_read  : std_logic;
signal SRAM_write  : std_logic;
signal SRAM_word  : std_logic_vector(1 downto 0);
signal SRAM_output_data : STD_LOGIC_VECTOR (15 DOWNTO 0);

signal cache_controller_state : std_logic_vector(3 downto 0);

signal MAIN_read  :  std_logic;
signal MAIN_write : std_logic;

signal MAIN_output_data : STD_LOGIC_VECTOR (63 DOWNTO 0);
signal MAIN_input_data : STD_LOGIC_VECTOR (63 DOWNTO 0);

signal cache_hit  : std_logic;
signal write_to_word : std_logic;
signal write_to_block : std_logic;

signal cache_line0 : std_logic_vector(63 downto 0);
signal cache_line1 : std_logic_vector(63 downto 0);
signal cache_line2 : std_logic_vector(63 downto 0);
signal cache_line3 : std_logic_vector(63 downto 0);
  
begin

process (clock, reset, address)
begin
	SRAM_word <= address(1 downto 0);
	TRAM_tag <= address(11 downto 2);
	if reset='1' then
		TRAM_read  <= '0';
		TRAM_write <= '0';
		TRAM_tag <= address(11 downto 2);
		state <= S0;
		write_to_word <= '0';
		write_to_block <= '0';
		
	elsif pass_control_to_controller = '0' then
		cache_controller_state <= x"F";
		state <= S0;
		
   elsif (clock'event and clock='1' and pass_control_to_controller = '1') then
		case state is 
			when S0 =>
				cache_controller_state <= x"0";			
				pass_control_to_cache <= '0';
				
				MAIN_read <= '0';
				
				-- Clear SRAM write;
				SRAM_write <= '0';
				write_to_word <= '0';
				write_to_block <= '0';
				
				--read from tag_table in TRAM
				TRAM_read  <= '1';
				TRAM_write <= '0';
				state <= S1;
				
			--delay to account for writing to memory
			-- with instruction mov2
				
			when S1 =>
				
				--CHECK cache miss or hit
				if (cache_hit = '1') then
				--on cache HIT
				
					TRAM_read  <= '0';
					TRAM_write <= '0';
					--read
					if(rden = '1' and wren = '0') then
						cache_controller_state <= x"1";
						SRAM_read  <= '1';
						SRAM_write <= '0';
						SRAM_word  <= address(1 downto 0);
					
					elsif(rden = '0' and wren = '1') then
						cache_controller_state <= x"2";
						SRAM_read  <= '0';
						SRAM_write <= '1';
						write_to_word <= '1';
						write_to_block <= '0';
						SRAM_word  <= address(1 downto 0);
					end if;
					
					
					state <= S2;
				--end HIT
				else			
					--cache MISS
					cache_controller_state <= x"B";
					MAIN_read <= '1'; -- read memory
					MAIN_write <= '0';
					
					-- To write back
					-- (We need to add a 'dirty' bit to the indexes of the tag)
					-- if (dirty = '1')
					-- 	Get old tag from TRAM
					-- 	Get old data from SRAM
					-- 	Write SRAM data to TRAM's tag address in Main memory
					-- 	Read new tag (address) from memory
					-- else
					--		Read new tag (address) from memory
					
					-- To optimize:
					-- (create a new process that operates on the 'write_back_flag')
					-- Read new tag (address) from memory
					-- pass back control to 'controller'
					-- while this is happening, 
					-- 	'cache-controller': write back to memory.
					-- 	have a 'write_back_flag' in S0 that says when 'memory' is not writing
					
					-- Write to TRAM;
					TRAM_write <= '1';
					TRAM_read <= '0';
					 
					state <= S_MEM1;
				--end MISS
				end if;
						
			when S2 =>
				cache_controller_state <= x"2";
				
				--shut off read
				SRAM_read  <= '0';
				SRAM_write <= '0';
				
				pass_control_to_cache <= '1';
				state <= S0;
				
			when S_MEM1 =>
				-- Clear TRAM controls;
				TRAM_write <= '0';
				TRAM_read <= '0';
				cache_controller_state <= x"C";
				state <= S_MEM2;
				
			when S_MEM2 =>
				cache_controller_state <= x"D";
					
				--Write to SRAM;
				SRAM_write <= '1';
				SRAM_read <= '0';
				write_to_word <= '0';
				write_to_block <= '1';
	
				
				
				state <= S0;				
			when others =>
		end case;
	end if;

end process;

Unit1: memory_4KB port map(
	address(11 downto 2),
	'1',
	clock,
	MAIN_input_data,
	MAIN_read,
	MAIN_write,
	MAIN_output_data);

Unit2: TRAM port map(
		clock,
		reset,
		--TRAM_read,
		'1',	-- forcing to 1 to always read TRAM tag from address line
		TRAM_write,
		TRAM_tag,
		TRAM_data_out,
		cache_hit,
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
		q,
		MAIN_output_data,
		write_to_word,
		write_to_block,
		cache_line0,
		cache_line1,
		cache_line2,
		cache_line3);
		
		D_TRAM_data_out <= TRAM_data_out;
		D_SRAM_output_data <= SRAM_output_data;
		D_TRAM_tag <= TRAM_tag;
		D_cache_controller_state <= cache_controller_state;
		D_cache_hit <= cache_hit;
		D_mem_data_out <= MAIN_output_data;
		D_mem_read <= MAIN_read;
		
		D_Line0 <= cache_line0;
		D_Line1 <= cache_line1;
		D_Line2 <= cache_line2;
		D_Line3 <= cache_line3;
end fsm;
 
 
 
 