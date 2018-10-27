library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity balance_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;
		  st: in std_logic_vector(2 downto 0);
        in_half: in std_logic;
		  in_one: in std_logic;
		  in_five: in std_logic;
		  in_ten: in std_logic;
		  price: in std_logic_vector(8 downto 0);
		  
		  cancel: in std_logic;  --新增：取消购买，退钱
		  
		  --输出
		  --A20: out std_logic_vector(2 downto 0);
		  --D70: out std_logic_vector(7 downto 0); --abcdefg dp
		  ten_out: out std_logic_vector(3 downto 0);
		  one_df_out: out std_logic_vector(4 downto 0);
		  
		  suc: out std_logic  --指示付钱成功
	 );
end balance_mng;

architecture arch_balance of balance_mng is

    type State is(s0,s1,s2,s3);
--	 type SubState is(s30,s31);
--	 type ButtonState is(sw,s_h,s_1,s_5,s_10,sf);
	 
	 --下面是余额的十位、个位+五毛位
	 signal bal_ten: std_logic_vector(3 downto 0);
	 signal bal_one_df: std_logic_vector(4 downto 0);
	 
	 --下面是价格的十位、个位+五毛位
	 signal pri_ten: std_logic_vector(3 downto 0);
	 signal pri_one_df: std_logic_vector(4 downto 0);
	 
	 --状态位:外部状态和内部状态
	 signal exst: State;
	 
	 signal suctemp: std_logic;
	 
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
	 
	 --读入价格
	 pri_ten <= (price(8) & price(7)) & (price(6) & price(5));
	 pri_one_df <= (price(4) & price(3)) & (price(2) & price(1)) & price(0);
	 

	 motion: process(st,clk)
	 variable bal_one: std_logic_vector(3 downto 0);
	 variable bnarr: std_logic_vector(3 downto 0);
	 variable isChange: std_logic;
	 variable priint,balint: integer;
	 variable temp_pri_one,temp_bal_one: std_logic_vector(3 downto 0);
	 variable previous_cancel:std_logic; --用于记录s2状态外的cancel电位
	 begin
	 
	 if(clk'event and clk = '1') then
	 
	 if(bnarr="0000") then  --根据上一时钟周期的投币输入判断本时钟下应该处于等待，还是锁定
	     isChange := '0';
	 else
	     isChange := '1';
	 end if;
	 
	 
	 bnarr := not ((in_ten & in_five) & (in_one & in_half));  --为下一时钟做准备
	 
	 if(exst=s0) then
	     bnarr := "0000";
	     bal_ten <= "0000";
		  bal_one_df <= "00000";
		  suctemp <= '0';
		  previous_cancel := cancel;
		  
	--充值（处理s1,s2状态的动作）
	 elsif(exst=s1) then
	     if(isChange='0') then  --如果余额在等待改变的状态时
		      if(bnarr(3)='1') then
				    if(bal_ten/="1111") then
				        bal_ten <= bal_ten + 1;
					 end if;
				elsif(bnarr(2)='1') then
				    bal_one := (bal_one_df(4) & bal_one_df(3)) & (bal_one_df(2) & bal_one_df(1));
					 if((bal_one="0000" or bal_one="0001") or bal_one="0010" or (bal_one="0011" or bal_one="0100")) then
					     bal_one_df <= bal_one_df + "01010";
					 else
					     if(bal_ten/="1111") then
					         bal_one := bal_one + "1011";
						      bal_ten <= bal_ten + 1;
						  end if;
						  bal_one_df(4) <= bal_one(3);
						  bal_one_df(3) <= bal_one(2);
						  bal_one_df(2) <= bal_one(1);
						  bal_one_df(1) <= bal_one(0);
					 end if;
				elsif(bnarr(1)='1') then
				    if(bal_one_df="10011" or bal_one_df="10010") then
					     if(bal_ten/="1111") then
						      bal_ten <= bal_ten + 1;
						      bal_one_df <= bal_one_df + "01110"; --6+1
						  end if; 
					 else
					     bal_one_df <= bal_one_df + 2;
					 end if;
				elsif(bnarr(0)='1') then
				    if(bal_one_df="10011") then
					     if(bal_ten/="1111") then
					         bal_ten <= bal_ten + 1;
						      bal_one_df <= "00000";
						  end if;
					 else
					     bal_one_df <= bal_one_df + 1;
					 end if;
				end if;
				
				isChange := '1';
				suctemp <= '0';
				previous_cancel := cancel;
		  else
				suctemp <= '0';
				previous_cancel := cancel;		  
		  end if;
		  
	 elsif(exst=s2) then --显示余额时，可以退钱
	     if(cancel/=previous_cancel) then  --如果cancel电位发生变化
		      bal_one_df <= "00000";
				bal_ten <= "0000";
			   previous_cancel := cancel;
				suctemp <= '0';
				
		  elsif(isChange='0') then  --如果cancel电位不变，余额也在等待改变的状态时
		      if(bnarr(3)='1') then
				    if(bal_ten/="1111") then
				        bal_ten <= bal_ten + 1;
					 end if;
				elsif(bnarr(2)='1') then
				    bal_one := (bal_one_df(4) & bal_one_df(3)) & (bal_one_df(2) & bal_one_df(1));
					 if((bal_one="0000" or bal_one="0001") or bal_one="0010" or (bal_one="0011" or bal_one="0100")) then
					     bal_one_df <= bal_one_df + "01010";
					 else
						  if(bal_ten/="1111") then
						      bal_ten <= bal_ten + 1;
								bal_one := bal_one + "1011";
						  end if;
						  bal_one_df(4) <= bal_one(3);
						  bal_one_df(3) <= bal_one(2);
						  bal_one_df(2) <= bal_one(1);
						  bal_one_df(1) <= bal_one(0);
					 end if;
				elsif(bnarr(1)='1') then
				    if(bal_one_df="10011" or bal_one_df="10010") then
					     if(bal_ten/="1111") then
						      bal_ten <= bal_ten + 1;
								bal_one_df <= bal_one_df + "01110"; --6+1
						  end if;
					 else
					     bal_one_df <= bal_one_df + 2;
					 end if;
				elsif(bnarr(0)='1') then
				    if(bal_one_df="10011") then
					     if(bal_ten/="1111") then
						      bal_ten <= bal_ten + 1;
								bal_one_df <= "00000";
						  end if;
					 else
					     bal_one_df <= bal_one_df + 1;
					 end if;
				end if;
				
				isChange := '1';
				suctemp <= '0';
				previous_cancel := cancel;
		  else
				suctemp <= '0';
				previous_cancel := cancel;		  
		  end if;
	 
	 --扣钱
	 elsif(exst=s3) then
	     if(suctemp='0') then --之前还没有成功付款过
	 --将价格转换为整数
	     priint:=0;
		  balint:=0;
		  case pri_ten is
		      when "0000" => priint := priint + 0;
				when "0001" => priint := priint + 100;
				when "0010" => priint := priint + 200;
				when "0011" => priint := priint + 300;
				when "0100" => priint := priint + 400;
				when "0101" => priint := priint + 500;
				when "0110" => priint := priint + 600;
				when "0111" => priint := priint + 700;
				when "1000" => priint := priint + 800;
				when "1001" => priint := priint + 900;
				when "1010" => priint := priint + 1000;
				when "1011" => priint := priint + 1100;
				when "1100" => priint := priint + 1200;
				when "1101" => priint := priint + 1300;
				when "1110" => priint := priint + 1400;
				when "1111" => priint := priint + 1500;
				when others => priint := priint + 0;
		  end case;
		  
		  case bal_ten is
		      when "0000" => balint := balint + 0;
				when "0001" => balint := balint + 100;
				when "0010" => balint := balint + 200;
				when "0011" => balint := balint + 300;
				when "0100" => balint := balint + 400;
				when "0101" => balint := balint + 500;
				when "0110" => balint := balint + 600;
				when "0111" => balint := balint + 700;
				when "1000" => balint := balint + 800;
				when "1001" => balint := balint + 900;
				when "1010" => balint := balint + 1000;
				when "1011" => balint := balint + 1100;
				when "1100" => balint := balint + 1200;
				when "1101" => balint := balint + 1300;
				when "1110" => balint := balint + 1400;
				when "1111" => balint := balint + 1500;
				when others => balint := balint + 0;
		  end case;
		  
		  temp_pri_one := (pri_one_df(4) & pri_one_df(3)) & (pri_one_df(2) & pri_one_df(1));
		  case temp_pri_one is
		      when "0000" => priint := priint + 0;
				when "0001" => priint := priint + 10;
				when "0010" => priint := priint + 20;
				when "0011" => priint := priint + 30;
				when "0100" => priint := priint + 40;
				when "0101" => priint := priint + 50;
				when "0110" => priint := priint + 60;
				when "0111" => priint := priint + 70;
				when "1000" => priint := priint + 80;
				when "1001" => priint := priint + 90;
				when others => priint := priint + 0;
		  end case;
		  
		  temp_bal_one := (bal_one_df(4) & bal_one_df(3)) & (bal_one_df(2) & bal_one_df(1));
		  case temp_bal_one is
		      when "0000" => balint := balint + 0;
				when "0001" => balint := balint + 10;
				when "0010" => balint := balint + 20;
				when "0011" => balint := balint + 30;
				when "0100" => balint := balint + 40;
				when "0101" => balint := balint + 50;
				when "0110" => balint := balint + 60;
				when "0111" => balint := balint + 70;
				when "1000" => balint := balint + 80;
				when "1001" => balint := balint + 90;
				when others => balint := balint + 0;
		  end case;
		  
		  case pri_one_df(0) is
		      when '0' => priint := priint + 0;
				when '1' => priint := priint + 5;
				when others => priint := priint + 0;
		  end case;
		  
		  case bal_one_df(0) is
		      when '0' => balint := balint + 0;
				when '1' => balint := balint + 5;
				when others => balint := balint + 0;
		  end case;
		  
		  if(balint < priint) then
		      suctemp <= '0';
		  else
		      suctemp <= '1';
				balint := balint - priint;
					 case balint/100 is
					     when 0 => bal_ten <= "0000";
						  when 1 => bal_ten <= "0001";
						  when 2 => bal_ten <= "0010";
						  when 3 => bal_ten <= "0011";
						  when 4 => bal_ten <= "0100";
						  when 5 => bal_ten <= "0101";
						  when 6 => bal_ten <= "0110";
						  when 7 => bal_ten <= "0111";
						  when 8 => bal_ten <= "1000";
						  when 9 => bal_ten <= "1001";
						  when 10 => bal_ten <= "1010";
						  when 11 => bal_ten <= "1011";
						  when 12 => bal_ten <= "1100";
						  when 13 => bal_ten <= "1101";
						  when 14 => bal_ten <= "1110";
						  when 15 => bal_ten <= "1111";
						  when others => bal_ten <= "0000";
					 end case;
					 
					 balint := balint - balint/100*100;
					 case balint/10 is
					     when 0 => temp_bal_one := "0000";
						  when 1 => temp_bal_one := "0001";
						  when 2 => temp_bal_one := "0010";
						  when 3 => temp_bal_one := "0011";
						  when 4 => temp_bal_one := "0100";
						  when 5 => temp_bal_one := "0101";
						  when 6 => temp_bal_one := "0110";
						  when 7 => temp_bal_one := "0111";
						  when 8 => temp_bal_one := "1000";
						  when 9 => temp_bal_one := "1001";
						  when others => temp_bal_one := "0000";
					 end case;
					 
					 balint := balint - balint/10*10;
					 case balint is
					 	  when 0 => bal_one_df <= temp_bal_one & '0';
						  when 5 => bal_one_df <= temp_bal_one & '1';
						  when others => bal_one_df <= temp_bal_one & '0';
					 end case;
		  end if;
		  
		  end if; --for 前面的suctemp，没有缩进也是因为这个判断是后来加的...

	 end if;

    end if; --for clock，没有缩进是因为clk是后来加的。。。
	 end process motion;
	 
	 --测试输出
	 ten_out <= bal_ten;
	 one_df_out <= bal_one_df;
	 suc <= suctemp;
end arch_balance;

