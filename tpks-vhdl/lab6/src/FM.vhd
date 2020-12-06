library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.math_real.all;	 

entity FM is
port(
	C:in std_logic;
	RST:in std_logic;
	WR:in std_logic;
	INCQ: in STd_logic;
	CALL: in std_logic;
	AB:in std_logic_VECTOR(2 downto 0);
	AD:in std_logic_VECTOR(2 downto 0);
	AQ:in std_logic_VECTOR(2 downto 0);
	ARETC: in std_logic_VECTOR (15 downto 0);
	Q: in std_logic_VECTOR (15 downto 0);
	B: out std_logic_VECTOR(15 downto 0);
	D: out std_logic_VECTOR(15 downto 0);
	ARETCO: out std_logic_VECTOR (15 downto 0));
end FM;

architecture BEH of FM is
	type MEM16X16 is array(0 to 15) of Std_logic_vector(15 downto 0);	
begin
	FM8:process(C,AD,AB)
 		variable RAM: MEM16x16;
 		variable addrq,addrd,addrb:integer;
 	begin
 		addrq:= to_integer(unsigned(AQ));
		if INCQ='1' then
			addrq:=addrq+1;
		end if;
		addrd:= to_integer(unsigned(AD));
 		addrb:= to_integer(unsigned(AB)); 
 		if C='1' and C'event then
 			if WR = '1' then 
				if addrq < 15 and addrq /= 0 then
					RAM(addrq):= Q;	
				elsif addrq = 0 then
					null;  -- не можна записувати в нульовий регістр
 				end if;
			end if;
 		end if;	 
		if CALL = '1' then
			RAM(15):= ARETC;
		end if;
		B<= RAM(addrb);
		D<= RAM(addrd);
		ARETCO<= RAM(15);
 	end process;
end BEH;
