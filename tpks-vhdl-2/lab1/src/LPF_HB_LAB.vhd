library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
 
entity LPF_HB_LAB is
    port(CLK : in STD_LOGIC;
         RST : in STD_LOGIC;
         X   : in STD_LOGIC_VECTOR(13 downto 0);
         Y   : out STD_LOGIC_VECTOR(13 downto 0)
        );
end LPF_HB_LAB; 
 
architecture synt of LPF_HB_LAB is
    constant a : signed(11 downto 0) := to_signed(integer(-0.156*2.0**11),12);  
    constant b : signed(11 downto 0) := to_signed(integer(0.727*2.0**11),12);
    constant c : signed(11 downto 0) := to_signed(integer(-0.269*2.0**11),12);     
    signal yi  : signed(13 downto 0); 
	signal xi, xi_1, xi_2       : signed(19 downto 0);
	signal qi_1, qi_2, pi, pi_1 : signed(31 downto 0);
begin
    LPF: process(CLK,RST)
	variable yt   : signed(19 downto 0); 
	variable sm_2 : signed(19 downto 0);
	variable qi   : signed(19 downto 0);
    begin
        if RST = '1' then
            xi   <= (others => '0');
            pi   <= (others => '0');
			xi_1 <= (others => '0');
            xi_2 <= (others => '0');
			qi_1 <= (others => '0');
            qi_2 <= (others => '0');
			pi_1 <= (others => '0');
			yi   <= (others => '0');
        elsif CLK = '1' and CLK'event then    
            xi   <= RESIZE(signed(X&"0000"), 20);
			xi_1 <= xi;
            xi_2 <= xi_1;
            qi   := xi- qi_2(30 downto 11) - pi_1(30 downto 11);
            qi_1 <= qi * b;
            qi_2 <= qi_1;
			pi_1 <= qi * c;
			sm_2 := xi_2 + qi_1(30 downto 11) + pi_1(30 downto 11);
            yt   := sm_2 + xi_1;
			yi   <= yt(16 downto 3);
        end if;
    end process; 
    Y <= std_logic_vector(yi);
end synt;
