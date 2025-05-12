library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity aes_vhdl is 
	port (
		  clk 		: in	std_logic;
		  rstn      : in 	std_logic;
        key       : in  std_logic_vector(127 downto 0);
        plaintext : in  std_logic_vector(127 downto 0);
        ciphertext: out std_logic_vector(127 downto 0);
		  done_port : out std_logic
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
	
	
	component clocked_reg 
		port(
			clk : in std_logic;
			rstn : in std_logic; 
			input_reg : in std_logic_vector(127 downto 0);
			output_reg : out std_logic_vector(127 downto 0)
		);
	end component;
	
	type state_array is array (0 to 10) of std_logic_vector(127 downto 0);
	signal roundkeys          : std_logic_vector(1407 downto 0);
	signal roundkey_array     : state_array;
	signal state				  : state_array;
	signal input_to_reg		  : std_logic_vector(127 downto 0);
	signal output_from_reg	  : std_logic_vector(127 downto 0);
	signal feedback 			  : std_logic_vector(127 downto 0) := (others => '0');
	signal s_sub   			  : std_logic_vector(127 downto 0);
   signal s_shift 			  : std_logic_vector(127 downto 0);
   signal s_mix   			  : std_logic_vector(127 downto 0);
	signal add_key				  : std_logic_vector(127 downto 0);
	signal round_counter  	  : integer range 0 to 11 := 0;
	signal selected_round_key : std_logic_vector(127 downto 0);
	signal done 				  : std_logic;	

begin 
	
	keyexpansion_inst : keyexpansion port map(
		key_in => key, 
		round_keys => roundkeys
	);
	
	 process(clk, rstn) is
    begin
		if rstn = '0' then
			round_counter <= 0;
      elsif rising_edge(clk) then
            if round_counter < 11 then
                round_counter <= round_counter + 1;
            else
					done <= '1';
				end if;
		end if;
    end process;

	with round_counter select
	 selected_round_key <= 
	 (others => '0' )				  when 0,
    roundkeys(127 downto 0)     when 1,
    roundkeys(255 downto 128)   when 2,
    roundkeys(383 downto 256)   when 3,
    roundkeys(511 downto 384)   when 4,
    roundkeys(639 downto 512)   when 5,
    roundkeys(767 downto 640)   when 6,
    roundkeys(895 downto 768)   when 7,
    roundkeys(1023 downto 896)  when 8,
    roundkeys(1151 downto 1024) when 9,
    roundkeys(1279 downto 1152) when 10,
    roundkeys(1407 downto 1280) when others;
	
	
	
	input_to_reg <= plaintext when round_counter = 0 else feedback;
	
	clocked_reg_inst : clocked_reg port map(
		clk => clk,
		rstn => rstn, 
		input_reg => input_to_reg,
		output_reg => output_from_reg
	);	

   add : addroundkey
        port map (
            state_in  => output_from_reg,
            round_key => selected_round_key,
            state_out => add_key
        );
	
	sub : subbytes
        port map (
            state_in  => add_key,
            state_out => s_sub
        );

   shift : shiftrows
        port map (
            state_in  => s_sub,
            state_out => s_shift
        );

   mix : mixcolumns
        port map (
            state_in  => s_shift,
            state_out => s_mix
        );

	feedback <= s_shift when round_counter = 10 else s_mix;
	ciphertext <= add_key when round_counter = 11 else (others => '0');
	done_port <= '1' when round_counter = 11;
end rtl;