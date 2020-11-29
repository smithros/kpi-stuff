-------------------------------------------------------------------------------
--
-- Title       : RAM
-- Design      : lab3_3
-- Author      : Admin
-- Company     : KPI
--
-------------------------------------------------------------------------------
--
-- File        : RAM.vhd
-- Generated   : Tue Nov 10 20:36:35 2020
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
--{entity {RAM} architecture {RAM}}

library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;	

entity RAM is
	 port(
		 CLK : in STD_LOGIC;
		 R : in STD_LOGIC;
		 WR : in STD_LOGIC;
		 OE : in STD_LOGIC;
		 AE : in STD_LOGIC;
		 AD : in STD_LOGIC_VECTOR(12 downto 0); -- 8192 = 2 ^ 13
		 D : in STD_LOGIC_VECTOR(15 downto 0);
		 V : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end RAM;

--}} End of automatically maintained section

architecture BEH of RAM is
	type MEM1KX16 is array(0 to 8191) of STD_LOGIC_VECTOR(15 downto 0);
	constant RAM_init: MEM1KX16 :=
	(X"0000", others => X"0000");
	signal do: STD_LOGIC_VECTOR(15 downto 0);
	signal addr:STD_LOGIC_VECTOR(12 downto 0);
	signal addri:integer;
begin
	RG_ADDR:process(CLK,R) begin
 		if R='1' then
 			addr<="0000000000000";
 		elsif CLK='1' and CLK'event and AE='1' then
 			addr<= AD;
 	end if;
	end process; 
	RAM8K:process(CLK,addr,addri)
		variable RAM: MEM1KX16 := RAM_init;
	begin
		addri <= to_integer(unsigned(addr));
		if CLK='1' and CLK'event then
			if WR = '1' then
				RAM(addri):= D;
			end if;
			if R = '1' then
				do <= X"0000";
			else
				do <= RAM(addri);
			end if;
		end if;
	end process;
	TRI: V<= do when OE='1' else "ZZZZZZZZZZZZZZZZ";
end BEH;

