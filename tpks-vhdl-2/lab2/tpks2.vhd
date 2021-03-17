library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;   

entity tpks2 is
	port( CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		X : in STD_LOGIC_VECTOR(13 downto 0);
		Y : out STD_LOGIC_VECTOR(13 downto 0)
		);
end tpks2;    
									 
architecture BEH of tpks2 is		
	signal xi, xi_1, xi_2,xi_3,xi_4,qi_1, qi_2, qi_11, qi_12, qi_13, qi_14 ,sm, sm2, pi_1 ,pi_2 :signed(19 downto 0);
	signal yi, yi_1, yi_2, yi_3, yi_4, yi_5, y5i_1:signed(19 downto 0);		  
	signal y1i, y4i :signed(21 downto 0);
	signal y01i, y45i, y45i_1 :signed(21 downto 0);
	signal y2i, y3i, y23i, y03i: signed(22 downto 0);
	signal y05i:signed(13 downto 0);  
begin
	LPF:process(CLK,RST)  
	variable pi, qi, mb, mb2:signed(19 downto 0);
	begin
		if RST = '1' then
			xi <=(others=>'0');	 
			xi_1 <=(others=>'0');
			xi_2 <=(others=>'0');
			qi_1 <=(others=>'0');
			qi_2 <=(others=>'0');
			qi_11 <=(others=>'0');
			qi_12 <=(others=>'0'); 
			qi_13 <=(others=>'0');
			qi_14 <=(others=>'0');
			sm <=(others=>'0');
			sm2 <=(others=>'0');
			pi_1 <=(others=>'0');  
			pi_2 <=(others=>'0');
			yi <=(others=>'0');
		elsif CLK='1' and CLK'event then    
			xi <= RESIZE(signed(X&"000"),20); 
			xi_1 <= xi;
			xi_2 <= xi_1; 	
			qi := xi - sm2;
            qi_1 <= shift_right(qi,1);
            qi_2 <= qi_1;  
			qi_11 <= qi;
			qi_12 <= qi_11;
			qi_13 <= qi_12;
			qi_14 <= qi_13;
	     	pi := -shift_right(qi,2)-shift_right(qi,3);
			pi_1 <= pi;
			pi_2 <= pi_1;
			sm <= qi_2 + pi;
			sm2 <= sm;
			mb := shift_right(qi,1) + pi_2;
			mb2 := qi_14 + mb;
		 	yi <= shift_right(mb2 - xi_2,1);			
		end if;
	end process;
	FIR:process(CLK,RST)
		variable yt:signed(22 downto 0);
	begin
		if RST = '1' then
			yi_1<=(others=>'0'); 
			yi_2<=(others=>'0');
			yi_3<=(others=>'0');
			yi_4<=(others=>'0');
			yi_5<=(others=>'0');
			y5i_1<=(others=>'0'); 
			y1i<=(others=>'0');
			y4i<=(others=>'0');
			y01i<=(others=>'0');
			y45i<=(others=>'0');
			y45i_1<=(others=>'0');
			y2i<=(others=>'0');
			y3i<=(others=>'0');
			y23i<=(others=>'0');
			y03i<=(others=>'0');   
			y05i<=(others=>'0');
		elsif CLK='1' and CLK'event then
			yi_1<= yi;
			yi_2<= yi_1;   
			yi_3<= yi_2;
			yi_4<= yi_3;
			yi_5<= yi_4;
			y5i_1 <= yi_5;
			y1i <= resize((yi_1 &"00"),22) + yi_1 ;
			y01i <= y1i + yi_1 ; 
			y2i <= resize((yi_2 &"000"),23) + (yi_2 &"0") ;	
			y3i <= resize((yi_3 &"000"),23) + (yi_3 &"0") ;
			y23i <= y2i + y3i;
			y4i <= resize((yi_4 &"00"),22) + yi_4 ;
			y45i <= y4i + y5i_1;
			y03i <= y01i + y23i;
			y45i_1 <= y45i;
			yt:= shift_right((y03i + y45i_1), 5);
			y05i<=yt(19 downto 6);
		end if;
	end process;
	Y<= std_logic_vector(y05i);
end BEH;