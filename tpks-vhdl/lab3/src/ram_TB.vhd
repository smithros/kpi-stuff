use CNetwork_Lib.all;
library ieee;
use ieee.NUMERIC_BIT.all;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ram_TB is
end ram_TB;

architecture TB_ARCHITECTURE of ram_TB is
	-- Component declaration of the tested unit
	component ram
	port(
		CLK : in STD_LOGIC;
		R : in STD_LOGIC;
		WR : in STD_LOGIC;
		OE : in STD_LOGIC;
		AE : in STD_LOGIC;
		AD : in STD_LOGIC_VECTOR(12 downto 0);
		D : in STD_LOGIC_VECTOR(15 downto 0);
		V : out STD_LOGIC_VECTOR(15 downto 0));
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
	signal R : STD_LOGIC;
	signal WR : STD_LOGIC;
	signal OE : STD_LOGIC;
	signal AE : STD_LOGIC;
	signal AD : STD_LOGIC_VECTOR(12 downto 0);
	signal D  : STD_LOGIC_VECTOR(15 downto 0);
	signal V  : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity

	-- Add your code here ...  
	signal di:STD_LOGIC_VECTOR(12 downto 0);
	signal dc:STD_LOGIC_VECTOR(1 downto 0);
	signal dz:STD_LOGIC_VECTOR(15 downto 0);

begin 
	G1: RANDOM_GEN
	generic map(n=>13, SEED => 2214)
	port map(CLK => open, Y =>di);
	G2: RANDOM_GEN
	generic map(n=>2, SEED => 2115)
	port map(CLK => open, Y =>dc);
	G3: RANDOM_GEN
	generic map(n=>16, SEED => 2346)
	port map(CLK => open, Y =>dz);
	G4: RANDOM_BIT
	generic map(n=>1, SEED => 1234)
	port map(CLK => open, Q =>CLK);	
	D<= std_logic_vector(dz);
	AD<= std_logic_vector(di); 
	R<='1','0' after 5 ns;
	WR<= '1' when dc(1 downto 0)="00" else '0';
	AE<= '1' when dc(1 downto 0)="01" else '0';
	OE<= '1' when dc(1 downto 0)="10" else '0';
	
	UUT : ram
		port map (
			CLK => CLK,
			R => R,
			WR => WR,
			OE => OE,
			AE => AE,
			AD => AD,
			D => D
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;


