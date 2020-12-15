library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use IEEE.NUMERIC_STD.all;

entity RAM is port(C : in std_logic;
		RST : in std_logic; 
		WR: in std_logic; 
		AD : in STD_LOGIC_VECTOR(13 downto 0);
		DI : in STD_LOGIC_VECTOR(15 downto 0);
		DO : out STD_LOGIC_VECTOR(15 downto 0));
end RAM; 


architecture BEH of RAM is
	type MEM1KX16 is array(0 to 8191) of STD_LOGIC_VECTOR(15 downto 0);
	constant R0: std_logic_VECTOR(2 downto 0):="000";
	constant R1: std_logic_VECTOR(2 downto 0):="001";
	constant R2: std_logic_VECTOR(2 downto 0):="010";
	constant R3: std_logic_VECTOR(2 downto 0):="011";
	constant R4: std_logic_VECTOR(2 downto 0):="100";
	constant R5: std_logic_VECTOR(2 downto 0):="101";
	constant R6: std_logic_VECTOR(2 downto 0):="110";
	constant R7: std_logic_VECTOR(2 downto 0):="111";
	constant RR0: std_logic_VECTOR(5 downto 0):="000000";
	
	constant BRA: std_logic_VECTOR(2 downto 0):="000";
	constant LJMP: std_logic_VECTOR(2 downto 0):="001";
	constant CALL: std_logic_VECTOR(2 downto 0):="010";
	constant LD: std_logic_VECTOR(6 downto 0):="0110000";
	constant SD: std_logic_VECTOR(6 downto 0):="0110100";
	constant \IN\: std_logic_VECTOR(4 downto 0):="01110";
	constant \OUT\: std_logic_VECTOR(4 downto 0):="01111";
	constant ALOP: std_logic_VECTOR(2 downto 0):="100";
	constant LI: std_logic_VECTOR(6 downto 0):="1010000";
	constant RET: std_logic_VECTOR(15 downto 0):=X"C000";
	constant NOOP: std_logic_VECTOR(15 downto 0):=X"0000"; 

	constant ADD: std_logic_VECTOR(6 downto 0):="1000000";
	constant SUB: std_logic_VECTOR(6 downto 0):="1000001";
	constant SUBB: std_logic_VECTOR(6 downto 0):="1000010";
	constant \XOR\:std_logic_VECTOR(6 downto 0):="1000011";
	constant \AND\: std_logic_VECTOR(6 downto 0):="1000100";
	constant \SRA\: std_logic_VECTOR(6 downto 0):="1000101";
	constant SP: std_logic_VECTOR(6 downto 0):="1000110";

	constant NOP: std_logic_VECTOR(2 downto 0):="000";
	constant JUMP: std_logic_VECTOR(2 downto 0):="001";
	constant NEQ: std_logic_VECTOR(2 downto 0):="010";
	constant EQ: std_logic_VECTOR(2 downto 0):="011";
	constant GE: std_logic_VECTOR(2 downto 0):="100";
	constant LT: std_logic_VECTOR(2 downto 0):="101";
	constant NCY: std_logic_VECTOR(2 downto 0):="110";
	constant CY: std_logic_VECTOR(2 downto 0):="111";
	
	constant RAM_init: MEM1KX16:= 

	(0=> ADD &R0&R0&R0, 
	1=> LI &R1&RR0, 
	2=> X"0040", 
	3=> LD &R2&R1&R0,
	4=> \XOR\ &R1&R1&R0,
	5=> ADD &R2&R0&R2, 
	6=> BRA &NEQ&"1111111101", 
	7=> LJMP &"0000000110000", 
	8=> CALL &"0000000100000", 
	9=> \SRA\ &R2&R0&R4, 
	10=> SD &R0&R2&R6, 
	11=> NOOP,
	12=> BRA & JUMP&"1111111111", 
	32=> \IN\ &"00"&R3&"001"&R0, 
	33=> ADD &R5&R4&R3,
	34=> \OUT\ &"00"&R0&"001"&R5,
	35=> RET,
	48=> SUB &R4&R1&R1,
	49=> LJMP &"0000000001000", 
	64=> X"0004",
	others=> X"0000");

	signal do1: STD_LOGIC_VECTOR(15 downto 0);
	signal addr:STD_LOGIC_VECTOR(13 downto 0);
	signal addri:integer;
begin
	RG_ADDR:process(C,RST) begin
 		if RST='1' then
 			addr<="00000000000000";
 		elsif C='1' and C'event then
 			addr<= AD;
 	end if;
	end process; 
	RAM8K:process(C,addr,addri)
		variable RAM: MEM1KX16 := RAM_init;
	begin
		addri <= to_integer(unsigned(addr));
		if C='1' and C'event then
			if WR = '1' then
				RAM(addri):= DI;
			end if;
			if RST = '1' then
				do1 <= X"0000";
			else
				do1 <= RAM(addri);
			end if;
		end if;
	end process;
	TRI: DO<= do1;
end BEH;

