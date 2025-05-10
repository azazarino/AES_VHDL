library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity decryption_tb is
end decryption_tb;

architecture tb of decryption_tb is
    -- Component under test
    component decryption_aes
        port (
            clk           	: in  std_logic;
            rstn       	  	: in  std_logic;
            key        	  	: in  std_logic_vector(127 downto 0);
				ciphertext    	: in std_logic_vector(127 downto 0);
            plaintext     	: out  std_logic_vector(127 downto 0);
				done_port 		: out std_logic
        );
    end component;

    -- Testbench signals
    signal clk        : std_logic := '0';
    signal rstn       : std_logic := '0';
    signal key        : std_logic_vector(127 downto 0);
    signal plaintext  : std_logic_vector(127 downto 0);
    signal ciphertext : std_logic_vector(127 downto 0);
	 signal test_out : std_logic_vector(127 downto 0);
	 signal test_output2 : std_logic_vector(127 downto 0);
	 signal done_port : std_logic;
	 constant CLK_PERIOD : time := 20 ns;

begin

    dut: decryption_aes
        port map (
            clk        => clk,
            rstn       => rstn,
            key        => key,
				ciphertext => ciphertext,
            plaintext  => plaintext,
				done_port => done_port
        );

    -- Clock process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the system
        rstn <= '0';
        key <= x"2b7e151628aed2a6abf7158809cf4f3c";  -- Example AES key
        ciphertext <= x"3AD77BB40D7A3660A89ECAF32466EF97"; -- Example plaintext
        wait for 2 * CLK_PERIOD;

        -- De-assert reset
        rstn <= '1';
		  wait for 260 ns;
        if plaintext = x"6BC1BEE22E409F96E93D7E117393172A" then
			report "AES encryption success" severity note;
			else 
			report "AES encryption failed" severity error;
			end if;
		  
		  wait;
    end process;

end tb;
