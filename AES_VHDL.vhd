library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.aes.all;

entity aes_vhdl is 
	port (
			state_in : in std_logic_vector(127 downto 0);
			key_in_port : in std_logic_vector(127 downto 0);
			state_out : out std_logic_vector(127 downto 0)	
		);
end aes_vhdl;

architecture rtl of aes_vhdl is 

	component keyexpansion
		port (
			key_in : in std_logic_vector(127 downto 0);
			round_keys : out std_logic_vector(1407 downto 0)
		);
	end component;
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
	
	
	type state_array is array (0 to 10) of std_logic_vector(127 downto 0);
	signal state_intermediate : state_array;
	signal roundkeys          : std_logic_vector(1407 downto 0);
	signal roundkey_array     : state_array;
	signal sb           	 	  : state_array;
   signal sr                 : state_array;
   signal mc                 : state_array;
	
begin 
	
	keyexpansion_inst : keyexpansion port map(
		key_in => key_in_port, 
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
		state_in => state_in, 
		round_key => roundkey_array(0), 
		state_out => state_intermediate(0)
	);
	
	
	create_rounds : for i in 1 to 8 generate
	
	SBX: subbytes
      port map (
         state_in  => state_intermediate(i-1),
         state_out => sb(i)
      );

   SRX: shiftrows
      port map (
			state_in  => sb(i),
         state_out => sr(i)
      );

   MCX: mixcolumns
      port map (
         state_in  => sr(i),
         state_out => mc(i)
      );

	ARKX: addroundkey
		port map (
			state_in  => mc(i),
         round_key => roundkey_array(i),
         state_out => state_intermediate(i)
      ); 
	end generate;
	
	--last round
	SBX: subbytes
      port map (
         state_in  => state_intermediate(8),
         state_out => sb(9)
      );

   SRX: shiftrows
      port map (
			state_in  => sb(9),
         state_out => sr(9)
      );

   MCX: mixcolumns
      port map (
         state_in  => sr(9),
         state_out => mc(9)
      );

	ARKX: addroundkey
		port map (
			state_in  => mc(9),
         round_key => roundkey_array(9),
         state_out => state_intermediate(9)
      ); 
		
		
	SB10: subbytes
		port map (
			state_in  => state_intermediate(9),
         state_out => sb(10)
			);

   SR10: shiftrows
      port map (
         state_in  => sb(10),
         state_out => sr(10)
      );

   ARK10: addroundkey
       port map (
          state_in  => sr(10),
          round_key => roundkey_array(10),
          state_out => state_intermediate(10)
       );
		
	
	state_out <= state_intermediate(10);
	
end rtl;