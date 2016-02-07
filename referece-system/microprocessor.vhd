--------------------------------------------------------
-- Simple Microprocessor Design 
--
-- Microprocessor composed of
-- Ctrl_Unit, Data_Path and Memory
-- structural modeling
-- microprocessor.vhd
--------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;			   
use ieee.std_logic_unsigned.all;
use work.MP_lib.all;

entity microprocessor is
port( cpu_clk					: in std_logic;
		cpu_rst					: in std_logic;
		mdout_bus				: in std_logic_vector(15 downto 0); 
		mdin_bus					: out std_logic_vector(15 downto 0); 
		immd_bus					: out std_logic_vector(15 downto 0);  
		mem_addr					: out std_logic_vector(7 downto 0);
		Mre_s						: out std_logic;
		Mwe_s						: out std_logic;	
		oe_s						: out std_logic;
		cpu_output				: out std_logic_vector(15 downto 0)			
);
end microprocessor;

architecture structure of microprocessor is
																				--	  							 (ORIGIN 	-> DEST)
signal addr_bus				: std_logic_vector(15 downto 0); -- Mem addr. bus 				(BMUX 	-> MEM)
signal rfout_bus				: std_logic_vector(15 downto 0); -- Reg. File output 			(CTRLER	-> BMUX)
signal RFwa_s					: std_logic_vector(3 downto 0);	-- Reg. File write addr.	(CTRLER 	-> RF)
signal RFr1a_s					: std_logic_vector(3 downto 0);	-- Reg. File read addr. p1	(CTRLER 	-> RF)
signal RFr2a_s					: std_logic_vector(3 downto 0);	-- Reg. File read addr. p2	(CTRLER 	-> RF)
signal RFwe_s					: std_logic;							-- Reg. File write enable 	(CTRLER 	-> RF)
signal RFr1e_s					: std_logic;							-- Reg. File read enable p1(CTRLER 	-> RF)
signal RFr2e_s					: std_logic;							-- Reg. File read enable p2(CTRLER 	-> RF)
signal RFs_s					: std_logic_vector(1 downto 0);	-- Reg. File select 			(CTRLER 	-> SMUX)
signal ALUs_s					: std_logic_vector(1 downto 0);	-- ALU select 					(CTRLER 	-> ALU)
signal PCld_s					: std_logic;							-- Program Counter select	(CTRLER 	-> SMUX)
signal jpz_s					: std_logic;							-- Jump check flag			(CTRLER 	-> ALU)

begin
	
	mem_addr <= addr_bus(7 downto 0); 
	
	Unit0: ctrl_unit port map(	cpu_clk,cpu_rst,PCld_s,mdout_bus,rfout_bus,addr_bus,
								immd_bus, RFs_s,RFwa_s,RFr1a_s,RFr2a_s,RFwe_s,
								RFr1e_s,RFr2e_s,jpz_s,ALUs_s,Mre_s,Mwe_s,oe_s);
	Unit1: datapath port map(	cpu_clk,cpu_rst,immd_bus,mdout_bus,
								RFs_s,RFwa_s,RFr1a_s,RFr2a_s,RFwe_s,RFr1e_s,
								RFr2e_s,jpz_s,ALUs_s,oe_s,PCld_s,rfout_bus,
								mdin_bus,cpu_output);
	--Unit2: memory port map(	cpu_clk,cpu_rst,Mre_s,Mwe_s,mem_addr,mdin_bus,mdout_bus);


end structure;
