library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is 
	port (
		clk 	: in std_logic;
		rstn	: in std_logic;
		--sw1 	: in std_logic;
		--sw2 	: in std_logic;
		--sw3 	: in std_logic;	
		--sw4 	: in std_logic;
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

component decryption_aes
	port(
		clk 		: in	std_logic;
		rstn      : in 	std_logic;
      key       : in  std_logic_vector(127 downto 0);
      ciphertext: in std_logic_vector(127 downto 0);
		plaintext : out  std_logic_vector(127 downto 0);
		done_port : out std_logic
	);
end component;

signal key   : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
signal plaintext    : std_logic_vector(127 downto 0) := x"6BC1BEE22E409F96E93D7E117393172A";
signal ciphertext : std_logic_vector(127 downto 0); --:=   x"123456789abcdef11111111111111111"; --12345678 9abcdef1 11111111 11111111
signal done_port : std_logic;

signal cipher_decrypt : std_logic_vector(127 downto 0) := x"3AD77BB40D7A3660A89ECAF32466EF97";
signal plaintext_decrypt : std_logic_vector(127 downto 0);
signal done_decrypt : std_logic;

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
	 
	decryption_inst : decryption_aes
	port map (
		clk        => clk,
		rstn       => rstn,
      key        => key,
		ciphertext => cipher_decrypt,
      plaintext  => plaintext_decrypt,
		done_port => done_port
	);
	
	segment_output <= ciphertext(22 downto 0) & plaintext_decrypt(32 downto 0);
	
	
end rtl;

