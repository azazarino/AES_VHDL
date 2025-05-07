library ieee;
use ieee.std_logic_1164.all;

entity shiftrows_tb is 
end entity shiftrows_tb;

architecture test of shiftrows_tb is 

	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);
	signal result : std_logic_vector(127 downto 0);
begin
	
	simulation : process
	begin 
		plaintext <= x"d42711aee0bf98f1b8b45de51e415230";
		key <= 		 x"2b7e151628aed2a6abf7158809cf4f3c";
	
		wait for 100 ns;
	
		if result = x"d4bf5d30e0b452aeb84111f11e2798e5" then
			report "AES encryption success" severity note;
		else 
			report "AES encryption failed" severity error;
		end if;
		
		wait;
	end process;
	
	dut : entity work.shiftrows
		port map(
			state_in => plaintext,
			state_out => result
		);
		
end architecture test;