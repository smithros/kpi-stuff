library IEEE;
use IEEE.STD_LOGIC_1164.all;

package bit_pack is
	function add4 (reg1,reg2: bit_vector(3 downto 0);carry: bit) 
		return bit_vector;
	function falling_edge(signal clock:bit)
		return Boolean ;
	function rising_edge(signal clock:bit)
		return Boolean ;
	function vec2int(vec1: bit_vector)
		return integer;
	function int2vec(int1,NBits: integer)
		return bit_vector;
	procedure Addvec
		(Add1,Add2: in std_logic_vector;
			Cin: in std_logic;
			signal Sum: out std_logic_vector; 
			signal Cout: out std_logic;
			n: in natural);

	component jkff
		generic(DELAY:time := 10 ns);
		port(SN, RN, J,K,CLK: in bit; Q, QN: inout bit);
	end component;

	component dff   
		generic(DELAY:time := 10 ns);
		port (D, CLK: in bit; Q: out bit; QN: out bit := '1');
	end component;

	component and2
		generic(DELAY:time := 10 ns);
		port(A1, A2: in bit; Z: out bit);
	end component;

	component and3
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3: in bit; Z: out bit);
	end component;

	component and4
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3, A4: in bit; Z: out bit);
	end component;

	component or2
		generic(DELAY:time := 10 ns);
		port(A1, A2: in bit; Z: out bit);
	end component;

	component or3
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3: in bit; Z: out bit);
	end component;



	component or4
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3, A4: in bit; Z: out bit);
		end component;

	component nand2
		generic(DELAY:time := 10 ns);
		port(A1, A2: in bit; Z: out bit);
	end component;

	component nand3
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3: in bit; Z: out bit);
		end component;

	component nand4
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3, A4: in bit; Z: out bit);
	end component;

	component nor2
		generic(DELAY:time := 10 ns);
		port(A1, A2: in bit; Z: out bit);
	end component;

	component nor3
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3: in bit; Z: out bit);
	end component;

	component nor4
		generic(DELAY:time := 10 ns);
		port(A1, A2, A3, A4: in bit; Z: out bit);
	end component;

	component inverter
		generic(DELAY:time := 10 ns);
		port(A : in bit; Z: out bit);
	end component;

	component xor2
		generic(DELAY:time := 10 ns);
		port(A1, A2: in bit; Z: out bit);
	end component;

	component c74163 
		port(LdN, ClrN, P, T, CK: in bit;  D: in bit_vector(3 downto 0);
				Cout: out bit; Q: inout bit_vector(3 downto 0) );
	end component;

	component FullAdder
		generic(DELAY:time := 10 ns);
		port(X, Y, Cin: in bit;
				Cout, Sum: out bit);
	end component;

end bit_pack;
-------------------------------------------------------------

package body bit_pack is

-- This function adds 2 4-bit numbers, returns a 5-bit sum
function add4 (reg1,reg2: bit_vector(3 downto 0);carry: bit) 
	return bit_vector is
variable cout: bit:='0';
variable cin: bit:=carry;
variable retval: bit_vector(4 downto 0):="00000";
begin
lp1: for i in 0 to 3 loop
	cout :=(reg1(i) and reg2(i)) or ( reg1(i) and cin) or 
				(reg2(i) and cin );
	retval(i) := reg1(i) xor reg2(i) xor cin;
	cin := cout; 
end loop lp1;
retval(4):=cout;
return retval;
end add4;

-- Function for falling edge
function falling_edge(signal clock:bit)
	return Boolean is
begin
	return clock'event and clock = '0';
end falling_edge;

-- Function for rising edge
function rising_edge(signal clock:bit)
	return Boolean is
begin
	return clock'event and clock = '1';
end rising_edge;

-- Function vec2int (converts a bit vector to an integer)
function vec2int(vec1: bit_vector)
	return integer is
variable retval: integer:=0;
alias vec: bit_vector(vec1'length-1 downto 0) is vec1;
begin
	for i in vec'high downto 1 loop
		if (vec(i)='1') then
			retval:=(retval+1)*2;
		else
			retval:=retval*2;
		end if;
	end loop;
	if vec(0)='1' then
		retval:=retval+1;
	end if;
	return retval;
end vec2int;



-- Function int2vec (converts a positive integer to a bit vector)
function int2vec(int1,NBits: integer)
	return bit_vector is
variable N1: integer;
variable retval: bit_vector(NBits-1 downto 0);
begin
	assert int1 >= 0
		report "Function int2vec: input integer cannot be negative"
		severity error;
	N1:=int1;
	for i in retval'Reverse_Range loop
		if (N1 mod 2)=1 then 
			retval(i):='1';
		else
			retval(i):='0';
		end if;
		N1:=N1/2;
	end loop;
	return retval;
end int2vec;

-- This procedure adds two n-bit bit_vectors and a carry and 
-- returns an n-bit sum and a carry.  Add1 and Add2 are assumed 
-- to be of the same length and dimensioned n-1 downto 0.
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

end bit_pack;

-- 2 input AND gate
entity And2 is
	generic(DELAY:time);
	port (A1,A2:  in bit;
			Z: out bit);
end And2;
architecture concur of And2 is
begin
	Z <= A1 and A2 after DELAY;
end;



-- 3 input AND gate
entity And3 is
	generic(DELAY:time);
	port (A1,A2, A3:  in bit;
			Z: out bit);
end And3;
architecture concur of And3 is
begin
	Z <= A1 and A2 and A3 after DELAY;
end;

--4 input AND gate
entity And4 is
	generic(DELAY:time);
	port (A1,A2,A3,A4:  in bit;
			Z: out bit);
end And4;
architecture concur of And4 is
begin
	Z <= A1 and A2 and A3 and A4 after DELAY;
end;

--2 input OR gate
entity Or2 is
	generic(DELAY:time);
	port (A1,A2:  in bit;
			Z: out bit);
end Or2;
architecture concur of Or2 is
begin
	Z <= A1 or A2 after DELAY;
end;

--3 input OR gate
entity Or3 is
	generic(DELAY:time);
	port (A1,A2,A3:  in bit;
			Z: out bit);
end Or3;
architecture concur of Or3 is
begin
	Z <= A1 or A2 or A3 after DELAY;
end;

--4 input OR gate
entity Or4 is
	generic(DELAY:time);
	port (A1,A2,A3,A4:  in bit;
			Z: out bit);
end Or4;
architecture concur of Or4 is
begin
	Z <= A1 or A2 or A3 or A4 after DELAY;
end;



--2 input NAND gate
entity Nand2 is
	generic(DELAY:time);
	port (A1,A2:  in bit;
			Z: out bit);
end Nand2;
architecture concur of Nand2 is
begin
	Z <= not (A1 and A2) after DELAY;
end;

--3 input NAND gate
entity Nand3 is
	generic(DELAY:time);
	port (A1,A2, A3:  in bit;
			Z: out bit);
end Nand3;
architecture concur of Nand3 is
begin
	Z <= not (A1 and A2 and A3) after DELAY;
end;

--4 input NAND gate
entity Nand4 is
	generic(DELAY:time);
	port (A1,A2,A3,A4:  in bit;
			Z: out bit);
end NAnd4;
architecture concur of Nand4 is
begin
	Z <= not (A1 and A2 and A3 and A4) after DELAY;
end;

--2 input NOR gate
entity Nor2 is
	generic(DELAY:time);
	port (A1,A2:  in bit;
			Z: out bit);
end Nor2;
architecture concur of Nor2 is
begin
	Z <= not (A1 or A2) after DELAY;
end;

--3 input NOR gate
entity Nor3 is
	generic(DELAY:time);
	port (A1,A2,A3:  in bit;
			Z: out bit);
end Nor3;
architecture concur of Nor3 is
begin
	Z <= not (A1 or A2 or A3) after DELAY;
end;



--4 input NOR gate
entity Nor4 is
	generic(DELAY:time);
	port (A1,A2,A3,A4:  in bit;
			Z: out bit);
end NOr4;
architecture concur of Nor4 is
begin
	Z <= not (A1 or A2 or A3 or A4) after DELAY;
end;

--An INVERTER
entity Inverter is
	generic(DELAY:time);
	port (A:  in bit;
			Z: out bit);
end Inverter;
architecture concur of Inverter is
begin
	Z <= not A after DELAY;
end;

--A 2 INPUT XOR2 GATE
entity XOR2 is
	generic(DELAY:time);
	port (A1,A2:  in bit;
			Z: out bit);
end XOR2;
architecture concur of XOR2 is
begin
	Z <= A1 xor A2 after DELAY;
end;

--JK Flip-flop 
entity JKFF is
	generic(DELAY:time);
	port(SN, RN, J,K,CLK: in bit;
			Q, QN: inout bit);
end JKFF;

use work.bit_pack.all;
architecture JKFF1 of JKFF is
begin
	process(CLK, SN, RN)
	begin
		if RN='0' then
			Q <= '0' after DELAY; 
		elsif SN='0' then
			Q<='1' after DELAY;  
		elsif falling_edge(CLK) then
			Q <= (J and not Q) or (not K and Q) after DELAY;
		end if;
	end process;
	QN <= not Q;
end JKFF1;



--D Flip-flop 
entity DFF is
	generic(DELAY:time);
	port (D, CLK: in bit; 
			Q: out bit; QN: out bit := '1');
	-- initalize QN to '1' since bit signals are initialized to '0' by default
end DFF;
architecture SIMPLE of DFF is
begin
	process(CLK)  
	begin
		if CLK = '1' then  --rising edge of clock
			Q <= D after DELAY;
			QN <= not D after DELAY;
		end if;
	end process;
end SIMPLE;

--74163 COUNTER
entity c74163 is
	port(LdN, ClrN, P, T, CK: in bit;  D: in bit_vector(3 downto 0);
			Cout: out bit; Q: inout bit_vector(3 downto 0) );
end c74163;

use work.bit_pack.all;

architecture b74163 of c74163 is
begin
	Cout <= Q(3) and Q(2) and Q(1) and Q(0) and T;
	process
	begin
		wait until CK = '1';		-- change state on rising edge
		if ClrN = '0' then  Q <= "0000";
		elsif LdN = '0' then Q <= D;
		elsif (P and T) = '1' then  
			Q <= int2vec(vec2int(Q)+1,4);
		end if;
	end process;
end b74163;


--Full Adder
entity FullAdder is
	generic(DELAY:time);
	port(X, Y, Cin: in bit;
			Cout, Sum: out bit);
end FullAdder;

architecture Equations of FullAdder is
begin
	Sum <= X xor Y xor Cin after DELAY;
	Cout <= (X and Y) or (X and Cin) or (Y and Cin) after DELAY;
end Equations;
