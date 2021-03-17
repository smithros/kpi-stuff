---------------------------------------------------------------------------------------------------
--
-- Title       : FilterTB_R
-- Design      : FilterTB
-- Author      : Anatoilj Sergiyenko
-- Company     : KPI
--
---------------------------------------------------------------------------------------------------
--
-- File        : FilterTB_R.vhd
-- Generated   : Thu Feb 26 07:46:39 2002
---------------------------------------------------------------------------------------------------
--
-- Description :     Testbench for digital filters
--                   for the STD_LOGIC_VECTOR type i/o data
--
---------------------------------------------------------------------------------------------------
-- Copyright (C) by NTUU"KPI"


library IEEE;
use IEEE.STD_LOGIC_1164.all;          
use IEEE.MATH_REAL.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

entity FilterTB is                
	generic(fsampl:integer := 1000; 
		fstrt: integer:=0;
		deltaf:integer:=20;
		maxdelay:integer:=100;
		slowdown:integer:=1;
		magnitude:real:=1000.0;
		nb:natural:=14
		);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		RERSP : in STD_LOGIC_VECTOR(nb-1 downto 0);
		IMRSP : in STD_LOGIC_VECTOR(nb-1 downto 0);
		REO : out STD_LOGIC_VECTOR(nb-1 downto 0);
		IMO : out STD_LOGIC_VECTOR(nb-1 downto 0);
		FREQ : out INTEGER;
		MAGN:out REAL; 
		LOGMAGN:out REAL; 
		PHASE: out REAL ;
		NEXTFR: out STD_LOGIC;
		ENA: inout STD_LOGIC
		);
end FilterTB;              

architecture FilterTB_V of FilterTB is
	signal freqi,REOI,IMOI: integer;    
	signal nextf: STD_LOGIC;    
	signal rdy: STD_LOGIC;    
	signal phasei,phaseo: real;
begin        
	
	SINGEN:process (CLK,RST)
		variable phase:real:=0.0;
		variable i:integer:=0;
	begin                       
		if ( RST='1' ) then     
			REOi<=0;
			IMOi<=0;
			i:=0;                 
			phase:=0.0;   
			nextf<='0';
			nextfr<='0';
		elsif ( CLK='1' and CLK'event ) then          
			if ( ENA='1' ) then
				REOi<=integer(magnitude*COS(2.0*MATH_PI*phase ));
				IMOi<=integer(magnitude*SIN(2.0*MATH_PI*phase));
				phase:=    phase+real(freqi)/real(fsampl);
				i:=i+1;
				if ( i=maxdelay) then
					i:=0;                 
					phase:=0.0;        
					nextf<='1';
				else
					nextf<='0';
				end if;       
				if ( i=maxdelay-1) then
					rdy<='1';  	nextfr<='1';
				else
					rdy<='0';	nextfr<='0';
				end if;             
			end if;   
		end if;    
	end process;
	REO<=conv_std_logic_vector(REOi,nb);
	IMO<=conv_std_logic_vector(IMOi,nb);
	
	SLOWER:process(CLK,RST)
		variable i:integer:=0;
	begin                
		if ( RST='1' ) then
			i:=0;
			ENA<='0';
		elsif ( CLK='1' and CLK'event ) then
			i:=i+1;
			if ( i=slowdown) then
				i:=0;
				ENA<='1';
			else
				ENA<='0';
			end if;        
		end if;    
	end process;          
	
	NEW_FREQ:process(CLK,RST)
	begin    
		if ( RST='1') then
			freqi<=fstrt ;
		elsif ( CLK='1' and CLK'event ) then
			if ( ENA='1' and nextf='1') then
				freqi<=freqi+deltaf; 
			end if;                    
		end if;       
	end process;
	
	FREQ<=freqi;
	
	MEASURE:process(CLK,RST)          
		variable re,im,rei,imi,mag,phasei,phaseo: real:=0.0;    --  
	begin                
		if ( RST='1') then
			MAGN<=0.0; 
			LOGMAGN<=0.0; 
			PHASE<=0.0;
		elsif ( CLK='1' and CLK'event and rdy='1' ) then     
			re:= real(conv_integer(signed(RERSP)))  ;
			im:= real(conv_integer(signed(IMRSP))) ;    
			rei:= real(REOi)  ;
			imi:= real(IMOi) ; 
			mag:=SQRT(re*re+im*im);    
			if ( mag=0.0) then
				mag:=0.0001;  
			end if;        
			MAGN<=(mag);
			LOGMAGN<=20.0*LOG10(mag/magnitude); 
			PHASEi:=ARCTAN(imi,rei);         
			PHASEo:=ARCTAN(im,re);                             
			PHASE<=PHASEo-PHASEi; 
			if (PHASEo-PHASEi >math_pi) then
				PHASE<=PHASEo-PHASEi-2.0*math_pi;      
			else
				PHASE<=PHASEo-PHASEi; 
			end if;      
			if   (PHASEo-PHASEi < (- math_pi)) then
				PHASE<=PHASEo-PHASEi+2.0*math_pi;
			end if;
		end if;
	end process;
	
	
end FilterTB_V;
