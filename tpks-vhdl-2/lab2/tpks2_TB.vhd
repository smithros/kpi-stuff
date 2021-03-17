
library IEEE;
use IEEE.STD_LOGIC_1164.all;	 

entity tpks2_tb is   
	generic(nb:natural:=14);
	port(
	MAGN : out real;
	LOGMAGN : out real;
	PHASE : out real;
	ENA	 : inout STD_LOGIC;
	FREQ : out integer
	);
end tpks2_tb; 

architecture test of tpks2_tb is
component tpks2 is 
	port( CLK : in STD_LOGIC;
	RST : in STD_LOGIC;
	X : in STD_LOGIC_VECTOR(13 downto 0);
	Y : out STD_LOGIC_VECTOR(13 downto 0)
	);
end component; 	  

component FilterTB is port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		RERSP : in STD_LOGIC_VECTOR(nb-1 downto 0);
		IMRSP : in STD_LOGIC_VECTOR(nb-1 downto 0);
		REO : out STD_LOGIC_VECTOR(nb-1 downto 0);
		IMO : out STD_LOGIC_VECTOR(nb-1 downto 0);
		FREQ : out INTEGER;
		MAGN:out REAL; 
		LOGMAGN:out REAL; 
		PHASE: out REAL ;
		NEXTFR: out STD_LOGIC;
		ENA: inout STD_LOGIC
		);
end component; 
 
signal x1,x2,y1,y2 : STD_LOGIC_VECTOR(nb-1 downto 0);  
signal CLK,RST:std_logic:='0';
begin 
	CLOCK:
	CLK <= not CLK after 45 ns;
	RST <= '1' after 0 ns,'0' after 30 ns;
	First: tpks2 port map (CLK,
		RST,
		X =>x1,
		Y =>y1);	  
	Second: tpks2 port map (CLK,
		RST,
		X =>x2,
		Y =>y2);	
	Third: FilterTB port map (CLK,
		RST,
		IMO =>x2,
		REO => x1,
		RERSP =>y1, 
		IMRSP =>y2,
		MAGN => MAGN,
		LOGMAGN => LOGMAGN,
		PHASE => PHASE,
		ENA=>ENA,
		FREQ =>FREQ);
end test;