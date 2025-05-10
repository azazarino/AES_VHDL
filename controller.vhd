library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is 
	port (
		clk 	: in std_logic;
		rstn	: in std_logic;
		sw1 	: in std_logic;
		sw2 	: in std_logic;
		sw3 	: in std_logic;	
		sw4 	: in std_logic;
		segment_output : out std_logic_vector(55 downto 0)
	);
end controller;
architecture rtl of controller is 

component aes_vhdl
	port(
		clk 		: in	std_logic;
		rstn      : in 	std_logic;
      key       : in  std_logic_vector(127 downto 0);
      plaintext : in  std_logic_vector(127 downto 0);
      ciphertext: out std_logic_vector(127 downto 0);
		done_port : out std_logic
	);
end component;

signal key   : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
signal plaintext    : std_logic_vector(127 downto 0) := x"6BC1BEE22E409F96E93D7E117393172A";
signal ciphertext : std_logic_vector(127 downto 0);
signal done_port : std_logic;

signal result: std_logic_vector(127 downto 0);
signal sw_vector : std_logic_vector(3 downto 0);
signal selected_nibbles : std_logic_vector(31 downto 0);

signal byte1 : std_logic_vector(6 downto 0);
signal byte2 : std_logic_vector(6 downto 0);
signal byte3 : std_logic_vector(6 downto 0);
signal byte4 : std_logic_vector(6 downto 0);
signal byte5 : std_logic_vector(6 downto 0);
signal byte6 : std_logic_vector(6 downto 0);
signal byte7 : std_logic_vector(6 downto 0);
signal byte8 : std_logic_vector(6 downto 0);

function hex_to_7seg(hex : std_logic_vector(3 downto 0)) return std_logic_vector is
begin
    case hex is
        when "0000" => return "0111111"; -- 0
        when "0001" => return "0000110"; -- 1
        when "0010" => return "1011011"; -- 2
        when "0011" => return "1001111"; -- 3
        when "0100" => return "1100110"; -- 4
        when "0101" => return "1101101"; -- 5
        when "0110" => return "1111101"; -- 6
        when "0111" => return "0000111"; -- 7
        when "1000" => return "1111111"; -- 8
        when "1001" => return "1101111"; -- 9
        when "1010" => return "1110111"; -- A
        when "1011" => return "1111100"; -- b
        when "1100" => return "0111001"; -- C
        when "1101" => return "1011110"; -- d
        when "1110" => return "1111001"; -- E
        when "1111" => return "1110001"; -- F
        when others => return "0000000"; -- all segments off (blank)
    end case;
end function;



begin 
	
	encryption_inst : aes_vhdl
		port map (
			clk        => clk,
         rstn       => rstn,
         key        => key,
         plaintext  => plaintext,
         ciphertext => ciphertext,
			done_port => done_port
     );
	  
	sw_vector <= sw4 & sw3 & sw2 & sw1;
	with sw_vector select
    selected_nibbles <= ciphertext(127 downto 96) when "1000",  -- Bytes 15 to 12
								ciphertext(95 downto 64)  when "0100",  -- Bytes 14 to 11
								ciphertext(63 downto 32)  when "0010",  -- Bytes 13 to 10
								ciphertext(31 downto 0)   when "0001",  -- and so on
								(others => '0')            when others; -- Default
	
	byte1 <= hex_to_7seg(selected_nibbles(3 downto 0));
	byte2 <= hex_to_7seg(selected_nibbles(7 downto 4));
	byte3 <= hex_to_7seg(selected_nibbles(11 downto 8));
	byte4 <= hex_to_7seg(selected_nibbles(15 downto 12));
	byte5 <= hex_to_7seg(selected_nibbles(19 downto 16));
	byte6 <= hex_to_7seg(selected_nibbles(23 downto 20));
	byte7 <= hex_to_7seg(selected_nibbles(27 downto 24));
	byte8 <= hex_to_7seg(selected_nibbles(31 downto 28));
	
	segment_output <= byte8 & byte7 & byte6 & byte5 & byte4 & byte3 & byte2 & byte1;
	
end rtl;

