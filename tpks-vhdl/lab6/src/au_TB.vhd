library ieee;
use ieee.MATH_REAL.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity au_tb is
end au_tb;	   

architecture TB_ARCHITECTURE of au_tb is
component au
port(
	C : in STD_LOGIC;
	RST : in STD_LOGIC;
	START : in STD_LOGIC;
	RD : in STD_LOGIC;
	WRD : in STD_LOGIC;
	RET : in STD_LOGIC;
	CALL : in STD_LOGIC;
	DI : in STD_LOGIC_VECTOR(15 downto 0);
	AB : in STD_LOGIC_VECTOR(2 downto 0);
	AD : in STD_LOGIC_VECTOR(2 downto 0);
	AQ : in STD_LOGIC_VECTOR(2 downto 0);
	ARET : in STD_LOGIC_VECTOR(12 downto 0);
	ACOP : in STD_LOGIC_VECTOR(2 downto 0);
	RDY : out STD_LOGIC;
	ARETO : out STD_LOGIC_VECTOR(12 downto 0);
	DO : out STD_LOGIC_VECTOR(15 downto 0);
	BO : out STD_LOGIC_VECTOR(15 downto 0);
	CNZ : out STD_LOGIC_VECTOR(2 downto 0) );
end component;
	signal c: std_logic:='0';
	signal rst,rdy,start,wrd,rd,ret,call:std_logic;
	signal acop,cnz:std_logic_VECTOR(2 downto 0);
	signal aq,ad,ab:std_logic_VECTOR(2 downto 0);
	signal di,do,bo:std_logic_VECTOR(15 downto 0);
	signal aret,areto:std_logic_VECTOR(12 downto 0);
	signal maddr:natural;
type MICROINST is record
	ACOP:std_logic_vector(2 downto 0);
	AQ,AD,AB:std_logic_vector(2 downto 0);
	DI:std_logic_VECTOR(15 downto 0);
	START,WRD,RD:std_logic;
end record;
constant n: positive:=9;
type MICROPROGR is array(0 to n-1) of MICROINST;
constant mp:MICROPROGR:=(
("000","001","000","000",X"0070",'0','1','0'), --ADD
("000","010","001","001",X"0000",'1','0','0'), --ADD
("000","011","000","000",X"0004",'0','1','0'), --ADD
("011","100","010","011",X"0000",'1','0','0'), --SRA
("100","100","100","001",X"0000",'1','0','0'), --SRA
("101","101","100","000",X"0000",'1','0','0'), --XOR  
("010","110","010","101",X"0000",'1','0','0'), --XOR
("001","110","110","100",X"0000",'1','0','0'), --XOR
("110","111","001","011",X"0000",'1','0','0') --XOR
);
begin
G2_GEN: RST<='1' ,'0' after 25 ns;
ret <= '0';
call <= '0';
G1_GEN: C<= not C after 10ns;
CTM:process(C,RST)
begin
if FALLING_EDGE(RST) then
maddr<=0;
elsif C='1' and C'event and RST='0' then
if (RDY='1' and START='1') or WRD='1'or RD='1' then
maddr<=(maddr+1) mod n;
end if;
end if;
end process;
ROM_U:(ACOP,AQ,AD,AB,DI,START,WRD,RD)<=mp(maddr);
AU_U : AU port map (
C,
RST,
START => START,
RD => RD,
WRD => WRD,
RET => RET,
CALL => CALL,
DI => DI,
AB => AB,
AD => AD,
AQ => AQ,
ARET => ARET,
ACOP => ACOP,
RDY => RDY,
ARETO => ARETO,
DO => DO,
BO=>BO,
CNZ => CNZ);
end TB_ARCHITECTURE;