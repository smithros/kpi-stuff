library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use IEEE.std_logic_arith.all;

entity CPU is port(C : in	 std_logic;
		RST : in std_logic;
		RDYP : in std_logic; 
		DI : in std_logic_VECTOR(15 downto 0); 
		WRP : out std_logic; 
		RDP : out std_logic; 
		AP : out std_logic_VECTOR(4 downto 0); 
		DO : out std_logic_VECTOR(15 downto 0));
end CPU;
architecture BEH of CPU is
	
	component AU port(
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
	end component;	   
	
	component ICTR is
		port(C, RST: in std_logic;
			D : in std_logic_VECTOR(13 downto 0); 
			I : in std_logic_VECTOR(9 downto 0); 
			B : in std_logic_VECTOR(13 downto 0); 
			F : in std_logic_VECTOR(3 downto 0); 
			ARETI: in std_logic_VECTOR(13 downto 0); 
			A : out std_logic_VECTOR(13 downto 0); 
			ARET : out std_logic_VECTOR(13 downto 0));
	end component ;	 
	
	component RAM is port(C : in std_logic;
			RST : in std_logic;
			WR: in std_logic; 
			AD : in STD_LOGIC_VECTOR(13 downto 0); 	
			DI : in STD_LOGIC_VECTOR(15 downto 0);
			DO : out STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
	component COP is port(C,RST: in std_logic;
			RDYA : in std_logic; 
			RDYP : in std_logic; 
			IRG0 : in std_logic_VECTOR(15 downto 0);
			CNZ : in std_logic_VECTOR(2 downto 0);
			LINST0 : out std_logic; 
			LINST1 : out std_logic; 
			EIRG : out std_logic; 
			EDI : out std_logic; 
			START : out std_logic; 
			RET : out std_logic; 
			WRRET : out std_logic;
			RD : out std_logic; 
			RDP : out std_logic; 
			WR : out std_logic; 
			WRD : out std_logic; 
			WRP : out std_logic; 
			FI : out std_logic_VECTOR(3 downto 0));
	end component;
	
	signal START : std_logic;
	signal RD : std_logic;
	signal WRD,WR : std_logic;
	signal RET, WRRET : std_logic;
	signal CALL : std_logic;
	signal DIA,DIB,DII,DIM,DOM,BO,DOA : std_logic_VECTOR(15 downto 0); 
	signal IRG0,IRG1:std_logic_VECTOR(15 downto 0);  		
	signal AB,AD,AQ : std_logic_VECTOR(2 downto 0);
	signal ARET,ARETO,AM,ADDR  : std_logic_VECTOR(13 downto 0);
	signal ACOP : std_logic_VECTOR(2 downto 0);
	signal RDYA : std_logic;
	signal DISP : std_logic_VECTOR(9 downto 0);
	signal F,L : std_logic_VECTOR(1 downto 0);
	signal FI : std_logic_VECTOR(3 downto 0);
	signal CNZ : std_logic_VECTOR(2 downto 0);
	signal EIRG, EDI:std_logic;
	signal linstr0,linstr1:std_logic;
	signal OP,COND: std_logic_VECTOR(2 downto 0);
	
begin
	MUXD:DIA<=IRG1 when EIRG='1' else DII;
	
	U_A : au port map (C,RST,
		START => START,
		RD => RD,
		WRD => WRD,
		RET => RET,
		CALL => WRRET,
		DI => DIA,
		AB => AB,
		AD => AD,
		AQ => AQ,
		ARET => ARET,
		ACOP => ACOP,
		RDY => RDYA,
		ARETO => ARETO,
		DO => DOA,
		BO => BO,
		CNZ => CNZ);
	
	U_R:RAM port map(C,RST,
		WR=>WR,
		AD =>AM,
		DI =>DOA,  
		DO =>DOM);
	
	U_I: ICTR 	port map(C,RST,
		D=>ADDR,
		I=>DISP, 
		ARETI=>ARETO,	
		B =>BO(13 downto 0),
		F =>FI,
		A =>AM,
		ARET=>ARET);
	
	U_COP: COP 	port map(C,RST,
		RDYA => RDYA,
		RDYP => RDYP, 		  
		IRG0 => IRG0,
		CNZ => CNZ,
		LINST0 => linstr0, 
		LINST1 => linstr1, 
		EIRG => EIRG, 
		EDI => EDI, 
		START => START,
		RET => RET,
		WRRET => CALL,
		RD => RD, 
		RDP => RDP,
		WR => WR,
		WRD => WRD,
		WRP => WRP, 
		FI => FI
	);
	
	MUXI:DII<=DI when EDI='1' else DOM; 	  
	
	IRG:process(C,RST)
	begin  
		if RST='1' then
			IRG0<=X"0000";
			IRG1<=X"0000";
		elsif C='1' and C'event then
			if linstr0='1'then
				IRG0<=DII;
			elsif linstr1='1'then
				IRG1<=DII;
			end if;	 
		end if;
	end process;  
	
	OP<=IRG0(15 downto 13);
	F<=	IRG0(12 downto 11); 
	L<=IRG0(7 downto 6);
	COND<=IRG0(12 downto 10);  
	DISP<=IRG0(9 downto 0);	 
	ADDR<=IRG0(13 downto 0);	 
	AQ<=IRG0(10 downto 8);
	AB<=IRG0(5 downto 3);
	AD<=IRG0(2 downto 0); 
	AP<=IRG0(7 downto 3);	 
	
	FI(3)<='1' when (OP="011" and F(1)='0') or OP="100" else '0';
	
end BEH;
