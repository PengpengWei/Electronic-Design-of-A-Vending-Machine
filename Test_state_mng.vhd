library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Test_state_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;   --为1表示正常工作，0表示复位
		  confirm: in std_logic; --为1表示进入付款模式，否则在挑选模式
		  balance: in std_logic; --为1表示显示余额，否则显示货名
		  
		  in_half: in std_logic;
		  in_one: in std_logic;
		  in_five: in std_logic;
		  in_ten: in std_logic;
		  price: in std_logic_vector(8 downto 0);
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
	 );
end Test_state_mng;

architecture arch_st_mng of Test_state_mng is
component Test_bal_mng_dis is
    port(
	     clk: in std_logic;
		  reset: in std_logic;
		  st: in std_logic_vector(2 downto 0);
        in_half: in std_logic;
		  in_one: in std_logic;
		  in_five: in std_logic;
		  in_ten: in std_logic;
		  price: in std_logic_vector(8 downto 0);
		  
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
		  
		  --suc: out std_logic  --指示付钱成功
	 );
end component;

component state_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;   --为1表示正常工作，0表示复位
		  confirm: in std_logic; --为1表示进入付款模式，否则在挑选模式
		  balance: in std_logic; --为1表示显示余额，否则显示货名
		  
		  st:out std_logic_vector(2 downto 0)
	 );
end component;

component NFD is
    port(
	     clock: in std_logic;
		  clk : out std_logic
	 );
end component;

signal clkND:std_logic;
signal st:std_logic_vector(2 downto 0);

begin
bal_mng: Test_bal_mng_dis port map(clkND,reset,st,in_half,in_one,in_five,in_ten,price,led_s70,D70);
st_mng: state_mng port map(clkND,reset,confirm,balance,st);
fd: NFD port map(clk,clkND);
end arch_st_mng;