Library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

entity ICTR is port(C, RST: in std_logic;
		D : in std_logic_VECTOR(13 downto 0); 
		I : in std_logic_VECTOR(9 downto 0); 
		B : in std_logic_VECTOR(13 downto 0); 
		F : in std_logic_VECTOR(3 downto 0);
		ARETI: in std_logic_VECTOR(13 downto 0); 
		A : out std_logic_VECTOR(13 downto 0); 
		ARET : out std_logic_VECTOR(13 downto 0));
end ICTR;	  

architecture BEH of ICTR is
	signal CTR,CTRi:SIGNED(13 downto 0);
 begin
	ICTR:process(RST,C,CTR)
	begin
		CTRi<=CTR+1; 
		if RST='1' then
			CTR <="00000000000000"; 
		elsif C='1' and C'event then
			case F(2 downto 0) is 
				when "100"=> CTR<= CTRi;
				when "101"=>CTR<= SIGNED(D); 
				when "110"=>CTR<= SIGNED(ARETI);
				when "111"=>CTR<= CTR+SIGNED(I);
				when others => null;
			end case;
		end if;
	end process;
	MUX_A:A<=B when F(3)='1' else std_logic_VECTOR(CTR); 
	ARET<=std_logic_VECTOR(CTRi); 
end BEH;
