library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aes.all;

entity aes_vhdl is 
	port (
        --clk       : in  std_logic;
        --reset     : in  std_logic;
        key       : in  std_logic_vector(127 downto 0);
        plaintext : in  std_logic_vector(127 downto 0);
        ciphertext: out std_logic_vector(127 downto 0)
		);
end aes_vhdl;

architecture rtl of aes_vhdl is 

	component keyexpansion
		port (
			key_in : in std_logic_vector(127 downto 0);
			round_keys : out std_logic_vector(1407 downto 0)
		);
	end component;

	component addroundkey
		port (
			state_in : in std_logic_vector(127 downto 0); 
			round_key : in std_logic_vector(127 downto 0);
			state_out : out std_logic_vector(127 downto 0)
		);
		end component;
	
	component AES_round
	port (
		state_in  : in  std_logic_vector(127 downto 0);
      round_key : in  std_logic_vector(127 downto 0);
		state_out : out std_logic_vector(127 downto 0)
	);
	end component;
	
	component AES_lastround
		port (
			state_in  : in  std_logic_vector(127 downto 0);
			round_key : in  std_logic_vector(127 downto 0);
			state_out : out std_logic_vector(127 downto 0)
		);
	end component;
	
	type state_array is array (0 to 10) of std_logic_vector(127 downto 0);
	signal roundkeys          : std_logic_vector(1407 downto 0);
	signal roundkey_array     : state_array;
	signal state				  : state_array;
	
	signal state_reg, state_next : std_logic_vector(127 downto 0);
   --signal round : integer range 0 to 10 := 0;
	
	
begin 
	
	keyexpansion_inst : keyexpansion port map(
		key_in => key, 
		round_keys => roundkeys
	);
	
	roundkey_array(10) <= roundkeys(1407 downto 1280);
	roundkey_array(9) <= roundkeys(1279 downto 1152);
	roundkey_array(8) <= roundkeys(1151 downto 1024);
	roundkey_array(7) <= roundkeys(1023 downto 896);
	roundkey_array(6) <= roundkeys(895 downto 768);
	roundkey_array(5) <= roundkeys(767 downto 640);
	roundkey_array(4) <= roundkeys(639 downto 512);
	roundkey_array(3) <= roundkeys(511 downto 384);
	roundkey_array(2) <= roundkeys(383 downto 256);
	roundkey_array(1) <= roundkeys(255 downto 128);
	roundkey_array(0) <= roundkeys(127 downto 0);

	
	add_first_round : addroundkey port map(
		state_in => plaintext, 
		round_key => roundkey_array(0), 
		state_out => state(0)
	);
	
	create_rounds : for i in 1 to 9 generate
	
	roundX : AES_round port map(
			state_in  => state(i -1),
			round_key => roundkey_array(i),
			state_out => state(i)
		);
	end generate;
	
	round_last : AES_lastround
		port map(
			state_in  => state(9),
			round_key => roundkey_array(10),
			state_out => state(10)
		);
	
	ciphertext <= state_reg;
	
end rtl;