library BITLIB;
use BITLIB.all;
use work.bit_pack.all;
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity div is
	port(Clk, St, RST, START: in std_logic;
	Dbus1: in std_logic_VECTOR(15 downto 0);
	Dbus2: in std_logic_VECTOR(15 downto 0); 
	Dbus3: in std_logic_VECTOR(15 downto 0); 
	Quotient: out std_logic_VECTOR(15 downto 0);
	FY: out std_logic_VECTOR(15 downto 0);
		V, Rdy: out std_logic;
		N: out std_logic; 
		Z: out std_logic) ;
end div; 

architecture labdiv of div is
	constant zero_vector: std_logic_VECTOR(31 downto 0):=(others=>'0');
	signal State: integer range 0 to 6;
	signal Count : integer range 0 to 15;
	signal Sign,C,NC: std_logic;
	signal Divisor,Sum,Compout: std_logic_VECTOR(15 downto 0);
	signal Dividend: std_logic_VECTOR(31 downto 0);
	alias Q: std_logic_VECTOR(15 downto 0) is Dividend(15 downto 0);
	alias Acc: std_logic_VECTOR(15 downto 0) is Dividend(31 downto 16);
begin		
	FSM:process(Clk,RST)
variable zi:std_logic;
begin
if RST='1' then
	State<=0; RDY<='0'; N <= '0'; Z <= '0';
elsif Clk='1' and Clk'event then
if START='1' then
	State<=0;
	RDY<='0';
	N <= '0';
	Z <= '0';
if State=6 then
	RDY<='1';
	N <= Q(15);
	zi:='0';
for i in Q'range loop
	zi:=zi or Q(i);
end loop;
Z<= not zi;
elsif State<4 then 
	State<=State+1;
elsif State=4 then 
	if C ='1' then 
					State <= 0;
				else 
					State <= 5;
				end if;
elsif STATE=5 then 
	if Count = 15 then 
		State <= 6;
	else 
		State <=5;
					end if;	
end if;
end if;
end if;
end process;
	compout<=divisor when divisor (15) = '1'
	else not divisor;
	Addvec(Acc,compout, not divisor(15),Sum,C,16); 
	Quotient <= Q;
	process
	begin
		wait until Clk = '1'; 
		case State is
			when 0=>
				if St = '1' then
					Acc <= Dbus1; 
					Sign <= Dbus1(15);	
					--State <= 1; 
					FY <= X"0000";
					V <= '0'; 
					Count <= 0; 
				end if;
			when 1=>
				Q <= Dbus2; 
				--State <= 2;
			when 2=>
				Divisor <= Dbus3;
				if Sign ='1'then
					Addvec(not Dividend, zero_vector, '1', Dividend, NC, 32);
				end if;
				--State <= 3;
			when 3 =>
				Dividend <= Dividend(30 downto 0) & '0'; 
				Count <= Count+1;
				--State <= 4;
			when 4 =>
				if C ='1' then 
					v <= '1';
					--State <= 0;
				else 
					Dividend <= Dividend(30 downto 0) & '0'; 
					Count <= Count+1;
					--State <= 5;
				end if;
			when 5 =>
				if C = '1' then 
					ACC <= Sum; 
					Q(0)<= '1';
				else
					Dividend <= Dividend(30 downto 0) & '0';
					if Count = 15 then 
						--State <= 6;
						Count <= 0;
					else Count <= Count+1;
					end if;
				end if;
			when 6=>	  
				FY <= Q(15 downto 0);
				if C = '1' then 
					Acc <= Sum; 
				else if (Sign xor Divisor(15))='1' then 
					Addvec(not Dividend,zero_vector,'1',Dividend,NC,32);
				end if; 
				--state <= 0;
				end if;
		end case;
		end process;
end labdiv;