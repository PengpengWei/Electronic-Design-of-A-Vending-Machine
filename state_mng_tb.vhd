library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity state_mng_tb is
end state_mng_tb;

architecture arch_state_tb of state_mng_tb is
component state_mng is
    port(
	     clk: in std_logic;
		  reset: in std_logic;   --为1表示正常工作，0表示复位
		  confirm: in std_logic; --为1表示进入付款模式，否则在挑选模式
		  balance: in std_logic; --为1表示显示余额，否则显示货名
		  
		  st:out std_logic_vector(2 downto 0)
	 );
end component;
    signal clk:std_logic;
	 signal reset:std_logic;
	 signal confirm:std_logic;
	 signal balance:std_logic;
	 signal st: std_logic_vector(2 downto 0);
begin
    stmng: state_mng port map(clk,reset,confirm,balance,st);
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
		  confirm <= '0';
		  balance <= '0';
		  wait for 40 ns;
		  reset <= '1';
		  wait for 60 ns;
		  balance <= '1';
		  wait for 60 ns;
		  confirm <= '1';
		  wait for 60 ns;
		  balance <= '0';
		  wait for 10 ns;
		  confirm <= '0';
		  wait for 60 ns;
		  confirm <= '1';
		  wait for 60 ns;
		  reset <= '0';
		  wait for 60 ns;
		  reset <= '1';
		  wait for 1000 ns;
	 end process;
end arch_state_tb;