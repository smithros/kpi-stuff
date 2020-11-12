library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use CNetwork_Lib.all;
use ieee.math_real.all;
	-- Add your library and packages declaration here ...

entity alu1_tb is
end alu1_tb;

architecture TB_ARCHITECTURE of alu1_tb is
	-- Component declaration of the tested unit
	component alu1
	port(
		C0 : in STD_LOGIC;
		F : in STD_LOGIC;
		A : in STD_LOGIC_VECTOR(11 downto 0);
		B : in STD_LOGIC_VECTOR(11 downto 0);
		N : out STD_LOGIC;
		CY : out STD_LOGIC;
		Z : out STD_LOGIC;
		Y : out STD_LOGIC_VECTOR(11 downto 0) );
	end component;
	
	component RANDOM_GEN is 
		generic (
		n:positive:=12;
		tp:time:=100 ns;
		SEED:positive:=12345);
		port (
		CLK:out STD_logic;
		Y:out std_logic_vector(n-1 downto 0)
		);
	end component; 
    component RANDOM_BIT is 
		generic (
		n:positive:=1;
		tp:time:=100 ns;
		SEED:positive:=1);
		port (
		CLK:out STD_logic;
		S:out std_logic
		);
	end component; 
	

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal C0 : STD_LOGIC;
	signal F : STD_LOGIC;
	signal A : STD_LOGIC_VECTOR(11 downto 0);
	signal B : STD_LOGIC_VECTOR(11 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal N : STD_LOGIC;
	signal CY : STD_LOGIC;
	signal Z : STD_LOGIC;
	signal Y : STD_LOGIC_VECTOR(11 downto 0);

	-- Add your code here ... 
	signal Y1, Y2:std_logic_vector(11 downto 0);
	signal N1, N2, CY1, CY2, Z1, Z2: std_logic;

begin
	G1: RANDOM_GEN
	generic map(n=>12,SEED=>1234)
	port map(CLK=>open,Y =>A);	
	
	G2: RANDOM_GEN
	generic map(n=>12,SEED=>8765)
	port map(CLK=>open,Y =>B);	 
	
	G3: RANDOM_BIT
	generic map(n=>1,SEED=>1)
	port map(CLK=>open,S =>F); 
	
	G4: RANDOM_BIT
	generic map(n=>1,SEED=>10)
	port map(
	CLK=>open,
	S =>C0);  
	
	UUT1 :entity alu1(synt)
	port map (F => F,A => A, B => B, C0 => C0,
	Y => Y1, CY => CY1, Z => Z1, N => N1);	 
	
	UUT2 : entity alu1(lut)
	port map (F => F,A => A,B => B,C0 => C0,
	Y => Y2, CY => CY2, Z => Z2, N => N2);
	
	COMP_Y: Y<=Y1 xor Y2;
	COMP_CY: CY<=CY1 xor CY2;
	COMP_Z: Z<=Z1 xor Z2;
	COMP_N: N<=N1 xor N2;

end TB_ARCHITECTURE;



