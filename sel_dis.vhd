library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sel_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  
		  led_s_bal: in std_logic_vector(7 downto 0);
		  D70_bal: in std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  led_s_good: in std_logic_vector(7 downto 0);
		  D70_good: in std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  led_s:out std_logic_vector(7 downto 0);
		  D70:out std_logic_vector(7 downto 0)
	 );
end sel_dis;

architecture arch_sel_dis of sel_dis is
begin
    led_s <= led_s_good when st="001" else
	          led_s_bal  when st="010" else
				 led_s_bal  when st="011" else
				 "11111111";
				 
	 D70 <= D70_good when st="001" else
	        D70_bal  when st="010" else
			  D70_bal  when st="011" else
			  "11111100"; 
end arch_sel_dis;