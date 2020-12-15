library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- Add your library and packages declaration here ...

entity cpu_tb is
end cpu_tb;

architecture TB_ARCHITECTURE of cpu_tb is
	-- Component declaration of the tested unit	 
	constant TC:time:=10 ns; 
	component cpu
		port(
			C : in STD_LOGIC;
			RST : in STD_LOGIC;
			RDYP : in STD_LOGIC;
			DI : in STD_LOGIC_VECTOR(15 downto 0);
			WRP : out STD_LOGIC;
			RDP : out STD_LOGIC;
			AP : out STD_LOGIC_VECTOR(4 downto 0);
			DO : out STD_LOGIC_VECTOR(15 downto 0) );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal C : STD_LOGIC:='0';
	signal RST : STD_LOGIC;
	signal RDYP : STD_LOGIC;
	signal DI : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal WRP : STD_LOGIC;
	signal RDP : STD_LOGIC;
	signal AP : STD_LOGIC_VECTOR(4 downto 0);
	signal DO : STD_LOGIC_VECTOR(15 downto 0);
	
	-- Add your code here ...
	
	signal selp, RDY: std_logic;
	signal RP1: std_logic_VECTOR(15 downto 0);
	signal ADDRP : std_logic_VECTOR(4 downto 0);
begin
	C<=not C after 0.5*TC ; 
	RST<='1', '0' after 8 ns; 
	UUT : CPU port map (C,RST, 
		RDYP => RDY,
		DI => DI,
		WRP => WRP,
		RDP => RDP,
		AP => ADDRP,
		DO => DO );

	selp<='1' when ADDRP="00001" else '0'; 
	RDY<= WRP or RDP after TC+3ns; 
	DI<=X"5A5A" when (selp and RDP) = '1' else 
	X"0000" after 5 ns;
	R:process(C) begin 
		if C='1' and C'event and selp='1' and WRP='1' then
			RP1<=DO;
		end if;
end process;
	
end TB_ARCHITECTURE;


