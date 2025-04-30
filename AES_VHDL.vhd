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

	--signal state_in : std_logic_vector(127 downto 0);
	--signal key : std_logic_vector(127 downto 0);
	--signal round_key : std_logic_vector(1407 downto 0);

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

	component mixcolumns
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
	
	
begin 
	
	a : subbytes port map(state_in, state_out);
	
	
end rtl;