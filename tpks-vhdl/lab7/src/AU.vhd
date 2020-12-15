library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_arith.all;
use ieee.math_real.all;	 

entity AU is port(
	C : in std_logic;
	RST : in std_logic;
	START : in std_logic;
	RD: in std_logic;
	WRD : in std_logic;
	RET : in std_logic;
	CALL: in std_logic;
	DI : in std_logic_VECTOR(15 downto 0);
	AB : in std_logic_VECTOR(2 downto 0);
	AD : in std_logic_VECTOR(2 downto 0);
	AQ : in std_logic_VECTOR(2 downto 0);
	ARET : in std_logic_VECTOR(13 downto 0);
	ACOP : in std_logic_VECTOR(2 downto 0);
	RDY : out std_logic;
	ARETO : out std_logic_VECTOR(13 downto 0);
	DO : out std_logic_VECTOR(15 downto 0);
	BO : out std_logic_VECTOR(15 downto 0);
	CNZ: out std_logic_VECTOR(2 downto 0));
end AU;
architecture BEH of AU is
component FM is port(
	C:in std_logic;
	RST:in std_logic;
	WR:in std_logic;
	INCQ: in STd_logic;
	CALL: in std_logic;
	AB:in std_logic_VECTOR(2 downto 0);
	AD:in std_logic_VECTOR(2 downto 0);
	AQ:in std_logic_VECTOR(2 downto 0);
	ARETC: in std_logic_VECTOR (15 downto 0);
	Q: in std_logic_VECTOR (15 downto 0);
	B: out std_logic_VECTOR(15 downto 0);
	D: out std_logic_VECTOR(15 downto 0);
	ARETCO: out std_logic_VECTOR (15 downto 0));
end component ;
component LSM is port(
	F : in std_logic_VECTOR(2 downto 0);
	A : in std_logic_VECTOR(15 downto 0);
	B : in std_logic_VECTOR(15 downto 0);
	Y : out std_logic_VECTOR(15 downto 0);
	RDY: out std_logic;
	C15: out std_logic;
	Z: out std_logic;
	N: out std_logic);
end component ;
component div is port(
Clk, St, RST, START: in std_logic;
	Dbus1: in std_logic_VECTOR(15 downto 0);
	Dbus2: in std_logic_VECTOR(15 downto 0); 
	Dbus3: in std_logic_VECTOR(15 downto 0); 
	Quotient: out std_logic_VECTOR(15 downto 0);
	FY: out std_logic_VECTOR(15 downto 0);
		V, Rdy: out std_logic;
		N: out std_logic; 
		Z: out std_logic);
end component ;
type STAT_AU is (free,mpy,mpyl);
	signal st:STAT_AU;
	signal b,q,d,y,fy,aretc,aretco:std_logic_VECTOR(15 downto 0);
	signal c0,c15,csh,zlsm,wr,mult,outhl, clk:std_logic;
	signal rlsm,rdym,zmpy,nmpy:std_logic;
	signal cnzr,cnzo,cnzi:std_logic_VECTOR(2 downto 0);	 
	signal Quotient1: std_logic_VECTOR(15 downto 0);
begin

U_FM: FM port map(C, RST,
WR=>wr, INCQ=>outhl, CALL=>CALL,
AB=>AB, AD=>AD, AQ=>AQ,
ARETC=>aretc,
Q=>q, B=>b, D=>d,
ARETCO=>aretco);
aretc<=cnzr&ARET(12 downto 0);
cnzo<=aretco(15 downto 13);
ARETO<=aretco(13 downto 0);

U_LSM:LSM port map(F=>ACOP(2 downto 0),
A=>d,B=>b,Y =>y, RDY=>rlsm,
C15=>c15, Z =>zlsm );

U_MPU:div port map(Clk=>C,RST=>RST,	St => '1',
START=>mult, 
Dbus1=>X"0000",
Dbus2=>d,
Dbus3=>b,
RDY=>rdym,Z=>zmpy,
N=>nmpy, Quotient => Quotient1, FY=>fy);
MUX_Q: q<=fy when ACOP="110" else
cnzi(1)&d(15 downto 1) when ACOP="101" else
DI when WRD='1' else
d when RD='1' else y;
SR:process(C,RST)
begin
if RST='1' then
cnzi<="000";
elsif C='1' and C'event then
if RET='1' then
cnzi<=cnzo;
elsif st=mpyl then
cnzi<='0'&nmpy&zmpy;
elsif mult='0' then
cnzi<=c15&y(15)&zlsm;
end if;
end if;
end process;
mult<='1' when ACOP="110" else '0';
FSM_AU:process(C,RST)
begin
if RST='1' then
st<=free;
elsif C='1' and C'event then
case st is
when free => if START='1'and mult='1'then
st<=mpy;
end if;
when mpy=> if rdym='1' then
st<=mpyl ;
end if;
when mpyl=> st<=free;
end case;
end if;											  
end process;
outhl<='1' when st=mpyl else '0';
wr<='1' when WRD='1' or st=mpyl or (st=mpy and rdym='1') or (START='1' and mult='0') else '0';
RDY<='1' when st=mpyl or (WRD='0' and st/=mpy and mult='0') else'0';
DO<=q;
BO<=B;
CNZ<=cnzi;
end BEH;
