library ieee;
use ieee.std_logic_1164.all;

entity keyexpansion_tb is 
end entity keyexpansion_tb;

architecture test of keyexpansion_tb is 

	signal key : std_logic_vector(127 downto 0);
	signal result : std_logic_vector(1407 downto 0);
begin
	
	simulation : process
	begin 
		key <= x"2b7e151628aed2a6abf7158809cf4f3c";
	
		wait for 100 ns;
		
		wait;
	end process;
	
	dut : entity work.keyexpansion
		port map(
			key_in => key,
			round_keys => result
		);
		
end architecture test;