library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BrickBreakerTB is
end entity BrickBreakerTB;

architecture behavioral of BrickBreakerTB is
	component BrickBreaker
		generic (
			N : integer := 10
		);
		

		port(
	MAX10_CLK1_50 : std_logic;
	MAX10_CLK2_50 : std_logic;
	SW: in std_logic_vector(9 downto 0);

	GPIO : out std_logic_vector(35 downto 0)
		);
	end component BrickBreaker;

	signal clk: std_logic := '0';
	signal GPIO: std_logic_vector(35 downto 0) := "000000000000000000000000000000000000";
	signal SW: std_logic_vector(9 downto 0) := "0000000000";
	constant CLK_PERIOD : time := 10 ps;

begin

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD / 2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	stm_process : process
	begin
		SW <= "0000000001";
		wait for CLK_PERIOD * 100;
		SW <= "0000000010";
		wait for CLK_PERIOD * 100;
		SW <= "0000000100";
		wait for CLK_PERIOD * 100;
		SW <= "0000001000";
		wait for CLK_PERIOD * 100;

		wait;
	end process;
	
	uut : BrickBreaker
		generic map(
			N => 10
		)
		port map(
			MAX10_CLK1_50 => clk,
			MAX10_CLK2_50 => '0',
			GPIO => GPIO,
			SW => SW
		);
	
	
end architecture behavioral;

