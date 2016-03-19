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
		write_to_word : in std_logic;
		write_to_block : in std_logic;
		cache		: buffer cache_type
);
end sram;

architecture behv of sram	 is		

begin
	write: process(clock, rst, Mre, tag, word, data_in)
	begin						
		if rst='1' then
			cache(0)<= (
				0 => x"1010",
				others => x"0001");
			cache(1)<= (
				others => x"0001");
			cache(2)<= (
				others => x"0001");
			cache(3)<= (
				others => x"0001");
			cache(4)<= (
				others => x"0001");
			cache(5)<= (
				others => x"0001");
			cache(6)<= (
				others => x"0001");
			cache(7)<= (
				others => x"0001");

				
--			cache(0) <= ( -- 0d
--				0 => x"3000",
--				1 => x"3101",
--				2 => x"321A",
--				3 => x"3301",others => x"0000");
--			cache(1) <= ( -- 4d
--				0 => x"1018",
--				1 => x"1119",
--				2 => x"111F",
--				3 => x"4100",others => x"0000");
--			cache(2) <= ( -- 8d
--				0 => x"001F",
--				1 => x"2210",
--				2 => x"4230",
--				3 => x"041E",others => x"0000");
--			cache(3) <= ( -- 12d
--				0 => x"6406",
--				1 => x"7018",
--				2 => x"7019",
--				3 => x"701A",others => x"0000");
--			cache(4) <= ( -- 16d
--				0 => x"701B",
--				1 => x"701C",
--				2 => x"701D",
--				3 => x"F000",others => x"0000");
--			cache(5) <= ( -- 20d
--				0 => x"0000",
--				1 => x"0000",
--				2 => x"0000",
--				3 => x"0000",others => x"0000");
--			cache(6) <= ( -- 24d
--				0 => x"0000",
--				1 => x"0000",
--				2 => x"0000",
--				3 => x"0000",others => x"0000");
--			cache(7) <= ( -- 28d
--				0 => x"0000",
--				1 => x"0000",
--				2 => x"0000",
--				3 => x"0000",others => x"0000");
		else
			if (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0' and write_to_word = '1' and write_to_block = '0') then
					cache(conv_integer(tag))(conv_integer(word)) <= data_in;
				elsif (Mwe ='1' and Mre = '0' and write_to_word = '0' and write_to_block = '1') then
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
	
end behv;