library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity good_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  clk:in std_logic;
		  reset:in std_logic;   --置0为复位状态
		  
		  goodno:in std_logic_vector(2 downto 0);
		  
		  suc:in std_logic; --付款成功状态
		  
		  inc:in std_logic; --添加饮料状态
		  
		  price: out std_logic_vector(8 downto 0);
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
	 );
end good_dis;

architecture arch_good_dis of good_dis is
type State is(s0,s1,s2,s3);
type DisplaySet is array (7 downto 0) of std_logic_vector(7 downto 0);
type NameCharSet is array(3 downto 0) of std_logic_vector(7 downto 0);
type NumArray is array(5 downto 0) of std_logic_vector(3 downto 0); --用于表示剩余饮料(0~9)
constant NULLCHAR: NameCharSet:=("11010101","11000111","11100011","11100011");
constant COLACHAR: NameCharSet:=("11100101","11000101","11100011","00010001");
constant COFFCHAR: NameCharSet:=("11100101","11000101","01110001","01110001");
constant TEACHAR:  NameCharSet:=("11111111","11100001","01100001","00010001");
constant BEERCHAR: NameCharSet:=("11000001","01100001","01100001","11110101");
constant JUICCHAR: NameCharSet:=("10001111","11000111","11110011","11100101");

signal exst: State;
signal goodcache: DisplaySet; --显示缓存
signal residue: NumArray; --用于表示剩余饮料数
signal price_in: std_logic_vector(8 downto 0); --内部的价格信号
signal cont:std_logic_vector(2 downto 0); --内部计数器

--规定饮料价格不大于99.5

begin
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
	 
	 update_res:process(clk)
	 variable isJudge:std_logic; --标识位，用于标记是否扣过钱
	 variable isAdd:std_logic;  --标识位，用于标记是否已经添加了饮料
	 begin
	 if(clk'event and clk='1') then
	     case exst is
		      when s0 =>
				    if(reset='0') then
					     residue <= ("1001","1001","1001","1001","1001","0000");
						  isJudge := '0';
						  isAdd := '0';
					 else
					     residue <= residue;
						  isJudge := '0';
						  isAdd := '0';
					 end if;
				when s1 =>
				    if(reset='0') then
					     residue <= ("1001","1001","1001","1001","1001","0000");
						  isJudge := '0';
						  isAdd := '0';
					 else
					     if(inc='1' and isAdd='0') then
						      case goodno is
								    when "000" => residue <= residue;
									 when "001" =>
									     if(residue(1)="1001") then
										      residue <= residue;
										  else
										      residue(1) <= residue(1) + 1;
										  end if;
									 when "010" =>
									     if(residue(2)="1001") then
										      residue <= residue;
										  else
										      residue(2) <= residue(2) + 1;
										  end if;
									 when "011" =>
									     if(residue(3)="1001") then
										      residue <= residue;
										  else
										      residue(3) <= residue(3) + 1;
										  end if;
									 when "100" =>
									     if(residue(4)="1001") then
										      residue <= residue;
										  else
										      residue(4) <= residue(4) + 1;
										  end if;
									 when "101" => 
									     if(residue(5)="1001") then
										      residue <= residue;
										  else
										      residue(5) <= residue(5) + 1;
										  end if;
									 when others => residue <= residue;
								end case;
								isAdd := '1';
								isJudge := '0';
						  elsif(inc='1' and isAdd='1') then
						      residue <= residue;
								isAdd := '1';
								isJudge := '0';
						  else
						      residue <= residue;
								isAdd := '0';
								isJudge := '0';
						  end if;
					 end if;
				when s2 =>
				    if(reset='0') then
					     residue <= ("1001","1001","1001","1001","1001","0000");
						  isJudge := '0';
						  isAdd := '0';
					 else
					     residue <= residue;
						  isJudge := '0';
						  isAdd := '0';
					 end if;
				when s3 =>
				    if(reset='0') then
					     residue <= ("1001","1001","1001","1001","1001","0000");
						  isJudge := '0';
						  isAdd := '0';
					 else
					     if(suc='1' and isJudge='0') then
						      case goodno is
								    when "000" => residue <= residue;
									 when "001" => 
									     if(residue(1)="0000") then
										      residue(1) <= "0000";
										  else
										      residue(1) <= residue(1) - 1;
										  end if;
									 when "010" =>
									     if(residue(2)="0000") then
										      residue(2) <= "0000";
										  else
										      residue(2) <= residue(2) - 1;
										  end if;
									 when "011" =>
									     if(residue(3)="0000") then
										      residue(3) <= "0000";
										  else
										      residue(3) <= residue(3) - 1;
										  end if;
									 when "100" =>
									     if(residue(4)="0000") then
										      residue(4) <= "0000";
										  else
										      residue(4) <= residue(4) - 1;
										  end if;
									 when "101" =>
									     if(residue(5)="0000") then
										      residue(5) <= "0000";
										  else
										      residue(5) <= residue(5) - 1;
										  end if;
									 when others => residue <= residue;
								end case;
								isJudge := '1';
							   isAdd := '0';	
						  elsif(suc='1') then
						      residue <= residue;
								isJudge := '1';
								isAdd := '0';
						  else  --付款失败
						      residue <= residue;
								isJudge := '0';
								isAdd := '0';
						  end if;
					 end if;
				when others =>
				    residue <= ("1001","1001","1001","1001","1001","0000");
					 isJudge := '0';
					 isAdd := '0';
		  end case;
	 end if;
	 end process;
	 
	 --名称更新
	 update_goodname:process(clk)
	 begin
	 if(clk'event and clk='1') then
	     case goodno is
		       when "000" =>
				     goodcache(7) <= NULLCHAR(3);
					  goodcache(6) <= NULLCHAR(2);
					  goodcache(5) <= NULLCHAR(1);
					  goodcache(4) <= NULLCHAR(0);
				 when "001" =>
				     goodcache(7) <= COFFCHAR(3);
					  goodcache(6) <= COFFCHAR(2);
					  goodcache(5) <= COFFCHAR(1);
					  goodcache(4) <= COFFCHAR(0);
				 when "010" =>
				     goodcache(7) <= COLACHAR(3);
					  goodcache(6) <= COLACHAR(2);
					  goodcache(5) <= COLACHAR(1);
					  goodcache(4) <= COLACHAR(0);
				 when "011" =>
				     goodcache(7) <= TEACHAR(3);
					  goodcache(6) <= TEACHAR(2);
					  goodcache(5) <= TEACHAR(1);
					  goodcache(4) <= TEACHAR(0);
				 when "100" =>
				     goodcache(7) <= BEERCHAR(3);
					  goodcache(6) <= BEERCHAR(2);
					  goodcache(5) <= BEERCHAR(1);
					  goodcache(4) <= BEERCHAR(0);
				 when "101" =>
				     goodcache(7) <= JUICCHAR(3);
					  goodcache(6) <= JUICCHAR(2);
					  goodcache(5) <= JUICCHAR(1);
					  goodcache(4) <= JUICCHAR(0);
				 when others =>
				     goodcache(7) <= NULLCHAR(3);
					  goodcache(6) <= NULLCHAR(2);
					  goodcache(5) <= NULLCHAR(1);
					  goodcache(4) <= NULLCHAR(0);
		  end case;
	 end if;
	 end process update_goodname;
	 
	 update_respridis:process(clk)
	 variable posten:std_logic_vector(3 downto 0);
	 variable posone:std_logic_vector(3 downto 0);
	 variable poshalf:std_logic;
	 variable thisres:std_logic_vector(3 downto 0);
	 begin
	 if(clk'event and clk='1') then
	     posten := (price_in(8) & price_in(7)) & (price_in(6) & price_in(5));
		  posone := (price_in(4) & price_in(3)) & (price_in(2) & price_in(1));
		  poshalf := price_in(0);
	     if(price_in = "111111111") then
		      goodcache(3) <= "00000010";
				goodcache(2) <= "11111110";
				goodcache(1) <= "11111100";
				goodcache(0) <= "11111100";
		  else
		      case goodno is
				    when "000" => thisres := residue(0);
					 when "001" => thisres := residue(1);
					 when "010" => thisres := residue(2);
					 when "011" => thisres := residue(3);
					 when "100" => thisres := residue(4);
					 when "101" => thisres := residue(5);
					 when others => thisres:= residue(0);
				end case;
				
		      case thisres is
				    when "0000" => goodcache(3) <= "11111111";
					 when "0001" => goodcache(3) <= "10011111";
					 when "0010" => goodcache(3) <= "00100101";
					 when "0011" => goodcache(3) <= "00001101";
					 when "0100" => goodcache(3) <= "10011001";
					 when "0101" => goodcache(3) <= "01001001";
					 when "0110" => goodcache(3) <= "01000001";
					 when "0111" => goodcache(3) <= "00011111";
					 when "1000" => goodcache(3) <= "00000001";
					 when "1001" => goodcache(3) <= "00001001";
					 when others => goodcache(3) <= "11111111";
				end case;
		  
		      case posten is
				    when "0000" => goodcache(2) <= "11111111";
					 when "0001" => goodcache(2) <= "10011111";
					 when "0010" => goodcache(2) <= "00100101";
					 when "0011" => goodcache(2) <= "00001101";
					 when "0100" => goodcache(2) <= "10011001";
					 when "0101" => goodcache(2) <= "01001001";
					 when "0110" => goodcache(2) <= "01000001";
					 when "0111" => goodcache(2) <= "00011111";
					 when "1000" => goodcache(2) <= "00000001";
					 when "1001" => goodcache(2) <= "00001001";
					 when others => goodcache(2) <= "11111111";
				end case;
				
				case posone is
				    when "0000" => goodcache(1) <= "00000010";
					 when "0001" => goodcache(1) <= "10011110";
					 when "0010" => goodcache(1) <= "00100100";
					 when "0011" => goodcache(1) <= "00001100";
					 when "0100" => goodcache(1) <= "10011000";
					 when "0101" => goodcache(1) <= "01001000";
					 when "0110" => goodcache(1) <= "01000000";
					 when "0111" => goodcache(1) <= "00011110";
					 when "1000" => goodcache(1) <= "00000000";
					 when "1001" => goodcache(1) <= "00001000";
					 when others => goodcache(1) <= "11111110";
				end case;
				
				case poshalf is
				    when '0' => goodcache(0) <= "00000011";
					 when '1' => goodcache(0) <= "01001001";
					 when others => goodcache(0) <= "11111111";
				end case;
		  end if;
	 end if;
	 end process update_respridis;
	 
	 --价格更新
	 price_in <= "111111111" when goodno="000" else
	             "000100001" when goodno="001" and residue(1)/="000" else
				    "000000111" when goodno="010" and residue(2)/="000" else
				    "000001000" when goodno="011" and residue(3)/="000" else
				    "000001101" when goodno="100" and residue(4)/="000" else
				    "000001010" when goodno="101" and residue(5)/="000" else
				    "111111111";
	price <= price_in;
	
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
	 D70 <= goodcache(0) when cont = "000" else
	        goodcache(1) when cont = "001" else
			  goodcache(2) when cont = "010" else
			  goodcache(3) when cont = "011" else
			  goodcache(4) when cont = "100" else
			  goodcache(5) when cont = "101" else
			  goodcache(6) when cont = "110" else
			  goodcache(7) when cont = "111" else
			  "11111111";
	 
end arch_good_dis;