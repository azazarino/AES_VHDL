library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clocked_reg is 
	port (
			clk : in std_logic;
			rstn : in std_logic; 
			input_reg : in std_logic_vector(127 downto 0);
			output_reg : out std_logic_vector(127 downto 0)
		);
end clocked_reg;

architecture rtl of clocked_reg is 
	signal state_next, state_now : std_logic_vector(127 downto 0);
	signal counter : integer range 0 to 11 := 0;
	begin 
	state_now <= input_reg;
	process(clk, rstn, counter) is 
		begin
		--if rstn = '0' then 
			--state_next <= (others  => '0');
		if rising_edge(clk) and rstn ='1' and counter < 11 then
					state_next <= state_now;
					counter <= counter + 1;
		end if;			
	end process;
	output_reg <= state_next; 
end rtl;