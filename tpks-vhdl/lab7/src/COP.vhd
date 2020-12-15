Library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

entity COP is port(C,RST: in std_logic;
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
end COP;	

architecture BEH of COP is
	type STATE is (norm, ldimm, r_wd, jump); 
	signal st:STATE;
	signal CALL,BRA,LJMP,RETi: std_logic; 
	signal LD,SD,LI,\IN\,\OUT\,ALOP : std_logic; 
	signal OP,COND: std_logic_VECTOR(2 downto 0);
	signal F: std_logic_VECTOR(1 downto 0);
	signal condy:std_logic; 
	signal del:std_logic; 
begin
	OP<=IRG0(15 downto 13); 
	F<=IRG0(12 downto 11);
	COND<=IRG0(12 downto 10);
	BRA <= '1' when OP="000" else '0';
	LJMP <='1' when OP="001" else '0';
	CALL <='1' when OP="010" else '0';
	LD <= '1' when OP="011" and F="00" else '0'; 
	SD <= '1' when OP="011" and F="01" else '0'; 
	\IN\ <='1' when OP="011" and F="10" else '0';
	\OUT\<='1'when OP="011" and F="11" else '0'; 
	ALOP<='1' when OP="100" else '0'; 
	LI <= '1' when OP="101" else '0'; 
	RETi <='1' when OP="110" else '0';
	
	with COND(2 downto 1) select
	condy<= COND(0) when "00",
	COND(0) xnor CNZ(0) when "01",
	COND(0) xnor (CNZ(2) xor CNZ(1)) when "10",
	COND(0) xnor CNZ(2) when "11",
	'0' when others;
	
	FSM:process(C,RST)
	begin
		if RST='1' then
			st<=norm;
		elsif C='1' and C'event then
			case st is
				when norm=> 
					if LI='1' then					
						st<=ldimm;
					end if;
					if (LD or SD or ((\OUT\ or \IN\) and RDYP))='1' then
						st<=r_wd;
					end if;
					if (BRA and condy)='1' or (LJMP or CALL or RETi)='1' then
						st<=jump;
				end if;
				when ldimm=>st<=norm;
				when r_wd=> st<=norm;
				when jump=> st<=norm;
			end case ;
		end if;
	end process;
	del<=(ALOP and not rdya) or ((\IN\ or \OUT\) and not RDYP); 
	FI(3)<='1' when ((LD or SD)='1') and (st/=r_wd) else '0';
	FI(2)<='0' when del='1' or (((LD or SD)='1') and (st=norm)) or \OUT\='1'
	or (BRA='1'and st/=jump and condy='0') else'1';
	FI(1 downto 0)<="01" when LJMP='1' or CALL='1' else 
	"10" when RETi='1' else 
	"11" when BRA='1' and st/=jump and condy='1' else 
	"00" ; 
	LINST0<= '1' when (del='0' and st=norm 
	and ((BRA and condy) or CALL or RETi or LJMP or LI
	or \IN\ or \OUT\ or LD or SD)='0') or st/=norm else '0';
	LINST1<='1' when LI='1' and st/=ldimm else '0';
	WRRET<='1' when CALL='1' and st/=jump else '0';
	WR<='1' when st=norm and SD='1' else '0';
	WRD<='1' when ((LD or \IN\) ='1'and st/=r_wd) 
	or st=ldimm else '0'; 
	EDI<= '1' when \IN\='1' and st=norm else '0';
	EIRG<='1' when st=ldimm else '0';
	START<= ALOP;
	RET<=RETi;
	RD<=SD or \OUT\;
	RDP<=\IN\;
	WRP<=\OUT\;
end BEH;
