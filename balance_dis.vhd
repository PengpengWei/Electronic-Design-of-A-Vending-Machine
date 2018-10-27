library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity balance_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  clk:in std_logic;
		  reset:in std_logic;   --置0为复位状态
		  
		  ten_in: in std_logic_vector(3 downto 0);
		  one_df_in: in std_logic_vector(4 downto 0);
		  suc: in std_logic;
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
	 );
end balance_dis;

architecture arch_bal_dis of balance_dis is
    type State is(s0,s1,s2,s3);
	 type DisplaySet is array (7 downto 0) of std_logic_vector(7 downto 0);
	 --StateCharSet用于定义一串长度为4的显示
	 type StateCharSet is array(3 downto 0) of std_logic_vector(7 downto 0);
	 
	 --状态字符七(8)段码信号
	 constant BALCHAR: StateCharSet:=("11000001","00010001","11100011","11111111");
	 constant FAILCHAR: StateCharSet:=("01110001","00010001","11110011","11100011");
	 constant SUCCHAR: StateCharSet:=("01001001","11000111","11100101","11111111");
	 
	 --显示缓存
	 signal balcache: DisplaySet;
	 
	 --状态位:外部状态
	 signal exst: State;
	 signal cont: std_logic_vector(2 downto 0);
begin

    updateSt: process(clk)
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
	 end process updateSt;
	 
	 updatebal: process(st,suc,clk)
	 variable bal_one: std_logic_vector(3 downto 0);
	 variable digchar:StateCharSet;
	 begin
	 if(clk'event and clk='1') then
	 --安排余额显示缓存
	     bal_one := (one_df_in(4) & one_df_in(3)) & (one_df_in(2) & one_df_in(1));
	     case ten_in is
		      when "0000" => digchar(3) := "11111111";
				               digchar(2) := "11111111";
				when "0001" => digchar(3) := "11111111";
				               digchar(2) := "10011111";
				when "0010" => digchar(3) := "11111111";
				               digchar(2) := "00100101";
				when "0011" => digchar(3) := "11111111";
				               digchar(2) := "00001101";
				when "0100" => digchar(3) := "11111111";
				               digchar(2) := "10011001";
				when "0101" => digchar(3) := "11111111";
				               digchar(2) := "01001001";
				when "0110" => digchar(3) := "11111111";
				               digchar(2) := "01000001";
				when "0111" => digchar(3) := "11111111";
				               digchar(2) := "00011111";
				when "1000" => digchar(3) := "11111111";
				               digchar(2) := "00000001";
								
				when "1001" => digchar(3) := "11111111";
				               digchar(2) := "00001001";
				when "1010" => digchar(3) := "10011111";
				               digchar(2) := "00000011";
				when "1011" => digchar(3) := "10011111";
				               digchar(2) := "10011111";
				when "1100" => digchar(3) := "10011111";
				               digchar(2) := "00100101";
				when "1101" => digchar(3) := "10011111";
				               digchar(2) := "00001101";
				when "1110" => digchar(3) := "10011111";
				               digchar(2) := "10011001";
				when "1111" => digchar(3) := "10011111";
				               digchar(2) := "01001001";
				
				when others => digchar(3) := "11111111";
				               digchar(2) := "11111111";
		  end case;
		  
		  case bal_one is
		      when "0000" => digchar(1) := "00000010";
			   when "0001" => digchar(1) := "10011110";
				when "0010" => digchar(1) := "00100100";
			   when "0011" => digchar(1) := "00001100";
				when "0100" => digchar(1) := "10011000";
				when "0101" => digchar(1) := "01001000";
			   when "0110" => digchar(1) := "01000000";
				when "0111" => digchar(1) := "00011110";
			   when "1000" => digchar(1) := "00000000";
				when "1001" => digchar(1) := "00001000";
				when others => digchar(1) := "00000010";
		  end case;
		  
		  case one_df_in(0) is
		      when '1' => digchar(0) := "01001001";
				when '0' => digchar(0) := "00000011";
				when others => digchar(0) := "00000011";
		  end case;
		  
	 --根据状态，确定显示缓存内容
	     if(exst=s0) then
		      balcache <= ("11111111","11111111","11111111","11111111",
				             "11111111","11111111","11111111","11111111");
		  elsif(exst=s1 or exst=s2) then
		      balcache <= (BALCHAR(3),BALCHAR(2),BALCHAR(1),BALCHAR(0),
				             digchar(3),digchar(2),digchar(1),digchar(0));
		  elsif(exst=s3) then
		      if(suc='1') then
				    balcache <= (SUCCHAR(3),SUCCHAR(2),SUCCHAR(1),SUCCHAR(0),
					              digchar(3),digchar(2),digchar(1),digchar(0));
				else
				    balcache <= (FAILCHAR(3),FAILCHAR(2),FAILCHAR(1),FAILCHAR(0),
					              digchar(3),digchar(2),digchar(1),digchar(0));
				end if; --for suc
		  end if;  --for exst
	 end if;   --for clock
	 end process updatebal;
	 
	 cnt: process(clk,reset)
	 begin
	 if(clk'event and clk='1') then
	     if(reset='0') then
		      cont <= "111";
		  else
		      cont <= cont + 1;
		  end if;
	 end if;--for clock
	 end process cnt;
	 
	 --这样写是为了让A20和D70经由相同的控制信号控制输出，以达到同步的效果
	 led_s70 <= "00000001" when cont = "000" else
	        "00000010" when cont = "001" else
			  "00000100" when cont = "010" else
			  "00001000" when cont = "011" else
			  "00010000" when cont = "100" else
			  "00100000" when cont = "101" else
			  "01000000" when cont = "110" else
			  "10000000" when cont = "111" else
			  "00000000";
	 D70 <= balcache(0) when cont = "000" else
	        balcache(1) when cont = "001" else
			  balcache(2) when cont = "010" else
			  balcache(3) when cont = "011" else
			  balcache(4) when cont = "100" else
			  balcache(5) when cont = "101" else
			  balcache(6) when cont = "110" else
			  balcache(7) when cont = "111" else
			  "11111111";

end arch_bal_dis;