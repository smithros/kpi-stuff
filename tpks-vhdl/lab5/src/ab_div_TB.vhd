library ieee;
use ieee.std_logic_1164.all;

	-- Add your library and packages declaration here ...

entity ab_div_tb is
end ab_div_tb;

architecture TB_ARCHITECTURE of ab_div_tb is
	-- Component declaration of the tested unit
	component ab_div
	port(
		Clk : in STD_LOGIC;
		St : in STD_LOGIC;
		Dbus : in STD_LOGIC_VECTOR(15 downto 0);
		Quotient : out STD_LOGIC_VECTOR(15 downto 0);
		V : out STD_LOGIC;
		Rdy : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal Clk : STD_LOGIC:='0';
	signal St : STD_LOGIC;
	signal Dbus : STD_LOGIC_VECTOR(15 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal Quotient : STD_LOGIC_VECTOR(15 downto 0);
	signal V : STD_LOGIC;
	signal Rdy : STD_LOGIC;

	-- Add your code here ...
	constant N: integer := 6;
	type arr1 is array(1 to N) of std_logic_vector(31 downto 0);
	type arr2 is array(1 to N) of std_logic_vector(15 downto 0);
	constant dividendarr: arr1 := (X"00000070", X"07FF00BB", X"FFFFFE08", X"FF80030A", X"3FFF8000", X"3FFF7FFF");
	constant divisorarr: arr2 := (X"0004", X"E005", X"001E", X"EFFA",X"7FFF", X"7FFF");
	
	signal divisor: std_logic_vector(15 downto 0);
	signal Dividend: std_logic_vector(31 downto 0);
	signal count: integer range 0 to N;

begin
	CLK <= not CLK after 10 ns;
	process
	begin
		for i in 1 to N loop
			St <= '1' ;
			Dbus <= dividendarr(i)(31 downto 16);
			wait until rising_edge(CLK);
			Dbus <= dividendarr(i)(15 downto 0);
			wait until rising_edge(CLK);
			Dbus <= divisorarr(i) ;
			St <= '0' ;
			dividend <= dividendarr(i)(31 downto 0);
			divisor <= divisorarr(i);
			wait until (Rdy = '1');
			count <= i;
		end loop;
	end process;
	-- Unit Under Test port map
	UUT : ab_div
		port map (
			Clk => Clk,
			St => St,
			Dbus => Dbus,
			Quotient => Quotient,
			V => V,
			Rdy => Rdy
		);

	-- Add your stimulus here ...

end TB_ARCHITECTURE;

