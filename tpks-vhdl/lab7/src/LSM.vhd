library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity LSM is
port(F : in std_logic_VECTOR(2 downto 0);
	A : in std_logic_VECTOR(15 downto 0);
	B : in std_logic_VECTOR(15 downto 0);
	Y : out std_logic_VECTOR(15 downto 0);
	RDY: out std_logic;
	C15: out std_logic;
	Z: out std_logic;
	N: out std_logic);
	end LSM;
	architecture BEH of LSM is
	signal y11: unsigned (16 downto 0);
	signal y22: unsigned (16 downto 0);
begin
ADDER: y11(16 downto 0) <= RESIZE(unsigned(A(15 downto 0)),17) +
			RESIZE(unsigned(B(15 downto 0)),17) when F = "000";
SUB: y22 <= RESIZE(unsigned(A(15 downto 0)),17) -
			RESIZE(unsigned(B(15 downto 0)),17) when (F = "001" or F = "010");
	MUX: with F select
	Y <= std_logic_vector(y11(15 downto 0)) when "000", 
	std_logic_vector(y22(15 downto 0)) when "001"|"010", (A xor B) when "011", (A and B) when "100",
	X"0000" when others;
	C15 <= y22(16) when F="010" else '1' when F="001";
	N <= y22(15) when F="010" or F="001" else y11(15) when F="000";
	ZERO_DEF: Z <= '1' when (y22(15 downto 0) = X"0000" and F="000") or (y11(15 downto 0) = X"0000" and (F="001" or F="010")) else '0';
	RDY <= '1';
end BEH;

