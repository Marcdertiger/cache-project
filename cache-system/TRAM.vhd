-- TRAM 

-- Memory where the tag of each line is stored

-- Has a two way port to the Cache Controller (read and write) ********** 

-- 8 tag lenght (to match number of lines in cache) 

--------------------------------------------------------
-- Simple Computer Architecture
--
-- sram 256*16
-- 8 bit address; 16 bit data
-- sram.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  
use ieee.numeric_std.all;
use work.MP_lib.all;

entity tram is
port ( 	
		clock		: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;
		Mwe		:	in std_logic;
		tag 		: 	in std_logic_vector(9 downto 0);
		data_out :	out std_logic_vector(2 downto 0);
		
		cache_hit : buffer std_logic;
		
		D_FIFO_Index : out std_logic_vector(2 downto 0);
		
		D_tag_table_0 : out std_logic_vector(9 downto 0);
		D_tag_table_1 : out std_logic_vector(9 downto 0);
		D_tag_table_2 : out std_logic_vector(9 downto 0);
		D_tag_table_3 : out std_logic_vector(9 downto 0);
		D_tag_table_4 : out std_logic_vector(9 downto 0);
		D_tag_table_5 : out std_logic_vector(9 downto 0);
		D_tag_table_6 : out std_logic_vector(9 downto 0);
		D_tag_table_7 : out std_logic_vector(9 downto 0)
);
end tram;

architecture behv of tram	 is		

type tag_type is array (7 downto 0) of std_logic_vector(9 downto 0);

signal tag_table : tag_type;
signal FIFO_Index : integer := 0;

begin
	write: process(clock, rst, Mre, tag)
	begin							
		if rst='1' then		
			tag_table <= (
				0 => "0000000010",
				2 => "1111111111",
				7 => "1100110001",
				others => "0000000001"
			);
			FIFO_Index <= 0;
		elsif (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0') then
					if (FIFO_Index = 8) then 
						tag_table(0) <= tag;
						FIFO_Index <= 1;
					else 
						tag_table(FIFO_Index) <= tag;
						FIFO_Index <= FIFO_Index + 1;						
					end if;
				end if;
		end if;
	end process;

   read: process(clock, rst, Mwe, tag)
	begin
		if rst='1' then
			data_out <= "001";
		else
			if (clock'event and clock = '1') then
				cache_hit <= '0';
				for index in 0 to 7 loop
					if tag_table(index) = tag then
						data_out <= std_logic_vector(to_unsigned(index, data_out'length));
						cache_hit <= '1';
					end if;
				end loop;				
			end if;
		end if;		
	end process;
	
--	cache_hit_process: process(clock, cache_hit)
--	begin
--		if (clock'event and clock = '1' and cache_hit = '1') then
--			cache_hit <= '0';
--		end if;		
--	end process;
	
	D_FIFO_Index <= std_logic_vector(to_unsigned(FIFO_Index, D_FIFO_Index'length));
	
	D_tag_table_0 <= tag_table(0);
	D_tag_table_1 <= tag_table(1);
	D_tag_table_2 <= tag_table(2);
	D_tag_table_3 <= tag_table(3);
	D_tag_table_4 <= tag_table(4);
	D_tag_table_5 <= tag_table(5);
	D_tag_table_6 <= tag_table(6);
	D_tag_table_7 <= tag_table(7);
	
end behv;