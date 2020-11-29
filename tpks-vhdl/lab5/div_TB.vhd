library BITLIB;
use BITLIB.all;	 
use work.bit_pack.all;

entity testsdiv is
end testsdiv;

architecture testi of testsdiv is
component div
	port(Clk,St: in bit;
		Dbus: in bit_vector(15 downto 0);	
		Quotient: out bit_vector(15 downto 0);
		V, Rdy: out bit);
end component;

constant N: integer := 6;
type arr1 is array(1 to N) of bit_vector(31 downto 0);
type arr2 is array(1 to N) of bit_vector(15 downto 0);
constant dividendarr: arr1 := (X"00000070", X"07FF00BB", X"FFFFFE08", X"FF80030A", X"3FFF8000", X"3FFF7FFF");
constant divisorarr: arr2 := (X"0004", X"E005", X"001E", X"EFFA",X"7FFF", X"7FFF");
	
	signal CLK, St, V, Rdy: bit;
	signal Dbus, Quotient, divisor: bit_vector(15 downto 0);
	signal Dividend: bit_vector(31 downto 0);
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
sdivl: div port map(Clk, St, Dbus, Quotient, V, Rdy);
end testi;