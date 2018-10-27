library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity saler is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  
		  row_in:in std_logic_vector(3 downto 0);
		  
		  in_half:in std_logic;
		  in_one:in std_logic;
		  in_five:in std_logic;
		  in_ten:in std_logic;
		  
		  confirm:in std_logic;
		  balance:in std_logic;
		  
		  inc:in std_logic; --增加货物
		  cancel: in std_logic; --退还金额
		  
		  
		  col_o:out std_logic_vector(3 downto 0);
		  led_s:out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)
	 );
end saler;

architecture arch_saler of saler is
component Test_good_mng_dis is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  st:in std_logic_vector(2 downto 0);
		  
		  row_in:in std_logic_vector(3 downto 0);
		  col_o:out std_logic_vector(3 downto 0);
		  
		  suc:in std_logic;
		  
		  inc:in std_logic;
		  
		  price:out std_logic_vector(8 downto 0);
		  led_s70:out std_logic_vector(7 downto 0);
		  D70:out std_logic_vector(7 downto 0)
	 );
end component;

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
		  
		  cancel: in std_logic;
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  suc: out std_logic  --指示付钱成功
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

component sel_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  
		  led_s_bal: in std_logic_vector(7 downto 0);
		  D70_bal: in std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  led_s_good: in std_logic_vector(7 downto 0);
		  D70_good: in std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  led_s:out std_logic_vector(7 downto 0);
		  D70:out std_logic_vector(7 downto 0)
	 );
end component;

component NFD is
    port(
	     clock: in std_logic;
		  clk : out std_logic
	 );
end component;

signal price:std_logic_vector(8 downto 0);
signal led_s_g:std_logic_vector(7 downto 0);
signal D70_g:std_logic_vector(7 downto 0);
signal suc:std_logic;
signal led_s_b: std_logic_vector(7 downto 0);
signal D70_b:std_logic_vector(7 downto 0);
signal st: std_logic_vector(2 downto 0);
signal clkND:std_logic;

begin
    gmd: Test_good_mng_dis port map(clkND,reset,st,row_in,col_o,suc,inc,price,led_s_g,D70_g);
	 bmd: Test_bal_mng_dis port map(clkND,reset,st,in_half,in_one,in_five,in_ten,price,cancel,led_s_b,D70_b,suc);
	 sm:  state_mng port map(clkND,reset,confirm,balance,st);
	 seld:sel_dis port map(st,led_s_b,D70_b,led_s_g,D70_g,led_s,D70);
	 fd:  NFD port map(clk,clkND);
end arch_saler;