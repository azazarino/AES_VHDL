library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.aes.all;

entity keyexpansion is 
    Port(
      key_in     : in  std_logic_vector(127 downto 0);
		round_keys : out std_logic_vector(1407 downto 0) -- 11 * 128 bits
    );
end keyexpansion;

architecture rtl of keyexpansion is 

	type word_array is array (0 to 43) of std_logic_vector(31 downto 0);
	signal w : word_array;

	function sbox(input : std_logic_vector(7 downto 0)) return std_logic_vector is
    variable row : integer;
    variable col : integer;
	begin
		row := to_integer(unsigned(input(7 downto 4)));
		col := to_integer(unsigned(input(3 downto 0)));
    return normal_sbox(row, col);
	end function;
	
	
   function rotword(w : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
       return w(23 downto 16) & w(15 downto 8) & w(7 downto 0) & w(31 downto 24);
   end function;

	function subword(w : std_logic_vector(31 downto 0)) return std_logic_vector is 
		--signal temp : std_logic_vector(31 downto 0);
	begin 
		return sbox(w(31 downto 24)) & sbox(w(23 downto 16)) & sbox(w(15 downto 8)) & sbox(w(7 downto 0));
	end function;

    type rcon_array is array (1 to 10) of std_logic_vector(31 downto 0);
    constant rcon : rcon_array := (
        x"01000000", x"02000000", x"04000000", x"08000000",
        x"10000000", x"20000000", x"40000000", x"80000000",
        x"1b000000", x"36000000"
    );

begin 

    W(0) <= key_in(127 downto 96);
    W(1) <= key_in(95 downto 64);
    W(2) <= key_in(63 downto 32);
    W(3) <= key_in(31 downto 0);
	 
	 keyexpansion : for i in 4 to 43 generate
		w(i) <= w(i-4) xor (subword(rotword(w(i-1)))) xor rcon(i/4) when (i mod 4 = 0) else
		w(i-4) xor w(i-1);
	 end generate;
	 
    round_keys <=
    W(43) & W(42) & W(41) & W(40) &
    W(39) & W(38) & W(37) & W(36) &
    W(35) & W(34) & W(33) & W(32) &
    W(31) & W(30) & W(29) & W(28) &
    W(27) & W(26) & W(25) & W(24) &
    W(23) & W(22) & W(21) & W(20) &
    W(19) & W(18) & W(17) & W(16) &
    W(15) & W(14) & W(13) & W(12) &
    W(11) & W(10) & W(9) & W(8) &
    W(7) & W(6) & W(5) & W(4) &
    W(3) & W(2) & W(1) & W(0);
	
end rtl;