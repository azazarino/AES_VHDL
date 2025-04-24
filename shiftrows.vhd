library ieee;
use ieee.std_logic_1164.all;

entity shift_rows is 
	port(
		input : in std_logic_vector(127 downto 0); --16 bytes for the state
		output : out std_logic_vector(127 downto 0)
		);
end shift_rows;

architecture rtl of shift_rows is

	
begin

	output(7 downto 0) <= input(7 downto 0); -- s0,0
	output(8*5 - 1 downto 8*4) <= input(8*5 - 1 downto 8*4); -- s0,1
	output(8*9 - 1 downto 8*8) <= input(8*9 - 1 downto 8*8); -- s0,2
	output(8*13 - 1 downto 8*12) <= input(8*13 - 1 downto 8*12); -- s0,3
	
	output(8*2 - 1 downto 8) <= input(8*6 - 1 downto 8*5); -- s1,0
	output(8*6 - 1 downto 8*5) <= input(8*10 - 1 downto 8*9); -- s1,1
	output(8*10 - 1 downto 8*9) <= input(8*14 - 1 downto 8*13); -- s1,2
	output(8*14 - 1 downto 8*13) <= input(8*2 - 1 downto 8); -- s1,3
	
	output(8*3 - 1 downto 8*2) <= input(8*11 - 1 downto 8*10); -- s2,0
	output(8*7 - 1 downto 8*6) <= input(8*15 - 1 downto 8*14); -- s2,1
	output(8*11 - 1 downto 8*10) <= input(8*3 - 1 downto 8*2); -- s2,2
	output(8*15 - 1 downto 8*14) <= input(8*7 - 1 downto 8*6); -- s2,3
	
	output(8*4 - 1 downto 8*3) <= input(8*16 - 1 downto 8*15); -- s3,0
	output(8*8 - 1 downto 8*7) <= input(8*4 - 1 downto 8*3); -- s3,1
	output(8*12 - 1 downto 8*11) <= input(8*8 - 1 downto 8*7); -- s3,2
	output(8*16 - 1 downto 8*15) <= input(8*12 - 1 downto 8*11); -- s3,3

end rtl; 