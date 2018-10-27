library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity NFD is
    port(
	     clock: in std_logic;
		  clk : out std_logic
	 );
end NFD;

architecture arch_NFD of NFD is
    signal count : std_logic_vector(20 downto 0) := "000000000000000000000";
begin
    process(clock)
	 begin
	     if(clock'event and clock = '1') then
		      count <= count + 1;
		  end if;
	 end process;
	 --clk <= clock;
	 clk <= count(12);    --2^13分频
end arch_NFD;