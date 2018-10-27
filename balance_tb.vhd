library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity balance_tb is
end balance_tb;

architecture arch_tb of balance_tb is
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
		  
		  
		  --输出
		  --A20: out std_logic_vector(2 downto 0);
		  --D70: out std_logic_vector(7 downto 0); --abcdefg dp
		  ten_out: out std_logic_vector(3 downto 0);
		  one_df_out: out std_logic_vector(4 downto 0);
		  
		  suc: out std_logic  --指示付钱成功
	 );
end component;

    signal clkin:std_logic;
	 signal reset:std_logic;
	 signal st: std_logic_vector(2 downto 0);
    signal in_half: std_logic;
	 signal in_one: std_logic;
	 signal in_five: std_logic;
    signal in_ten: std_logic;
	 signal price: std_logic_vector(8 downto 0);
	 signal ten_out: std_logic_vector(3 downto 0);
	signal one_df_out: std_logic_vector(4 downto 0);
	signal suc:std_logic;
begin
    ent: balance_mng port map(clkin,reset,st,in_half,in_one,in_five,in_ten,price,ten_out,one_df_out,suc);
	 price <= "000000000";
	 process
	 begin
	     clkin <= '1';
		  wait for 5 ns;
		  clkin <= '0';
		  wait for 5 ns;
	 end process;
	 
	 process
	 begin
	     reset <= '0';
		  st <= "000";
		  in_half <= '1';
		  in_one <= '1';
		  in_five <= '1';
		  in_ten <= '1';
		  wait for 20 ns;
		  reset <= '1';
		  wait for 5 ns;
		  st <= "001";
		  wait for 40 ns;
		  in_half <= '0';
		  wait for 45 ns;
		  in_half <= '1';
		  wait for 20 ns;
		  in_one <= '0';
		  wait for 45 ns;
		  in_one <= '1';
		  wait for 20 ns;
		  in_half <= '0';
		  wait for 45 ns;
		  in_half <= '1';
		  wait for 20 ns;
		  in_five <= '0';
		  wait for 45 ns;
		  in_five <= '1';
		  wait for 1000 ns;
	 end process;
end arch_tb;