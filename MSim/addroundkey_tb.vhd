library ieee;
use ieee.std_logic_1164.all;

entity addroundkey_tb is 
end entity addroundkey_tb;

architecture test of addroundkey_tb is 

	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);
	signal result : std_logic_vector(127 downto 0);
begin
	
	simulation : process
	begin 
		plaintext <= x"3243f6a8885a308d313198a2e0370734";
		key <= 		 x"2b7e151628aed2a6abf7158809cf4f3c";
	
		wait for 100 ns;
	
		if result = x"193de3bea0f4e22b9ac68d2ae9f84808" then
			report "AES encryption success" severity note;
		else 
			report "AES encryption failed" severity error;
		end if;
		
		wait;
	end process;
	
	dut : entity work.addroundkey
		port map(
			state_in => plaintext,
			round_key => key,
			state_out => result
		);
		
end architecture test;