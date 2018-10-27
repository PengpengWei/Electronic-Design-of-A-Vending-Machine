library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Test_bal_mng_dis is
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
		  
		  
		  --输出
		  --A20: out std_logic_vector(2 downto 0);
		  --D70: out std_logic_vector(7 downto 0); --abcdefg dp
		  --ten_out: out std_logic_vector(3 downto 0);
		  --one_df_out: out std_logic_vector(4 downto 0);
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0);  --abcdefg,dp
		  
		  suc: out std_logic  --指示付钱成功
	 );
end Test_bal_mng_dis;

architecture arch_mng_dis of Test_bal_mng_dis is
component balance_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;
		  st: in std_logic_vector(2 downto 0);
        in_half: in std_logic;
		  in_one: in std_logic;
		  in_five: in std_logic;
		  in_ten: in std_logic;
		  price: in std_logic_vector(8 downto 0);
		  
		  cancel:in std_logic;
		  
		  --输出
		  ten_out: out std_logic_vector(3 downto 0);
		  one_df_out: out std_logic_vector(4 downto 0);
		  
		  suc: out std_logic  --指示付钱成功
	 );
end component;

component balance_dis is
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
end component;

signal ten_out: std_logic_vector(3 downto 0);
signal one_df_out: std_logic_vector(4 downto 0);
signal suc_o: std_logic;

begin
    mng: balance_mng port map(clk,reset,st,in_half,in_one,in_five,in_ten,price,cancel,ten_out,one_df_out,suc_o);
	 dis: balance_dis port map(st,clk,reset,ten_out,one_df_out,suc_o,led_s70,D70);
	 suc <= suc_o;
end arch_mng_dis;