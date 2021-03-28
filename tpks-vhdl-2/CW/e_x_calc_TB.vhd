library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_STD.all;	 
use std.textio.all;					

entity E_X_CALC_tb is
end E_X_CALC_tb;

architecture TestBench of E_X_CALC_tb is
signal CLK : std_logic:='0';
signal n : natural := 20;
signal di : std_logic_vector(n-1 downto 0):="00000000000000000001"; 
signal do : std_logic_vector(n-1 downto 0):=(others=>'0'); 
signal start,rdy : std_logic;

component E_X_CALC
 port(
	 CLK : in STD_LOGIC;
	 START: in STD_LOGIC; 
	 DI : in STD_LOGIC_VECTOR(n-1 downto 0); 
	 RDY: out STD_LOGIC;
	 DO : out STD_LOGIC_VECTOR(n-1 downto 0)
 );
 end component;	
begin		   
 CLK<=not CLK after 50 ns;
 start <= '0' after 50 ns, '1' after 100 ns;
 
 CT:process(CLK) 	
    file outfile: text is out "out.txt";
 	variable outline : line;   
	variable outdata : integer;
 begin
 	if rising_edge(CLK) then 
		if (rdy = '1' and unsigned(do) /= 0) then	
			report "Write line";
			outdata:=to_integer(unsigned(do));
			write(outline,outdata);
			writeline (outfile, outline);
		end if;
 	end if;
 end process;
 
 E_X_CALC_1 : E_X_CALC
	 port map ( 
	 CLK => CLK, 
	 START => start,
	 DI => di, 
	 RDY => rdy,
	 DO => do
	 );
end TestBench; 
