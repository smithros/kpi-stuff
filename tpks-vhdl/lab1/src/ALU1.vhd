-------------------------------------------------------------------------------
--
-- Title       : ALU1
-- Design      : lab1_1
-- Author      : Admin
-- Company     : KPI
--
-------------------------------------------------------------------------------
--
-- File        : ALU1.vhd
-- Generated   : Mon Oct 26 19:41:23 2020
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ALU1} architecture {ALU1}}

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity ALU1 is
	 port(
		 C0 : in STD_LOGIC;
		 F : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(11 downto 0);
		 B : in STD_LOGIC_VECTOR(11 downto 0);
		 N : out STD_LOGIC;
		 CY : out STD_LOGIC;
		 Z : out STD_LOGIC;
		 Y : out STD_LOGIC_VECTOR(11 downto 0)
	     );
end ALU1;

--}} End of automatically maintained section

architecture synt of ALU1 is 
	signal ai,bi,yi: unsigned(12 downto 0);
	function TO_I(a:STD_LOGIC) return integer is
	begin
		if a = '1' then return 1;
		else return 0;
		end if;
		end function;
begin
	ai <= RESIZE(unsigned(A),13);
	bi <= RESIZE(unsigned(B),13);	
	yi <= ai + bi + TO_I(C0) when F = '0' else ((not ai) and bi);
	Y <= std_logic_vector(yi(11 downto 0));
	N <= yi(11);
	CY <= yi(12) when F = '0' else '0';	  
	Z <= '1' when yi(11 downto 0) = x"000" else '0';
end synt;		  

architecture lut of ALU1 is
	signal C, X: std_logic_vector(12 downto 0);
	signal Yi : std_logic_vector(11 downto 0);
	signal Zj: std_logic_vector(3 downto 0);
	component LUT3 is generic( INIT : bit_vector := X"FF" );
		port( O : out std_ulogic;
			I0 : in std_ulogic;
			I1 : in std_ulogic;
			I2 : in std_ulogic);
	end component;
	component LUT4 is generic( INIT : bit_vector := X"FFFF" );
		port( O : out std_ulogic;
			I0 : in std_ulogic;
			I1 : in std_ulogic;
			I2 : in std_ulogic;
			I3 : in std_ulogic );
	end component;
begin
	C(0) <= C0;
	lsm_lut:for i in 0 to 11 generate
		LNI:LUT3 generic map("01000110")
		port map(O=>X(i),I2=>F,I1=>B(i),I0=>A(i));
		LNO:LUT3 generic map("11000110")
		port map(O=>Yi(i),I2=>F,I1=>X(i),I0=>C(i));
		LNC:LUT4 generic map("0000000011101000")
		port map(O=>C(i+1),I3=>F,I2=>C(i),I1=>B(i),I0=>A(i));
	end generate;
	gen_Zj: for i in 0 to 3 generate
		gZj : LUT3 generic map ("00000001")
		port map (O=>Zj(i),I2=>Yi(i),I1=>Yi(i+4),I0=>Yi(i+8));
	end generate;
	gen_Zi : LUT4 generic map (X"8000")
	port map (O=>Z,I3=>Zj(3),I2=>Zj(2),I1=>Zj(1),I0=>Zj(0));
	Y <= Yi(11 downto 0);
	CY <= C(12);
	N <= Yi(11);
end lut;