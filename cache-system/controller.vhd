----------------------------------------------------------------------------
-- Simple Microprocessor Design (ESD Book Chapter 3)
-- Copyright 2001 Weijun Zhang
--
-- Controller (control logic plus state register)
-- VHDL FSM modeling
-- controller.vhd
----------------------------------------------------------------------------

library	ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.MP_lib.all;

entity controller is
port(	clock:		in std_logic;
	pass_control_to_controller	:in std_logic;
	rst:		in std_logic;
	IR_word:	in std_logic_vector(15 downto 0);
	RFs_ctrl:	out std_logic_vector(1 downto 0);
	RFwa_ctrl:	out std_logic_vector(3 downto 0);
	RFr1a_ctrl:	out std_logic_vector(3 downto 0);
	RFr2a_ctrl:	out std_logic_vector(3 downto 0);
	RFwe_ctrl:	out std_logic;
	RFr1e_ctrl:	out std_logic;
	RFr2e_ctrl:	out std_logic;						 
	ALUs_ctrl:	out std_logic_vector(1 downto 0);	 
	jmpen_ctrl:	out std_logic;
	PCinc_ctrl:	out std_logic;
	PCclr_ctrl:	out std_logic;
	IRld_ctrl:	out std_logic;
	Ms_ctrl:	out std_logic_vector(1 downto 0);
	Mre_ctrl:	out std_logic;
	Mwe_ctrl:	out std_logic;
	oe_ctrl:	out std_logic;
	current_state : out std_logic_vector(7 downto 0);
	pass_control_to_cache: 	out std_logic
);
end controller;

architecture fsm of controller is

  type state_type is (  S0,S1,S1a,S1b,S2,S3,S3a,S3b,S4,S4a,S4b,S5,S5a,S5b,
			S6,S6a,S7,S7a,S7b,S8,S8a,S8b,S9,S9a,S9b,S10,S11,S11a,S12,S12a,S12b,S13,S13a,S13b,WAIT_STATE);
  signal state: state_type;
	signal next_state: state_type;
	signal count : integer:=0;
begin
  process(clock, rst, IR_word)
    variable OPCODE: std_logic_vector(3 downto 0);
  begin
    if rst='1' then			   
	Ms_ctrl <= "10";
  	PCclr_ctrl <= '1';		  	-- Reset State
	PCinc_ctrl <= '0';
	IRld_ctrl <= '0';
	RFs_ctrl <= "00";		
	Rfwe_ctrl <= '0';
	Mre_ctrl <= '0';
	Mwe_ctrl <= '0';					
	jmpen_ctrl <= '0';		
	oe_ctrl <= '0';
	state <= S0;

    elsif (clock'event and clock='1') then
	case state is 
	  when S0 =>	PCclr_ctrl <= '0';	-- Reset State	
			current_state <= x"00";
			state <= S1;	

	  when S1 =>	PCinc_ctrl <= '0';
			current_state <= x"01"; 
			IRld_ctrl <= '1'; -- Fetch Instruction
			Mre_ctrl <= '1';
			RFwe_ctrl <= '0';
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			Ms_ctrl <= "10";
			Mwe_ctrl <= '0';
			jmpen_ctrl <= '0';
			oe_ctrl <= '0';
			next_state <= S1a;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
		when S1a => 
			current_state <= x"A1";
	      IRld_ctrl <= '0';
	      PCinc_ctrl <= '1';
	      Mre_ctrl <= '0';
	  		state <= S1b;			-- Fetch end ...
	  when S1b => PCinc_ctrl <= '0';
			current_state <= x"B1";
		   state <= S2;
	  				
	  when S2 =>
				current_state <= x"02";
				OPCODE := IR_word(15 downto 12);
			  case OPCODE is
			    when mov1 => 	state <= S3;
			    when mov2 => 	state <= S4;
			    when mov3 => 	state <= S5;
			    when mov4 => 	state <= S6;
			    when add =>  	state <= S7;
			    when subt =>	state <= S8;
			    when jz =>		state <= S9;
			    when halt =>	state <= S10; 
			    when readm => 	state <= S11;
			    when others => 	state <= S1;
			    end case;
					
	  when S3 =>	
			current_state <= x"03";
			RFwa_ctrl <= IR_word(11 downto 8);	
			RFs_ctrl <= "01";  -- RF[rn] <= mem[direct]
			Ms_ctrl <= "01";
			Mre_ctrl <= '1';
			Mwe_ctrl <= '0';		  
			next_state <= S3a;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
	  when S3a =>   
			current_state <= x"A3";
			RFwe_ctrl <= '1'; 
	      Mre_ctrl <= '0'; 
			state <= S3b;
	  when S3b => 	
			current_state <= x"B3";
			RFwe_ctrl <= '0';
			state <= S1;
	    
	  when S4 =>	
			current_state <= x"04";
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; -- mem[direct] <= RF[rn]			
			Ms_ctrl <= "01";
			ALUs_ctrl <= "00";	  
			IRld_ctrl <= '0';
			state <= S4a;			-- read value from RF
	  when S4a =>   
			current_state <= x"A4";
			Mre_ctrl <= '0';
			Mwe_ctrl <= '1';
			next_state <= S4b;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
	  when S4b =>   
			current_state <= x"B4";
			Ms_ctrl <= "10";				  
			Mwe_ctrl <= '0';
			state <= S1;
		
	  when S5 =>	
			current_state <= x"05";
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; -- mem[RF[rn]] <= RF[rm]
			Ms_ctrl <= "00";
			ALUs_ctrl <= "01";
			RFr2a_ctrl <= IR_word(7 downto 4); 
			RFr2e_ctrl <= '1'; -- set addr.& data
			state <= S5a;
	  when S5a =>   
			current_state <= x"A5";
			Mre_ctrl <= '0';			
			Mwe_ctrl <= '1'; -- write into memory
			next_state <= S5b;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
	  when S5b => 	
			current_state <= x"B5";
			Ms_ctrl <= "10";-- return
			Mwe_ctrl <= '0';
			state <= S1;
					
	  when S6 =>	
			current_state <= x"06";
			RFwa_ctrl <= IR_word(11 downto 8);	
			RFwe_ctrl <= '1'; -- RF[rn] <= imm.
			RFs_ctrl <= "10";
			IRld_ctrl <= '0';
			state <= S6a;
	  when S6a =>
			current_state <= x"A6";
			state <= S1;
	    
	  when S7 =>	
			current_state <= x"07";
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; -- RF[rn] <= RF[rn] + RF[rm]
			RFr2e_ctrl <= '1'; 
			RFr2a_ctrl <= IR_word(7 downto 4);
 			ALUs_ctrl <= "10";
			state <= S7a;
	  when S7a =>   
			current_state <= x"A7";
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S7b;
	  when S7b =>   
			current_state <= x"B7";
			state <= S1;
					
	  when S8 =>	
			current_state <= x"08";
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; -- RF[rn] <= RF[rn] - RF[rm]
			RFr2a_ctrl <= IR_word(7 downto 4);
			RFr2e_ctrl <= '1';  
			ALUs_ctrl <= "11";
			state <= S8a;
	  when S8a =>   
			current_state <= x"A8";
			RFr1e_ctrl <= '0';
			RFr2e_ctrl <= '0';
			RFs_ctrl <= "00";
			RFwa_ctrl <= IR_word(11 downto 8);
			RFwe_ctrl <= '1';
			state <= S8b;
	  when S8b =>   
			current_state <= x"B8";
			state <= S1;
	  when S9 =>	
			current_state <= x"09";
			jmpen_ctrl <= '1';
			RFr1a_ctrl <= IR_word(11 downto 8);	
			RFr1e_ctrl <= '1'; -- jz if R[rn] = 0
			ALUs_ctrl <= "00";
			state <= S9a;
	  when S9a =>   
			current_state <= x"A9";
			state <= S9b;
	  when S9b =>   
			current_state <= x"B9";
			jmpen_ctrl <= '0';
	      state <= S1;
	  when S10 =>	
			current_state <= x"0A";
			state <= S10; -- halt
		
	  when S11 =>   
			current_state <= x"0B";
			Ms_ctrl <= "01";
			Mre_ctrl <= '1'; -- read memory
			Mwe_ctrl <= '0';
			next_state <= S11a;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
	  when S11a =>  
			current_state <= x"AB";
			oe_ctrl <= '1'; 
			state <= S1;
			
		-- S12 and S13 may need optimizing. version form 3/13/2016
		-- tested in reference system. 
			
				when S12 =>	
			current_state <= x"0C";
			RFr1a_ctrl <= IR_word(11 downto 8);	
			Ms_ctrl <= "00";
			Mre_ctrl <= '1';
			RFwe_ctrl <= '0';
			RFr1e_ctrl <= '1';
			RFr2e_ctrl <= '0';		
			RFs_ctrl <= "01";		
			Mwe_ctrl <= '0';
			next_state <= S12a;
			
			pass_control_to_cache <= '1';
			state <= WAIT_STATE;
			
	  when S12a =>   		
	  current_state <= x"AC";
			
			RFs_ctrl <= "01";	
			RFwa_ctrl <= IR_word(7 downto 4);
			RFwe_ctrl <= '1';
			state<=S12b;
	
	  
	  when S12b => 	
			current_state <= x"BC";
			Ms_ctrl <= "10";-- return
			Mwe_ctrl <= '0';
			state <= S1;
			
			
		-- this should jump only if register RF[r1] = 25 decimal (19 hex)
		-- tested and working in reference system with parts of matrix addition code
		-- Jumping when the target register is zero is avoided by using num_B channel
		-- instead of num_A, that way we only check for the single =25 condition. see ALU 
		-- unit for logic implemented there.
		-- tested in reference system
		
		
	when S13 =>	 
			current_state <= x"0D";
			jmpen_ctrl <= '1';
			RFr2a_ctrl <= IR_word(11 downto 8);	
			RFr2e_ctrl <= '1'; -- jz if R[rn] = 0
			ALUs_ctrl <= "01";
			state <= S13a;
	  when S13a =>   
			current_state <= x"AD";
			state <= S13b;
	  when S13b =>   
			current_state <= x"BD";
			jmpen_ctrl <= '0';
	      state <= S1;
		
			
		-- A 
		--can SAVE one clock cycle with customized 
		-- states for each wait state.
		-- i.e. execute the next_state when count = 1
		--		-> no wasted clock cycles
		when WAIT_STATE =>	
			current_state <= x"FF";
			
			if (pass_control_to_controller = '1') then
				current_state <= x"EE";
				state <= next_state;
				pass_control_to_cache <= '0';
				--A1
				--current_state <= x"A1";
			end if;
		
	  when others =>
	end case;
    end if;
  end process;
end fsm;