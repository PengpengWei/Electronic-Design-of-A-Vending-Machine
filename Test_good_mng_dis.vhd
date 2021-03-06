library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Test_good_mng_dis is
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
end Test_good_mng_dis;

architecture tb_test_good of Test_good_mng_dis is

component page_btn is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  row_in:in std_logic_vector(3 downto 0);
		  
		  col_o:out std_logic_vector(3 downto 0);
		  
		  PageUp:out std_logic;
		  PageDown:out std_logic
	 );
end component;

component good_mng is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  st:in std_logic_vector(2 downto 0);
		  PageUp:in std_logic;
		  PageDown:in std_logic;
		  
		  goodno: out std_logic_vector(2 downto 0)
	 );
end component;

component good_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  clk:in std_logic;
		  reset:in std_logic;   --置0为复位状态
		  
		  goodno:in std_logic_vector(2 downto 0);
		  
		  suc:in std_logic; --付款成功状态
		  
		  inc:in std_logic;
		  
		  price: out std_logic_vector(8 downto 0);
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
	 );
end component;

signal gdno:std_logic_vector(2 downto 0);
signal PageUp,PageDown:std_logic;

begin
   pb: page_btn port map(clk,reset,row_in,col_o,PageUp,PageDown);
   gd: good_dis port map(st,clk,reset,gdno,suc,inc,price,led_s70,D70);
	gm: good_mng port map(clk,reset,st,PageUp,PageDown,gdno);
end tb_test_good;