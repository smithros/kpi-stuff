library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_STD.all;
use IEEE.MATH_REAL.all;

entity E_X_CALC is
	generic (
		ni   : natural := 20; -- input data width
		no   : natural := 20; -- output data width
		pipe : natural := 1 -- 1 - fully pipelined
		); 
	port (
		CLK   : in STD_LOGIC;
		START : in STD_LOGIC; -- start of calculations
		DI    : in STD_LOGIC_VECTOR(ni - 1 downto 0); -- input data
		RDY   : out STD_LOGIC; -- 1-st result ready
		DO    : out STD_LOGIC_VECTOR(no - 1 downto 0) -- result
		);
end E_X_CALC;


architecture SYNT of E_X_CALC is 
	type Tstage is array (1 to no + 1) of unsigned(ni + 4 downto 0);  
	constant MATH_E : real := 2.71828_18284_59045_23536;
	
	signal yi, xi : Tstage := (others => (others => '0'));
	signal tmp    : Tstage := (others => (others => '0')); 	  
	signal xn     : unsigned(ni - 1 downto 0);
	signal n      : natural;
	signal doi    : unsigned(ni+3 downto 0);	
	signal ctn    : natural range 0 to no+1;
	signal startd : std_logic; 

begin
	IO_R_FSM: process(clk)
		variable t : unsigned(ni + 3 downto ni - no + 3);
	begin
		t := doi(ni + 3 downto ni - no + 3) + 1; -- rounding
		if rising_edge(clk) then
			startd <= START;
			if startd = '0' and START = '1' then
				xn  <= (others => '0');
				DO  <= (others => '0');
				ctn <= 0;
				RDY <= '0';
			else
				xn <= unsigned(DI);
				DO <= std_logic_vector(t(ni + 3 downto ni - no + 4));
				if ctn <= no then
					ctn <= ctn + 1;
				end if;
				if (pipe = 0 and ctn = 1) or
					ctn  = no then
					RDY <= '1';
				end if;
			end if;
		end if;
	end process;
	
	yi(1) <= to_unsigned(integer(1.0 * 2.0**(ni + 4)),ni + 5);
	xi(1) <= '0' & xn & "0000";

	NR: if pipe = 0 generate
		STAGES: for i in 1 to no-1 generate
			tmp(i)  <= to_unsigned(integer(LOG(MATH_E, 1.0 + 2.0**(-(i + 1)))),ni + 5) ;  
			yi(i+1) <= yi(i) when xi(i) < tmp(i) else yi(i) + SHIFT_RIGHT(yi(i),i); 
			xi(i+1) <= xi(i) when xi(i) < tmp(i) else xi(i) - to_unsigned(integer(LOG(MATH_E, 1.0 + 2.0**(-i))),ni + 5);	
		end generate;
	end generate;
	
	RR: if pipe = 1 generate
		STAGES: for i in 1 to no-1 generate
			process(CLK, xi, tmp) begin
				tmp(i) <= to_unsigned(integer(LOG(MATH_E, 1.0 + 2.0**(-(i + 1)))), ni + 5) ;
				if rising_edge(CLK) then  	
					if xi(i) < tmp(i) then
						yi(i + 1)<= yi(i);
						xi(i + 1)<= xi(i);
					else	
						yi(i + 1)<= yi(i) + SHIFT_RIGHT(yi(i),i);
						xi(i + 1)<= xi(i) - to_unsigned(integer(LOG(MATH_E, 1.0 + 2.0**(-i))),ni + 5);
					end if;
				end if;
			end process;
		end generate;
	end generate;
	doi <= yi(no)(ni + 3 downto 0) ;
end SYNT;
