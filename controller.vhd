library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controller is 
	port (
		sw1 : in std_logic;
		sw2 : in std_logic;
		sw3 : in std_logic;	
		segment_output : out std_logic_vector(55 downto 0);
	);
end controller;

component aes_vhdl
	port(
		clk 		: in	std_logic;
		rstn      : in 	std_logic;
      key       : in  std_logic_vector(127 downto 0);
      plaintext : in  std_logic_vector(127 downto 0);
      ciphertext: out std_logic_vector(127 downto 0);
		done_port : out std_logic
	)

signal key   : std_logic_vector(127 downto 0);
signal plaintext    : std_logic_vector(127 downto 0);
signal result: std_logic_vector(127 downto 0);
signal byte1 : std_logic_vector(6 downto 0);
signal byte2 : std_logic_vector(6 downto 0);
signal byte3 : std_logic_vector(6 downto 0);
signal byte4 : std_logic_vector(6 downto 0);
signal byte5 : std_logic_vector(6 downto 0);
signal byte6 : std_logic_vector(6 downto 0);
signal byte7 : std_logic_vector(6 downto 0);
signal byte8 : std_logic_vector(6 downto 0);

architecture rtl of controller is 
begin 
	
	encryption_inst : aes_vhdl port map(
		key_in => key, 
		round_keys => roundkeys
	);
	
	segment <= byte8 & byte7 & byte6 & byte5 & byte4 & byte3 & byte2 & byte1;
	
end rtl;

