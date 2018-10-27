library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity good_dis_tb is
end good_dis_tb;

architecture arch_gd_tb of good_dis_tb is
component good_dis is
    port(
	     st:in std_logic_vector(2 downto 0);
		  clk:in std_logic;
		  reset:in std_logic;   --置0为复位状态
		  
		  goodno:in std_logic_vector(2 downto 0);
		  
		  suc:in std_logic; --付款成功状态
		  
		  price: out std_logic_vector(8 downto 0);
		  
		  led_s70: out std_logic_vector(7 downto 0);
		  D70: out std_logic_vector(7 downto 0)  --abcdefg,dp
	 );
end component;
signal st:std_logic_vector(2 downto 0);
signal clk:std_logic;
signal reset:std_logic;
signal goodno: std_logic_vector(2 downto 0);
signal suc:std_logic;
signal price:std_logic_vector(8 downto 0);
signal led_s70:std_logic_vector(7 downto 0);
signal D70:std_logic_vector(7 downto 0);

begin
    gd: good_dis port map(st,clk,reset,goodno,suc,price,led_s70,D70);
	 
	 process
	 begin
	     clk <= '1';
		  wait for 5 ns;
		  clk <= '0';
		  wait for 5 ns;
	 end process;
	 
	 process
	 begin
	     reset <= '0';
		  st <= "000";
		  goodno <= "000";
		  suc <= '0';
		  wait for 40 ns;
		  reset <= '1';
		  st <= "001";
		  wait for 100 ns;
		  goodno <= "001";
		  wait for 200 ns;
		  st <= "011";
		  suc <= '1';
		  wait for 200 ns;
		  st <= "010";
		  suc <= '0';
		  wait for 40 ns;
		  goodno <= "101";
		  wait for 200 ns;
		  wait for 2000 ns;
	 end process;

end arch_gd_tb;