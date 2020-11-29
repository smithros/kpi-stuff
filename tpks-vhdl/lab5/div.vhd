library BITLIB;
use BITLIB.all;
use work.bit_pack.all;

entity div is
	port(Clk, St: in bit;
		Dbus: in bit_vector(15 downto 0);
		Quotient: out bit_vector(15 downto 0);
		V, Rdy: out bit) ;
end div; 

architecture labdiv of div is
	constant zero_vector: bit_vector(31 downto 0):=(others=>'0');
	signal State: integer range 0 to 6;
	signal Count : integer range 0 to 15;
	signal Sign,C,NC: bit;
	signal Divisor,Sum,Compout: bit_vector(15 downto 0);
	signal Dividend: bit_vector(31 downto 0);
	alias Q: bit_vector(15 downto 0) is Dividend(15 downto 0);
	alias Acc: bit_vector(15 downto 0) is Dividend(31 downto 16);
begin
	compout<=divisor when divisor (15) = '1'
	else not divisor;
	Addvec(Acc,compout,not divisor(15),Sum,C,16); 
	Quotient <= Q;
	Rdy <= '1' when State=0 else '0';
	process
	begin
		wait until Clk = '1'; 
		case State is
			when 0=>
				if St = '1' then
					Acc <= Dbus; 
					Sign <= Dbus(15);
					State <= 1;
					V <= '0'; 
					Count <= 0; 
				end if;
			when 1=>
				Q <= Dbus; 
				State <= 2;
			when 2=>
				Divisor <= Dbus;
				if Sign ='1'then
					Addvec(not Dividend, zero_vector, '1', Dividend, NC, 32);
				end if;
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
				else if (Sign xor Divisor(15))='1' then 
					Addvec(not Dividend,zero_vector,'1',Dividend,NC,32);
				end if; 
				state <= 0;
				end if;
		end case;
		end process;
end labdiv;