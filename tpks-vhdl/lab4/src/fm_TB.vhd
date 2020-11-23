library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;
use CNetwork_lib.all;

	-- Add your library and packages declaration here ...

entity fm_tb is
end fm_tb;

architecture TB_ARCHITECTURE of fm_tb is
	-- Component declaration of the tested unit
	component fm
	port(
		CLK : in STD_LOGIC;
		WR : in STD_LOGIC;
		AB : in STD_LOGIC_VECTOR(3 downto 0);
		AD : in STD_LOGIC_VECTOR(3 downto 0);
		AQ : in STD_LOGIC_VECTOR(3 downto 0);
		Q : in STD_LOGIC_VECTOR(15 downto 0);
		B : out STD_LOGIC_VECTOR(15 downto 0);
		D : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;
	
	component RANDOM_GEN is
	generic( n:positive:=12;
	tp:time:=100 ns ;
	SEED:positive:=12345);
	port(
	CLK:out std_logic;
	Y : out STD_logic_vector(n-1 downto 0)
	);
	end component;
	component RANDOM_BIT is
	generic( n:positive:=1;
	tp:time:=100 ns ;
	SEED:positive:=1);
	port(
	CLK:out std_logic;
	Q : out STD_logic
	);
	end component; 

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal WR : STD_LOGIC;
	signal AB : STD_LOGIC_VECTOR(3 downto 0);
	signal AD : STD_LOGIC_VECTOR(3 downto 0);
	signal AQ : STD_LOGIC_VECTOR(3 downto 0);
	signal Q : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal B : STD_LOGIC_VECTOR(15 downto 0);
	signal D : STD_LOGIC_VECTOR(15 downto 0);

	-- Add your code here ...

begin
	G1: RANDOM_GEN
	generic map(n=>4, SEED => 1234)
	port map(CLK => open, Y =>AQ);	
	G2: RANDOM_GEN
	generic map(n=>4, SEED => 1490)
	port map(CLK => open, Y =>AB);
	G3: RANDOM_GEN
	generic map(n=>4, SEED => 1118)
	port map(CLK => open, Y =>AD);
	G4: RANDOM_BIT
	generic map(n=>1, SEED => 1250)
	port map(CLK => open, Q =>CLK);
	G5: RANDOM_BIT
	generic map(n=>1, SEED => 7005)
	port map(CLK => open, Q =>WR);
	G6: RANDOM_GEN
	generic map(n=>16, SEED => 4245)
	port map(CLK => open, Y =>Q);
	-- Unit Under Test port map
	UUT : fm
		port map (
			CLK => CLK,
			WR => WR,
			AB => AB,
			AD => AD,
			AQ => AQ,
			Q => Q,
			B => B,
			D => D
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

