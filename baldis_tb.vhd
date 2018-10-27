library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity baldis_tb is
end baldis_tb;

architecture arch_baldis_tb of baldis_tb is
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

	 signal st: std_logic_vector(2 downto 0);
    signal clk: std_logic;
	 signal reset: std_logic;   --置0为复位状态
		  
	 signal ten_in:  std_logic_vector(3 downto 0);
	 signal one_df_in:  std_logic_vector(4 downto 0);
	 signal suc:  std_logic;
		  
	 signal led_s70: std_logic_vector(7 downto 0);
	 signal D70: std_logic_vector(7 downto 0);  --abcdefg,dp

begin
   bd: balance_dis port map(st,clk,reset,ten_in,one_df_in,suc,led_s70,D70);
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
		 suc <= '1';
		 st <= "000";
		 ten_in <= "0110";
		 one_df_in <= "00011";
		 wait for 20 ns;
		 reset <= '1';
		 st <= "001";
		 wait for 200 ns;
		 ten_in <= "1100";
		 one_df_in <= "00010";
		 wait for 200 ns;
		 st <= "011";
		 wait for 200 ns;
		 suc <= '0';
		 wait for 200 ns;
		 reset <= '0';
		 wait for 1000 ns;
	end process;
end arch_baldis_tb;