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
		data_out:	out std_logic_vector(15 downto 0);
		mem_data_in : in std_logic_vector(63 downto 0);
		cache_hit : in std_logic;
		D_Line0 : out std_logic_vector(63 downto 0);
		D_Line1 : out std_logic_vector(63 downto 0);
		D_Line2 : out std_logic_vector(63 downto 0);
		D_Line3 : out std_logic_vector(63 downto 0)
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
				1 => x"4EE0",
				others => x"0000");
			cache(1) <= (
				others => x"0000");
			cache(2) <= (
				1 => x"8990",
				others => x"0000");
			cache(3) <= (others => x"0000");
			cache(4) <= (others => x"0000");
			cache(5) <= (others => x"0000");
			cache(6) <= (others => x"0000");
			cache(7) <= (others => x"0000");
		else
			if (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0' and cache_hit = '1') then
					cache(conv_integer(tag))(conv_integer(word)) <= data_in;
				elsif (Mwe ='1' and Mre = '0' and cache_hit = '0') then
					-- 
					cache(conv_integer(tag))(0) <= mem_data_in(63 downto 48);
					cache(conv_integer(tag))(1) <= mem_data_in(47 downto 32);
					cache(conv_integer(tag))(2) <= mem_data_in(31 downto 16);
					cache(conv_integer(tag))(3) <= mem_data_in(15 downto 0);
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
	
	D_Line0 <= cache(0)(0) & cache(0)(1) & cache(0)(2) & cache(0)(3);
	D_Line1 <= cache(1)(0) & cache(1)(1) & cache(1)(2) & cache(1)(3);
	D_Line2 <= cache(2)(0) & cache(2)(1) & cache(2)(2) & cache(2)(3);
	D_Line3 <= cache(3)(0) & cache(3)(1) & cache(3)(2) & cache(3)(3);
	
end behv;