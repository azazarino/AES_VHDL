library ieee;
use ieee.std_logic_1164.all;

entity invshiftrows is 
	port(
		state_in : in std_logic_vector(127 downto 0); --16 bytes for the state
		state_out : out std_logic_vector(127 downto 0)
		);
end invshiftrows;

architecture rtl of invshiftrows is
	
begin

	state_out(8*16 -1 downto 8*15) <= state_in(8*16 -1 downto 8*15); -- s0,0
	state_out(8*12 - 1 downto 8*11) <= state_in(8*12 - 1 downto 8*11); -- s0,1
	state_out(8*8 - 1 downto 8*7) <= state_in(8*8 - 1 downto 8*7); -- s0,2
	state_out(8*4 - 1 downto 8*3) <= state_in(8*4 - 1 downto 8*3); -- s0,3
	
	state_out(8*15 - 1 downto 8*14) <= state_in(8*3 - 1 downto 8*2); -- s1,0
	state_out(8*11 - 1 downto 8*10) <= state_in(8*15 - 1 downto 8*14); -- s1,1
	state_out(8*7 - 1 downto 8*6) <= state_in(8*11 - 1 downto 8*10); -- s1,2
	state_out(8*3 - 1 downto 8*2) <= state_in(8*7 - 1 downto 8*6); -- s1,3
	
	state_out(8*14 - 1 downto 8*13) <= state_in(8*6 - 1 downto 8*5); -- s2,0
	state_out(8*10 - 1 downto 8*9) <= state_in(8*2 - 1 downto 8*1); -- s2,1
	state_out(8*6 - 1 downto 8*5) <= state_in(8*14 - 1 downto 8*13); -- s2,2
	state_out(8*2 - 1 downto 8*1) <= state_in(8*10 - 1 downto 8*9); -- s2,3
	
	state_out(8*13 - 1 downto 8*12) <= state_in(8*9 - 1 downto 8*8); -- s3,0
	state_out(8*9 - 1 downto 8*8) <= state_in(8*5 - 1 downto 8*4); -- s3,1
	state_out(8*5 - 1 downto 8*4) <= state_in(8*1 - 1 downto 0); -- s3,2
	state_out(8*1 - 1 downto 0) <= state_in(8*13 - 1 downto 8*12); -- s3,3


end rtl; 