library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aes.all;

entity aes_vhdl is 
	port (
		state_in : in std_logic_vector(127 downto 0); 
		state_out : out std_logic_vector(127 downto 0)
		);
end aes_vhdl;

architecture rtl of aes_vhdl is 
begin 
	state_out <= state_in;
	
	
end rtl;