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
use work.MP_lib.all;

entity sram is
port ( 	
		clock	: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;
		Mwe		:	in std_logic;
		word	:	in std_logic_vector(1 downto 0);
		tag 	: 	in std_logic_vector(2 downto 0);
		data_in	:	in std_logic_vector(15 downto 0);
		data_out:	out std_logic_vector(15 downto 0)
);
end sram;

architecture behv of sram	 is		

type cache_line is array (3 downto 0) of std_logic_vector(15 downto 0);
type cache_type is array (7 downto 0) of cache_line;

signal cache : cache_type;

begin
	write: process(clock, rst, Mre, tag, word, data_in)
	begin						
		if rst='1' then		
			cache(0) <= (
				1 => x"5678",
				others => x"0000");
			cache(1) <= (others => x"0000");
			cache(2) <= (
				1 => x"1FEB",
				others => x"0000");
			cache(3) <= (others => x"0000");
			cache(4) <= (others => x"0000");
			cache(5) <= (others => x"0000");
			cache(6) <= (others => x"0000");
			cache(7) <= (others => x"0000");
		else
			if (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0') then
					cache(conv_integer(tag))(conv_integer(word)) <= data_in;
				end if;
			end if;
		end if;
	end process;

    read: process(clock, rst, Mwe, tag, word)
	begin
		if rst='1' then
			data_out <= ZERO;
		else
			if (clock'event and clock = '1') then
				if (Mre ='1' and Mwe ='0') then								 
					data_out <= cache(conv_integer(tag))(conv_integer(word));
				end if;
			end if;
		end if;
	end process;
end behv;