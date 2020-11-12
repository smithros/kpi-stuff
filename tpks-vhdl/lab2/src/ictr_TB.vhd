library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ictr_tb is
end ictr_tb;

architecture TB_ARCHITECTURE of ictr_tb is
	-- Component declaration of the tested unit
	component ictr
	port(
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		WR : in STD_LOGIC;
		D : in STD_LOGIC_VECTOR(14 downto 0);
		F : in STD_LOGIC_VECTOR(2 downto 0);
		A : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC:='0';
	signal R : STD_LOGIC;
	signal WR : STD_LOGIC;
	signal D : STD_LOGIC_VECTOR(14 downto 0);
	signal F : STD_LOGIC_VECTOR(2 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal A : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...  

begin
	CLK <= not CLK after 5 ns;
	R <= '0','1' after 85 ns, '0' after 95 ns;
	D <= "000101100100101";
	WR <= '0';
	F <= "110","001" after 30 ns, "100" after 40 ns, "010" after 50 ns, "111" after 60 ns, "011" after 70 ns, "010" after 80 ns, "101" after 100 ns;
	
	-- Unit Under Test port map
	UUT : ictr
		port map (
			CLK => CLK,
			R => R,
			WR => WR,
			D => D,
			F => F,
			A => A
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;
