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
use ieee.std_logic_unsigned.all;   			   
use work.MP_lib.all; 

ENTITY cache_controller IS
	PORT
	(
		mem_ready_controller : IN STD_LOGIC;
		address	: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		reset		: IN STD_LOGIC;
		clken		: IN STD_LOGIC  := '1';
		clock		: IN STD_LOGIC; --deleted := '1';
		D_sys_clk_div : OUT std_logic;
		D_MAIN_mem_enable : OUT std_logic;
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
		
		D_cache : out cache_type;
		
		D_mem_data_out : out std_logic_vector(63 downto 0);
		D_mem_read : out std_logic;
		
		mem_ready	: out std_logic;
		
		D_cache_hit : out std_logic;
		
		D_dirty_bit : out std_logic_vector(7 downto 0)
		
		
	);
END cache_controller;

architecture fsm of cache_controller is

type state_type is ( S0,S1,S2, S_MEM1, S_mem1b, S_MEM2, MAIN_WRITE_STATE, main_write_state_b);
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

signal main_mem_address : std_logic_vector(9 downto 0);

-- The location of the next write to TRAM.
signal FIFO_Index : integer := 0;

-- Dirty bits
signal dirty_bits : std_logic_vector(7 downto 0);

-- The cache that is managed in SRAM
signal cache : cache_type;

-- The TRAM tag table
signal tag_table : tag_type;

signal sys_clk_div		: std_logic;
signal MAIN_mem_enable : std_logic;

signal count : integer := 0;

signal main_mem_ready : std_logic;

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
		FIFO_Index <= 0;
		MAIN_mem_enable <= '0';
		
	elsif mem_ready_controller = '0' then
		cache_controller_state <= x"F";
		state <= S0;
		
   elsif (clock'event and clock='1' and mem_ready_controller = '1') then
		case state is 
			when S0 =>
				cache_controller_state <= x"0";			
				mem_ready <= '0';
				
				main_mem_address <= address(11 downto 2);
				MAIN_read <= '0';
				
				-- Clear SRAM write;
				SRAM_write <= '0';
				write_to_word <= '0';
				write_to_block <= '0';
				
				--read from tag_table in TRAM
				TRAM_read  <= '1';
				TRAM_write <= '0';
				state <= S1;
				
				MAIN_mem_enable <= '0';
				
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
						dirty_bits(conv_integer(TRAM_data_out)) <= '1';
					end if;
										
					state <= S2;
				--end HIT
				else			
					--cache MISS
					
					MAIN_mem_enable <= '1';
					
					-- To write back
					-- (We need to add a 'dirty' bit to the indexes of the tag)
					-- if (dirty = '1')
					-- 	Get old tag from FIFO_Index
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
					
					
					--WRITE to MAIN memory on cache miss and dirty bit set.
					if(dirty_bits(FIFO_Index) = '1') then
						-- This is the memory address of the data being written back from
						-- the cache.
						cache_controller_state <= x"4";
						main_mem_address <= tag_table(FIFO_Index);
						MAIN_input_data <= cache(FIFO_Index)(0) & cache(FIFO_Index)(1) & cache(FIFO_Index)(2) & cache(FIFO_Index)(3);
						MAIN_write <= '1';
						MAIN_read <= '0';						
						dirty_bits(FIFO_Index) <= '0';
						
						state <= MAIN_WRITE_STATE;
						
					else 
						cache_controller_state <= x"5";
						--READ from MAIN memory on cache miss
						MAIN_read <= '1'; -- read memory
						MAIN_write <= '0';
						-- Write to TRAM;
						TRAM_write <= '1';
						TRAM_read <= '0';
						
						dirty_bits(FIFO_Index) <= '0';
										 
						state <= S_MEM1;
					end if;
					
				--end MISS
				end if;
						
			when S2 =>
				cache_controller_state <= x"2";
				
				--shut off read
				SRAM_read  <= '0';
				SRAM_write <= '0';
				
				mem_ready <= '1';
				state <= S0;
				
			when S_MEM1 =>
				cache_controller_state <= x"6";
				-- Clear TRAM controls;
				TRAM_write <= '0';
				TRAM_read <= '0';
				
				if(main_mem_ready = '0') then
					state <= S_MEM1;
				else
					cache_controller_state <= x"7";
					state <= S_mem1b;
				end if;
			
			when S_mem1b =>
				cache_controller_state <= x"8";
				if(main_mem_ready = '0') then
					state <= S_mem1b;
				else 
					cache_controller_state <= x"C";
					-- Increment the FIFO Index after a write
					if (FIFO_Index = 3) then 
						FIFO_Index <= 0;
					else 
						FIFO_Index <= FIFO_Index + 1;		
					end if;
					state <= S_MEM2;
				end if;
				
			when S_MEM2 =>
				cache_controller_state <= x"D";
					
				--Write to SRAM;
				SRAM_write <= '1';
				SRAM_read <= '0';
				write_to_word <= '0';
				write_to_block <= '1';	
				
				state <= S0;	
			
			when MAIN_WRITE_STATE =>
				cache_controller_state <= x"A";
				if(main_mem_ready = '0') then
					state <= MAIN_WRITE_STATE;
				else
					cache_controller_state <= x"B";
					state <= main_write_state_b;
				end if;
				
			when main_write_state_b =>
				cache_controller_state <= x"C";
				if(main_mem_ready = '0') then
					state <= main_write_state_b;
				else
					cache_controller_state <= x"D";
					MAIN_write <= '0';
					MAIN_read <= '0';
					state <= S0;
				end if;
				
			when others =>
		end case;
	end if;

end process;

--process (clock, MAIN_mem_enable) begin
--	if (MAIN_mem_enable = '0') then
--		count <= 0;
--		sys_clk_div <= '0';
--	elsif (rising_edge(clock) and MAIN_mem_enable = '1') then
--			count <= count + 1;
--			if (count = 3) then 
--				sys_clk_div <= NOT sys_clk_div;
--				count <= 0;
--				if (sys_clk_div = '0') then
--					main_mem_ready <= '1';
--				end if;
--			end if;
--	end if;
--end process;
process (clock, reset) begin
	if (reset = '1') then
		count <= 0;
		sys_clk_div <= '0';
	elsif (rising_edge(clock)) then
		main_mem_ready <= '0';
		count <= count + 1;
		if (count = 3) then 
			sys_clk_div <= NOT sys_clk_div;
			count <= 0;
			if (sys_clk_div = '0') then
				main_mem_ready <= '1';
			end if;
		end if;
	end if;
end process;

Unit1: memory_4KB port map(
	main_mem_address,
	'1',
	sys_clk_div,
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
		FIFO_Index,
		D_FIFO_Index,
		tag_table
		);
	
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
		cache
		);
		
		D_TRAM_data_out <= TRAM_data_out;
		D_SRAM_output_data <= SRAM_output_data;
		D_TRAM_tag <= TRAM_tag;
		D_cache_controller_state <= cache_controller_state;
		D_cache_hit <= cache_hit;
		D_mem_data_out <= MAIN_output_data;
		D_mem_read <= MAIN_read;
	
		
		D_cache <= cache;
			D_tag_table_0 <= tag_table(0);
	D_tag_table_1 <= tag_table(1);
	D_tag_table_2 <= tag_table(2);
	D_tag_table_3 <= tag_table(3);
	D_tag_table_4 <= tag_table(4);
	D_tag_table_5 <= tag_table(5);
	D_tag_table_6 <= tag_table(6);
	D_tag_table_7 <= tag_table(7);
	
	D_MAIN_mem_enable <= MAIN_MEm_enable;
	D_sys_clk_div <= sys_clk_div;
end fsm;
 
 
 
 