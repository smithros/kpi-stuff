-------------------------------------------------------------------------------
--
-- Title       : ICTR
-- Design      : lab2_2
-- Author      : Admin
-- Company     : KPI
--
-------------------------------------------------------------------------------
--
-- File        : ICTR.vhd
-- Generated   : Sun Nov  1 14:45:02 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ICTR} architecture {ICTR}}

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ICTR is
	 port(
		 CLK : in STD_LOGIC;
		 R : in STD_LOGIC;
		 WR : in STD_LOGIC;
		 D : in STD_LOGIC_VECTOR(14 downto 0);
		 F : in STD_LOGIC_VECTOR(2 downto 0);
		 A : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end ICTR;

--}} End of automatically maintained section

architecture BEH of ICTR is
	signal RG:   std_logic_vector(2 downto 0); 
	signal SM:   std_logic_vector(3 downto 0); 
	signal CTR:  std_logic_vector(15 downto 3); 
	signal CTRi: integer range 0 to 2**13-1;
 
begin
	SUM : SM <= std_logic_vector(to_unsigned(to_integer(unsigned(RG)) + to_integer(unsigned(F)), SM'length));
	R_3 : process(CLK, R)
	begin
		if (R = '1') then 
			RG <= "000";
		elsif rising_edge(CLK) then
			if (F = "000") then 
				null;
			elsif (F = "001") then 
				RG <= SM(2 downto 0);
			elsif (F = "010") then 
				RG <= SM(2 downto 0);
			elsif (F = "011") then 
				RG <= SM(2 downto 0);
			elsif (F = "100") then 
				null;
			elsif (F = "101") then 
			    RG <= "000";
			elsif (F = "110") then 
				RG <= D(2 downto 0);
			elsif (F = "111") then -- X - do nothing
				null;							   
			end if;
		end if;	   
	end process; 
 
	CT : process (CLK, R)
	begin
		if (R = '1') then 
			CTRi <= 224/8;
		elsif rising_edge(CLK) then
			if (F = "101") then	
				CTRi <= 0;
			elsif (F = "110") then 	
				CTRi <= to_integer(unsigned(D(14 downto 3)));
			elsif ((F(2) = '0') and  SM(3) = '1') then
				CTRi <= CTRi + 1;
			end if;
		end if;
		CTR <= std_logic_vector(to_unsigned(CTRi, CTR'length));
		A <= CTR & RG;
	end process;
end architecture;

