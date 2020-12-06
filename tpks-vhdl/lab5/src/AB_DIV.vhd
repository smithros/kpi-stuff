library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity AB_DIV is
	port(Clk, St: in std_logic;
		Dbus: in std_logic_vector(15 downto 0);
		Quotient: out std_logic_vector(15 downto 0);
		V, Rdy: out std_logic) ;
end AB_DIV; 

architecture BEH of AB_DIV is
	constant zero_vector: std_logic_vector(31 downto 0):=(others=>'0');
	signal State: integer range 0 to 6;
	signal Count : integer range 0 to 15;
	signal C,NC: std_logic;
	signal Divisor,Sum,Compout: std_logic_vector(15 downto 0);
	signal Dividend: std_logic_vector(31 downto 0);
	alias Q: std_logic_vector(15 downto 0) is Dividend(15 downto 0);
	alias Acc: std_logic_vector(15 downto 0) is Dividend(31 downto 16);	
			
	procedure Addvec
	(Add1,Add2: in std_logic_vector;
		Cin: in std_logic;
		signal Sum: out std_logic_vector;
		signal Cout: out std_logic;
		n:in natural) is
	variable C: std_logic; 
	begin
		C := Cin;  
		for i in 0 to n-1 loop    
			Sum(i) <= Add1(i) xor Add2(i) xor C;
			C := (Add1(i) and Add2(i)) or (Add1(i) and C) or (Add2(i) and C);
		end loop;
		Cout <= C;  
	end Addvec;
begin
	compout<=divisor when divisor (15) = '1'
	else not divisor;
	Addvec(Acc,compout,not divisor(15),Sum,C,16); 
	Quotient <= Q; 
	process
	begin
		wait until Clk = '1'; 
		case State is
			when 0=>
				if St = '1' then
					Acc <= Dbus; 
					State <= 1;
					V <= '0'; 
					Count <= 0; 
					Rdy <= '0';
				end if;
			when 1=>
				Q <= Dbus; 
				State <= 2;
			when 2=>
				Divisor <= Dbus;
				State <= 3;
			when 3 =>
				Dividend <= Dividend(30 downto 0) & '0'; 
				Count <= Count+1;
				State <= 4;
			when 4 =>
				if C ='1' then 
					v <= '1';
					State <= 0;
				else 
					Dividend <= Dividend(30 downto 0) & '0'; 
					Count <= Count+1;
					State <= 5;
				end if;
			when 5 =>
				if C = '1' then 
					ACC <= Sum; 
					Q(0)<= '1';
				else
					Dividend <= Dividend(30 downto 0) & '0';
					if Count = 15 then 
						State <= 6; Count <= 0;
					else Count <= Count+1;
					end if;
				end if;
			when 6=>
				if C = '1' then 
					Acc <= Sum; 
				end if;	
				Rdy <= '1';
				State <= 0;
		end case;
		end process;
end BEH;
