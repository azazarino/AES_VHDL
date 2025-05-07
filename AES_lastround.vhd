library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AES_lastround is
    Port (
        state_in  : in  std_logic_vector(127 downto 0);
        round_key : in  std_logic_vector(127 downto 0);
        state_out : out std_logic_vector(127 downto 0)
    );
end AES_lastround;

architecture Behavioral of AES_lastround is
	component subbytes
		 port (
			  state_in  : in  std_logic_vector(127 downto 0);
			  state_out : out std_logic_vector(127 downto 0)
		 );
	end component;

	component shiftrows
		 port (
			  state_in  : in  std_logic_vector(127 downto 0);
			  state_out : out std_logic_vector(127 downto 0)
		 );
	end component;

	component addroundkey
		 port (
			  state_in  : in  std_logic_vector(127 downto 0);
			  round_key : in  std_logic_vector(127 downto 0);
			  state_out : out std_logic_vector(127 downto 0)
		 );
	end component;
	 
	signal s_sub   : std_logic_vector(127 downto 0);
   signal s_shift : std_logic_vector(127 downto 0);
	 
begin

    sub : subbytes
        port map (
            state_in  => state_in,
            state_out => s_sub
        );

    shift : shiftrows
        port map (
            state_in  => s_sub,
            state_out => s_shift
        );

    add : addroundkey
        port map (
            state_in  => s_shift,
            round_key => round_key,
            state_out => state_out
        );
		  

end Behavioral;