-------------------------------------------------------------------------------
--
-- Title       : FM
-- Design      : lab4_4
-- Author      : Admin
-- Company     : KPI
--
-------------------------------------------------------------------------------
--
-- File        : FM.vhd
-- Generated   : Mon Nov 23 20:20:18 2020
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
--{entity {FM} architecture {FM}}


library IEEE; 
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use CNetwork_lib.all;

entity FM is
	 port(
		 CLK : in STD_LOGIC;
		 WR : in STD_LOGIC;
		 AB : in STD_LOGIC_VECTOR(3 downto 0);
		 AD : in STD_LOGIC_VECTOR(3 downto 0);
		 AQ : in STD_LOGIC_VECTOR(3 downto 0);
		 Q : in STD_LOGIC_VECTOR(15 downto 0);
		 B : out STD_LOGIC_VECTOR(15 downto 0);
		 D : out STD_LOGIC_VECTOR(15 downto 0)
	     );
end FM;

--}} End of automatically maintained section


architecture BEH of FM is
	type MEM16X16 is array(0 to 15) of Std_logic_vector(15 downto 0);	
begin
	FM8:process(CLK,AD,AB)
 		variable RAM: MEM16x16;
 		variable addrq,addrd,addrb:integer;
		
 	begin
 		addrq:= to_integer(unsigned(AQ)); 
		addrd:= to_integer(unsigned(AD));
 		addrb:= to_integer(unsigned(AB)); 
 		if CLK='1' and CLK'event then
 			if WR = '1' then 
				if addrq < 15 and addrq /= 0 then
					RAM(addrq):= Q;	
				elsif addrq = 0 then
					null;  -- не можна записувати в нульовий регістр
 				end if;
			end if;
 		end if;	   
		B<= RAM(addrb);
		D<= RAM(addrd);
 	end process;
end BEH; 

