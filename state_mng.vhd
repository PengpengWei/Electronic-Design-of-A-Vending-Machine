library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity state_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;   --为1表示正常工作，0表示复位
		  confirm: in std_logic; --为1表示进入付款模式，否则在挑选模式
		  balance: in std_logic; --为1表示显示余额，否则显示货名
		  
		  st:out std_logic_vector(2 downto 0)
	 );
end state_mng;

architecture arch_state_mng of state_mng is
    type State is(s0,s1,s2,s3);
	 signal exst: State;
begin
    process(clk)
	 begin
	 if(clk'event and clk='1') then
	     case exst is
		      when s0 =>
				    if(reset='0') then
					     exst <= s0;
					 else
					     if(confirm='0') then
						      if(balance='0') then
								    exst <= s1;  --显示货物名
								else
								    exst <= s2;  --显示余额
								end if;
						  else
						      exst <= s0; --输入有误，维持初始状态
						  end if;
					 end if;
				when s1 =>
				    if(reset='0') then
					     exst <= s0;
					 else
					     if(confirm='1') then
						      exst <= s3;  --进入付款模式
						  else
						      if(balance='0') then
								    exst <= s1;  --显示货物名
								else
								    exst <= s2;  --显示余额
								end if;
						  end if;
					 end if;
				when s2 =>
				    if(reset='0') then
					     exst <= s0;
					 else
					     if(confirm='1') then
						      exst <= s3;  --进入付款模式
						  else
						      if(balance='0') then
								    exst <= s1;  --显示货物名
								else
								    exst <= s2;  --显示余额
								end if;
						  end if;
					 end if;
				when s3 =>
				    if(reset='0') then
					     exst <= s0;
					 else
					     if(confirm='1') then
						      exst <= s3;  --维持付款模式
						  else
						      if(balance='0') then
								    exst <= s1;  --显示货物名
								else
								    exst <= s2;  --显示余额
								end if;
						  end if;
					 end if;
				when others =>
				    exst <= s0;
		  end case;
	 end if;
	 end process;
	 
	 st <= "000" when exst=s0 else
	       "001" when exst=s1 else
			 "010" when exst=s2 else
			 "011" when exst=s3 else
			 "000";

end arch_state_mng;