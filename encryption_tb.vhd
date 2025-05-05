library ieee;
use ieee.std_logic_1164.all;

entity encryption_tb is 
end entity encryption_tb;

architecture test of encryption_tb is 

	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);
	signal result : std_logic_vector(127 downto 0);
begin
	
	simulation : process
	begin 
		plaintext <= x"6BC1BEE22E409F96E93D7E117393172A";
		key <= x"2B7E151628AED2A6ABF7158809CF4F3C";
	
		wait for 100 us;
	
		if result = x"3AD77BB40D7A3660A89ECAF32466EF97" then
			report "AES encryption success" severity note;
		else 
			report "AES encryption failed" severity error;
		end if;
		
		wait;
	end process;
	
	dut : entity work.aes_vhdl
		port map(
			state_in => plaintext,
			key_in_port => key,
			state_out => result
		);
	
	--assert state_out = 
		
end architecture test;