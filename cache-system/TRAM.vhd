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
port ( 	clock	: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;
		Mwe		:	in std_logic;
		tag 	: 	in std_logic_vector(9 downto 0);
		data_out:	out std_logic_vector(2 downto 0)
);
end tram;

architecture behv of tram	 is		

type tag_type is array (7 downto 0) of std_logic_vector(9 downto 0);

signal tag_table : tag_type;

begin
	write: process(clock, rst, Mre, tag)
	begin							-- program to generate the first 15 coeff. of the  equation y(n) = 2x(n) + y(n-1) - y(n-2)	 
		if rst='1' then		-- x=2,3,...,12,13,14, y(0)=1 andy(1)=3.
			tag_table <= (
				0 => "1010101010",
				2 => "1111111111",
				others => "0000000000"
			);
		end if;
			--if (clock'event and clock = '1') then
				--if (Mwe ='1' and Mre = '0') then
					--tmp_ram(conv_integer(address)) <= data_in;
				--end if;
			--end if;
		--end if;
	end process;

    read: process(clock, rst, Mwe, tag)
	begin
		if rst='1' then
			data_out <= "001";
		else
			if (clock'event and clock = '1') then
				for index in 0 to 7 loop
					if tag_table(index) = tag then
						data_out <= std_logic_vector(to_unsigned(index, data_out'length));
					end if;
				end loop;
			end if;
		end if;
	end process;
end behv;