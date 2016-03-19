-- TRAM 

-- Memory where the tag of each line is stored

-- Has a two way port to the Cache Controller (read and write) ********** 

-- 8 tag length (to match number of lines in cache) 

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
		TRAM_read		:	in std_logic;
		TRAM_write		:	in std_logic;
		tag 		: 	in std_logic_vector(9 downto 0);
		data_out :	out std_logic_vector(2 downto 0);
		
		cache_hit : buffer std_logic;
		
		FIFO_Index : in integer;
		
		D_FIFO_Index : out std_logic_vector(2 downto 0);
		
		tag_table : buffer tag_type
);
end tram;

architecture behv of tram	 is		

begin
	write: process(clock, rst, TRAM_read, tag)
	begin							
		if rst='1' then		
			tag_table <= (

--				0 => "0000000000",
--				1 => "0000000001",
--				2 => "0000000010",
--				3 => "0000000011",
--				4 => "0000000100",
--				5 => "0000000101",
--				6 => "0000000110",
--				7 => "0000000111",
				others => "1111111100"
			);
		elsif (clock'event and clock = '1') then
				--if (TRAM_write ='1' and TRAM_read = '0') then
				if (TRAM_write ='1') then
					tag_table(FIFO_Index) <= tag;
				end if;
		end if;
	end process;

   read: process(clock, rst, TRAM_write, tag)
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
	
	D_FIFO_Index <= std_logic_vector(to_unsigned(FIFO_Index, D_FIFO_Index'length));

	
end behv;