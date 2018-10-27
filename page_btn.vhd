library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity page_btn is
    port(
	     clk:in std_logic;
		  reset:in std_logic;
		  row_in:in std_logic_vector(3 downto 0);
		  
		  col_o:out std_logic_vector(3 downto 0);
		  
		  PageUp:out std_logic;
		  PageDown:out std_logic
	 );
end page_btn;

architecture arch_page_btn of page_btn is
type State is(noact,scup,susup,ensup,scdn,susdn,ensdn);
signal st: State;
signal updown:std_logic_vector(1 downto 0);
begin
    update_st:process(clk)
	 begin
	     if(clk'event and clk='1') then
		      case st is
				    when noact =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      st <= scup;
								col_o <= "1110";
								updown <= "00";
						  end if;
					 when scup =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      st <= susup;
								col_o <= "1110";
								updown <= "00";
						  end if;
					 when susup =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      if(row_in(3)='0') then
								    st <= ensup;
									 col_o <= "1110";
									 updown <= "00";
								else
								    st <= scdn;
									 col_o <= "1011";
									 updown <= "00";
								end if;
						  end if;
					 when ensup =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      if(row_in(3)='0') then
								    st <= ensup;
									 col_o <= "1110";
									 updown <= "10";
								else
								    st <= noact;
									 col_o <= "1111";
									 updown <= "00";
								end if;
						  end if;
						  
					 when scdn =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      st <= susdn;
								col_o <= "1011";
								updown <= "00";
						  end if;
					 when susdn =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      if(row_in(3)='0') then
								    st <= ensdn;
									 col_o <= "1011";
									 updown <= "00";
								else
								    st <= scup;
									 col_o <= "1110";
									 updown <= "00";
								end if;
						  end if;
					 when ensdn =>
					     if(reset='0') then
						      st <= noact;
								col_o <= "1111";
								updown <= "00";
						  else
						      if(row_in(3)='0') then
								    st <= ensdn;
									 col_o <= "1011";
									 updown <= "01";
								else
								    st <= noact;
									 col_o <= "1111";
									 updown <= "00";
								end if;
						  end if;
					 when others =>
					     st <= noact;
						  col_o <= "1111";
						  updown <= "00";
				end case;
		  end if;
	 end process update_st;
	 
	 PageUp   <= '1' when updown(1)='1' else
	             '0';
	 PageDown <= '1' when updown(0)='1' else
	             '0';		  
end arch_page_btn;