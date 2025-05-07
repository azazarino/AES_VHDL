library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mixcolumns is 
	port (
		state_in : in std_logic_vector(127 downto 0); 
		state_out : out std_logic_vector(127 downto 0)
		);
end mixcolumns;

architecture rtl of mixcolumns is 

function xtimes(x : std_logic_vector(7 downto 0)) return std_logic_vector is
	begin 
	if x(7) = '1' then
		return (x(6 downto 0) & '0') xor x"1B";
	else
		return (x(6 downto 0) & '0');
	end if;

end function;

function mul_by_02(x : std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return xtimes(x);
end function;

function mul_by_03(x : std_logic_vector(7 downto 0)) return std_logic_vector is
begin
    return xtimes(x) xor x;
end function;

type state_array is array (0 to 15) of std_logic_vector(7 downto 0);
signal s_in : state_array; 
signal s_out : state_array;


begin 

	split_bytes : for i in 0 to 15 generate 
		s_in(i) <= state_in(127 - 8*i downto 120 - 8*i);
	end generate; 
	
    gen_mixcolumns: for col in 0 to 3 generate
        s_out(4*col + 0) <= mul_by_02(s_in(4*col + 0)) xor mul_by_03(s_in(4*col + 1)) xor s_in(4*col + 2) xor s_in(4*col + 3);
        s_out(4*col + 1) <= s_in(4*col + 0) xor mul_by_02(s_in(4*col + 1)) xor mul_by_03(s_in(4*col + 2)) xor s_in(4*col + 3);
        s_out(4*col + 2) <= s_in(4*col + 0) xor s_in(4*col + 1) xor mul_by_02(s_in(4*col + 2)) xor mul_by_03(s_in(4*col + 3));
        s_out(4*col + 3) <= mul_by_03(s_in(4*col + 0)) xor s_in(4*col + 1) xor s_in(4*col + 2) xor mul_by_02(s_in(4*col + 3));
    end generate;
	
	add_results : for i in 0 to 15 generate
		state_out(127 - i*8 downto 120 - i*8) <= s_out(i);
	end generate;
		
	
end rtl;