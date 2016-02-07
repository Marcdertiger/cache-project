--------------------------------------------------------
-- SSimple Computer Architecture
--
-- memory 256*16
-- 8 bit address; 16 bit data
-- memory.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;   
use work.MP_lib.all;

entity memory is
port ( 	clock	: 	in std_logic;
		rst		: 	in std_logic;
		Mre		:	in std_logic;
		Mwe		:	in std_logic;
		address	:	in std_logic_vector(7 downto 0);
		data_in	:	in std_logic_vector(15 downto 0);
		data_out:	out std_logic_vector(15 downto 0)
);
end memory;

architecture behv of memory	 is			

type ram_type is array (0 to 255) of std_logic_vector(15 downto 0);
signal tmp_ram: ram_type;
begin
	write: process(clock, rst, Mre, address, data_in)
	begin							-- program to generate the first 15 coeff. of the  equation y(n) = 2x(n) + y(n-1) - y(n-2)	 
		if rst='1' then		-- x=2,3,...,12,13,14, y(0)=1 andy(1)=3.
			tmp_ram <= (
						0 => x"3002",	   	-- R0 <- #2			-> x(2)=2
						1 => x"3101",			-- R1 <- #1			-> to increment by 1 and y(0) - 1
						2 => x"3203",			-- R2 <- #3			-> y(1) = 3
						3 => x"3352",			-- R3 <- #52		   -> pointer to mem. location of 1st calculated coeff.
						4 => x"3401",			-- R4 <- #1			-> to increment by 1
						5 => x"1150",			-- M[50] <- R1 	-> M[50]=1
						6 => x"1251",			-- M[51] <- R2 	-> M[51]=3
						7 => x"1070",         -- M[70] <- R0		-> temp storage of x(n)
						8 => x"0570",         -- R5<- M[70]    	-> R5=R0
						9 => x"4500",			-- R5<- R5+R0		-> R5=2*R0  (2x)
						10 => x"4520",			-- R5<- R5+R2		-> R5=R5+R2  (2x+y(n-1))
						11 => x"5510",			-- R5<- R5-R1		-> R5=R5-R1  (2x+y(n-1)-y(n-2))
						12 => x"2350",			-- M[R3]<-R5		-> M[R3] = y(n)
						13 => x"4340",			-- R3<-R3+R4		-> R3=R3+1
						14 => x"1271",			-- M[71] <- R2		-> temp storage of x(n)
						15 => x"1572",			-- M[72] <- R5		-> temp storage of x(n)
						16 => x"0171",			-- R1<- M[71]    	-> R1=y(n-2)
						17 => x"0272",			-- R2<- M[72]    	-> R2=y(n-1)
						18 => x"4040",			-- R0<- R0+R4		-> R0=R0+1   (x(n+1))
						19 => x"065E",			-- R6 <- M[5E]		-> R6<- M[5E]   (y(14))
						20 => x"6607",  		-- R6=0: PC<- #7 ->loop if R6=0	
				
						21 => x"7050",			-- output<- M[50]   mov obuf_out,M[50]
						22 => x"7051",			-- output<- M[51]   mov obuf_out,M[51]
						23 => x"7052",			-- output<- M[52]   mov obuf_out,M[52]
						24 => x"7053",			-- output<- M[53]   mov obuf_out,M[53]
						25 => x"7054",			-- output<- M[54]   mov obuf_out,M[54]
						26 => x"7055",			-- output<- M[55]   mov obuf_out,M[55]
						27 => x"7056",			-- output<- M[56]   mov obuf_out,M[56]
						28 => x"7057",			-- output<- M[57]   mov obuf_out,M[57]
						29 => x"7058",			-- output<- M[58]   mov obuf_out,M[58]
						30 => x"7059",			-- output<- M[59]   mov obuf_out,M[59]			
						31 => x"705A",			-- output<- M[5A]   mov obuf_out,M[59]			
						32 => x"705B",			-- output<- M[5B]   mov obuf_out,M[59]			
						33 => x"705C",			-- output<- M[5C]   mov obuf_out,M[59]			
						34 => x"705D",			-- output<- M[5D]   mov obuf_out,M[59]			
						35 => x"705E",			-- output<- M[5E]   mov obuf_out,M[59]			
						36 => x"F000",			-- halt
						others => x"0000");
		else
			if (clock'event and clock = '1') then
				if (Mwe ='1' and Mre = '0') then
					tmp_ram(conv_integer(address)) <= data_in;
				end if;
			end if;
		end if;
	end process;

    read: process(clock, rst, Mwe, address)
	begin
		if rst='1' then
			data_out <= ZERO;
		else
			if (clock'event and clock = '1') then
				if (Mre ='1' and Mwe ='0') then								 
					data_out <= tmp_ram(conv_integer(address));
				end if;
			end if;
		end if;
	end process;
end behv;