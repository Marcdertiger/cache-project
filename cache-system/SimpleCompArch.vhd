------------------------------------------------------------------
-- Simple Computer Architecture
--
-- System composed of
-- 	CPU, Memory and output buffer
--    Sinals with the prefix "D_" are set for Debugging purpose only
-- SimpleCompArch.vhd
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;			   
use work.MP_lib.all; 

entity SimpleCompArch is
port( sys_clk							:	in std_logic;
		sys_rst							:	in std_logic;
		mem_clk_en						: 	in std_logic;
		sys_output						:	out std_logic_vector(15 downto 0);
		sys_clk_div						: 	buffer std_logic;
		
		-- Debug signals from CPU: output for simulation purpose only	
		D_rfout_bus									: out std_logic_vector(15 downto 0);  
		D_RFwa, D_RFr1a, D_RFr2a				: out std_logic_vector(3 downto 0);
		D_RFwe, D_RFr1e, D_RFr2e				: out std_logic;
		D_RFs, D_ALUs								: out std_logic_vector(1 downto 0);
		D_PCld, D_jpz								: out std_logic;
		D_oe											: out std_logic;
		-- end debug variables	

		-- Debug signals from Memory: output for simulation purpose only	
		D_mdout_bus,D_mdin_bus					: out std_logic_vector(15 downto 0); 
		D_mem_addr									: out std_logic_vector(11 downto 0); 
		D_Mre,D_Mwe									: out std_logic;
		D_current_state							: out std_logic_vector(7 downto 0);
		D_IR_word									: out std_logic_vector(15 downto 0)

		-- end debug variables	
);
end SimpleCompArch;

architecture rtl of SimpleCompArch is
--Memory local variables												  							        							(ORIGIN	-> DEST)
	signal mdout_bus					: std_logic_vector(15 downto 0);  -- Mem data output 		(MEM  	-> CTLU)
	signal mdin_bus					: std_logic_vector(15 downto 0);  -- Mem data bus input 	(CTRLER	-> Mem)
	signal mem_addr					: std_logic_vector(7 downto 0);   -- Const. operand addr.(CTRLER	-> MEM)
	signal Mre								: std_logic;							 			 -- Mem. read enable  	(CTRLER	-> Mem) 
	signal Mwe								: std_logic;							 			 -- Mem. write enable 	(CTRLER	-> Mem)
	signal mem_address_cheat : std_logic_vector(11 downto 0);
	signal current_state			: std_logic_vector(7 downto 0);
	signal IR_word				:	std_logic_vector(15 downto 0);
	signal mem_ready: 	std_logic;
	--System local variables
	signal oe							: std_logic;
	
	-- Counts to 8 to divide system clock
	signal count : integer:=0;
	
	begin
	mem_address_cheat <= x"0" & mem_addr;
	
	process (sys_clk, sys_rst) begin
		if (sys_rst = '1') then
			count <= 0;
			sys_clk_div <= '0';
		elsif (rising_edge(sys_clk)) then
			count <= count + 1;
			if (count = 3) then 
				sys_clk_div <= NOT sys_clk_div;
				count <= 0;
			end if;
		end if;
	end process;

Unit1: CPU port map (
	sys_clk,
	mem_ready,
	sys_rst,
	mdout_bus,
	mdin_bus,
	mem_addr,
	Mre,
	Mwe,
	oe,
	current_state,
	IR_word,
	D_rfout_bus,D_RFwa, D_RFr1a, D_RFr2a,D_RFwe, 			 				--Degug signals
	D_RFr1e, D_RFr2e,D_RFs, D_ALUs,D_PCld, D_jpz);	 						--Degug signals
																					
Unit2: cache_controller port map(
	mem_ready,
	mem_addr,
	sys_rst,
	mem_clk_en,
	sys_clk,
	mdin_bus,
	Mre,
	Mwe,
	mdout_bus);
																					
Unit3: obuf port map(oe, mdout_bus, sys_output);

-- Debug signals: output to upper level for simulation purpose only
	D_oe <= oe;
	D_mdout_bus <= mdout_bus;	
	D_mdin_bus <= mdin_bus;
	D_mem_addr <= mem_address_cheat; 
	D_Mre <= Mre;
	D_Mwe <= Mwe;
	D_current_state <= current_state;
	D_IR_word <= IR_word;
-- end debug variables		
		
end rtl;