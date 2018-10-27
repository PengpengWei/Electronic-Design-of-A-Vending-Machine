library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity good_mng is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  st:in std_logic_vector(2 downto 0);
		  PageUp:in std_logic;
		  PageDown:in std_logic;
		  
		  goodno: out std_logic_vector(2 downto 0)
	 );
end good_mng;

architecture arch_good of good_mng is

type State is(s0,s1,s2,s3);
--type SeqNum is(sq0,sq1,sq2,sq3,sq4,sq5);  --暂定为5种饮料，1个空位
type PageState is(sre,sno,sup,sdn,sfin);
signal exst: State;
signal updown:std_logic_vector(1 downto 0);
signal goodstate: std_logic_vector(2 downto 0); --货号状态
signal pagest: PageState; --翻页状态

begin
    updown <= PageUp & PageDown;
	 
	--根据输入状态代码和reset，决定状态
    update_St:process(reset,clk)
	 begin
	     if(clk'event and clk = '1') then
		      case st is
				    when "000" =>
					     exst <= s0;
					 when "001" =>
					     if(reset='0') then
						     exst <= s0;
						  else
						     exst <= s1;
						  end if;
					 when "010" =>
					     if(reset='0') then
						     exst <= s0;
						  else
						     exst <= s2;
						  end if;
					 when "011" =>
					     if(reset='0') then
						     exst <= s0;
						  else
						     exst <= s3;	
						  end if;
					 when others =>
					     exst <= s0;
				end case;
		  end if;
	 end process update_St;
	 
	 --更新翻页状态
	 update_page:process(clk)
	 variable goodseq:integer; --暂且认定有5种货物，一个空状态.1.2.3.4.5.6
	 begin
	     if(clk'event and clk='1') then
		      case pagest is
				    when sre =>
					     if(reset='0' or exst=s0 or exst=s3) then
						      pagest <= sre;
								goodseq := 1;
						  else
						      pagest <= sno;
								goodseq := 1;
						  end if;
				    when sno =>
					     if(reset='0' or exst=s0) then
						      pagest <= sre;
								goodseq := 1;
						  else
						      if(updown="10") then
								    pagest <= sup;
									 goodseq := goodseq;
								elsif(updown="01") then
								    pagest <= sdn;
									 goodseq := goodseq;
								else
								    pagest <= sno;
									 goodseq := goodseq;
								end if;
						  end if;
					 when sup =>
					     if(reset='0' or exst=s0) then
						      pagest <= sre;
								goodseq := 1;
						  else
						      if(exst=s3) then
								    pagest <= sno;
									 goodseq := goodseq;
								else
								    pagest <= sfin;
									 goodseq := goodseq + 1;
								end if;
						  end if;
					 when sdn =>
					     if(reset='0' or exst=s0) then
						      pagest <= sre;
								goodseq := 1;
						  else
						      if(exst=s3) then
								    pagest <= sno;
									 goodseq := goodseq;
								else
								    pagest <= sfin;
									 goodseq := goodseq - 1;
								end if;
						  end if;
					 when sfin =>
					     if(reset='0' or exst=s0) then
						      pagest <= sre;
								goodseq := 1;
						  elsif(updown="00") then
						      pagest <= sno;
								goodseq := goodseq;
						  else
						      pagest <= sfin;
								goodseq := goodseq;
						  end if;
					 when others =>
					     pagest <= sre;
						  goodseq := 1;
				end case;
				if(goodseq=7) then
				    goodseq := 1;
				elsif(goodseq=0) then
				    goodseq := 6;
				end if;
				
				case goodseq is
				    when 1 => goodstate <= "000";
					 when 2 => goodstate <= "001";
					 when 3 => goodstate <= "010";
					 when 4 => goodstate <= "011";
					 when 5 => goodstate <= "100";
					 when 6 => goodstate <= "101";
					 when others => goodstate <= "101";
				end case;
		  end if;
	 end process update_page;
	 
	 goodno <= goodstate;
	 
end arch_good;