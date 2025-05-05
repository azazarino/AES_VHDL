library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aes.all;

entity invmixcolumns is 
	port (
		state_in : in std_logic_vector(127 downto 0); 
		state_out : out std_logic_vector(127 downto 0)
		);
end invmixcolumns;

architecture rtl of invmixcolumns is 

function xtimes(x : std_logic_vector(7 downto 0)) return std_logic_vector is
	begin 
	if x(7) = '1' then
		return (x(6 downto 0) & '0') xor x"1B";
	else
		return (x(6 downto 0) & '0');
	end if;

end function;

function mul_by_09(b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable t : std_logic_vector(7 downto 0);
begin
    t := xtimes(xtimes(xtimes(b)));  -- 8
    return t xor b; --8 + 1 = 9b                       
end function;

function mul_by_0B(b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable t1, t2 : std_logic_vector(7 downto 0);
begin
    t1 := xtimes(b);               -- b * 2
    t2 := xtimes(xtimes(t1));      -- b * 8
    return  t2 xor t1 xor b;       -- 8b + 2b + b = 11b
end function;

function mul_by_0E(b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable t1, t2, t3 : std_logic_vector(7 downto 0);
begin
    t1 := xtimes(b);               -- b * 2
    t2 := xtimes(t1);              -- b * 4
    t3 := xtimes(t2);              -- b * 8
    return t3 xor t2 xor t1;  -- 8b + 4b + 2b = 14b
end function;

function mul_by_0D(b : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable t1, t2 : std_logic_vector(7 downto 0);
begin
    t1 := xtimes(b);               -- b * 2
    t2 := xtimes(t1);              -- b * 4
    t1 := xtimes(t2);              -- b * 8
    return t1 xor t2 xor b;       -- 8b + 4b + b = 13b
end function;



type state_array is array (0 to 15) of std_logic_vector(7 downto 0);
signal s_in : state_array; 
signal s_out : state_array;


begin 

	split_bytes : for i in 0 to 15 generate 
		s_in(i) <= state_in(127 - 8*i downto 120 - 8*i);
	end generate; 
	
    gen_mixcolumns: for col in 0 to 3 generate
        s_out(4*col + 0) <= mul_by_0E(s_in(4*col + 0)) xor mul_by_0B(s_in(4*col + 1)) xor mul_by_0D(s_in(4*col + 2)) xor mul_by_09(s_in(4*col + 3));
        s_out(4*col + 1) <= mul_by_09(s_in(4*col + 0)) xor mul_by_0E(s_in(4*col + 1)) xor mul_by_0B(s_in(4*col + 2)) xor mul_by_0D(s_in(4*col + 3));
        s_out(4*col + 2) <= mul_by_0D(s_in(4*col + 0)) xor mul_by_09(s_in(4*col + 1)) xor mul_by_0E(s_in(4*col + 2)) xor mul_by_0B(s_in(4*col + 3));
        s_out(4*col + 3) <= mul_by_0B(s_in(4*col + 0)) xor mul_by_0D(s_in(4*col + 1)) xor mul_by_09(s_in(4*col + 2)) xor mul_by_0E(s_in(4*col + 3));
    end generate;
	
	add_results : for i in 0 to 15 generate
		state_out(127 - i*8 downto 120 - i*8) <= s_out(i);
	end generate;
		
	
end rtl;