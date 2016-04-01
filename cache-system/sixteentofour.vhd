-------------------------------------------------------------------------------------------------
--                 Bin_7S_case.vhd						     ---
-- Binary-to-7-segment converter.						     ---
-- Positive logic input								     ---
-- Negative logic output to cope with 7S Altera board.			     ---
-- Developed by E.C.G.           				    25/07/2006    ---
-------------------------------------------------------------------------------------------------
LIBRARY ieee ;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
entity sixteentofour is
  port( 
		  hexdat     	: in  std_logic_vector(15 downto 0);
        thousands 	: out std_logic_vector(3 downto 0);
		  hundreds 		: out std_logic_vector(3 downto 0);
		  tens			: out std_logic_vector(3 downto 0);
        ones 			: out std_logic_vector(3 downto 0)
);end sixteentofour;

architecture sixteendivfour_logic of sixteentofour is

	signal temp					: std_logic_vector(15 downto 0);
	begin
		temp <= hexdat;
		thousands <= temp(15 downto 12);
		hundreds <= temp(11 downto 8);
		tens <= temp(7 downto 4);
		ones <= temp(3 downto 0);
end sixteendivfour_logic;