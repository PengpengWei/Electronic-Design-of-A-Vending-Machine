library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity good_mng_tb is
end good_mng_tb;

architecture arch_good of good_mng_tb is
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

signal clk:std_logic;
signal reset: std_logic;
signal st: std_logic_vector(2 downto 0);
signal PageUp:std_logic;
signal PageDown: std_logic;
signal goodno:std_logic_vector(2 downto 0);

begin
    gm: good_mng port map(clk,reset,st,PageUp,PageDown,goodno);
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
		  PageUp <= '0';
		  PageDown <= '0';
		  wait for 40 ns;
		  reset <= '1';
		  st <= "001";
		  wait for 20 ns;
		  PageUp <= '1';
		  wait for 60 ns;
		  st <= "010";
		  PageUp <= '0';
		  wait for 60 ns;
		  PageDown <= '1';
		  wait for 60 ns;
		  PageDown <= '0';
		  wait for 60 ns;
		  PageDown <= '1';
		  wait for 60 ns;
		  PageDown <= '0';
		  wait for 60 ns;
		  PageDown <= '1';
		  wait for 60 ns;
		  PageDown <= '0';
		  
		  st <= "000";
		  wait for 60 ns;
		  st <= "001";
		  wait for 20 ns;
		  PageDown <= '1';
		  wait for 60 ns;
		  PageDown <= '0';
		  wait for 60 ns;
		  PageUp <= '1';
		  wait for 60 ns;
		  PageUp <= '0';
		  wait for 1000 ns;
	 end process;
end arch_good;