library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aes.all;

entity sub_bytes is 
	port (
		state_in : in std_logic_vector(127 downto 0); 
		state_out : out std_logic_vector(127 downto 0)
		);
end sub_bytes;

architecture rtl of sub_bytes is 

signal substitution : std_logic_vector(127 downto 0);

begin 
	subbyte : for i in 0 to 15 generate
		substitution((8*(i+1))-1 downto 8*i) <= normal_sbox(to_integer(unsigned(state_in((8*(i+1))-1 downto (8*i)+4))), to_integer(unsigned(state_in((8*(i+1))-5 downto 8*i))));
	end generate subbyte;

	state_out <= substitution;
	
	
end rtl;