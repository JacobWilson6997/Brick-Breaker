library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Brickbreaker is
	generic (
		N : integer := 10
	);
	

	port(
	MAX10_CLK1_50 : std_logic;
	MAX10_CLK2_50 : std_logic;
	SW: in std_logic_vector(9 downto 0);

	GPIO : out std_logic_vector(35 downto 0)
	
	);
end entity BrickBreaker;


architecture behavioral of BrickBreaker is


	signal ticks: integer := 0;
	signal onoff: std_logic := '0';
	type state is (waiting, reset, SW0, SW1, SW2, SW3);
	signal currentState, nextState: state;
	signal currentSound: integer:= 0;
	signal nextSound: integer := 0;
	signal currentTicks: integer := 0;
	signal nextTicks: integer := 0;
	signal currentOnOff: std_logic := '0';
	signal nextOnOff: std_logic := '0';
	signal clock: std_logic := '0';

component PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END component PLL;
	
begin
	clockSet: PLL
	PORT map
	(
		areset => '0',
		inclk0 => MAX10_CLK1_50,
		c0 => clock,
		locked => open 
	);

	process (clock)
	begin
			
		if rising_edge(clock) then		
			currentState <= nextState;
			currentSound <= nextSound;
			currentTicks <= nextTicks;
			currentOnOff <= nextOnOff;
		end if;
	end process;
	
	process(currentState, SW, currentSound, currentOnOff, currentTicks)
	begin
		case currentState is
			when waiting =>
				if currentTicks > currentSound then
					nextTicks <= 0;
					if SW(0) = '0' and SW(1) = '0' and SW(2) = '0' and SW(3) = '0'then
						nextOnOff <= '0';
					else
						nextOnOff <= not currentOnOff;
					end if;
					nextState <= currentState;
					nextSound <= currentSound;
				else
					nextTicks <= currentTicks + 1;
					nextOnOff <= currentOnOff;
					nextSound <= currentSound;
					if SW(0) = '1' then
						nextState <= SW0; 
					elsif SW(1) = '1'  then
						nextState <= SW1;
					elsif SW(2) = '1' then
						nextState <= SW2; 
					elsif SW(3) = '1' then
						nextState <= SW3; 
					elsif SW(0) = '0' and SW(1) = '0' and SW(2) = '0' and SW(3) = '0'then
						nextState <= reset;
					else
						nextState <= waiting;
					end if;
				end if;
			when SW0 =>
				nextSound <= 500000;
				nextState <= waiting;
				nextTicks <= currentTicks;
				nextOnOff <= currentOnOff;
			when SW1 =>
				nextSound <= 100000;
				nextState <= waiting;			
				nextTicks <= currentTicks;
				nextOnOff <= currentOnOff;
			when SW2 =>
				nextSound <= 200000;
				nextState <= waiting;
				nextTicks <= currentTicks;
				nextOnOff <= currentOnOff;
			when SW3 =>
				nextSound <= 300000;
				nextState <= waiting;
				nextTicks <= currentTicks;
				nextOnOff <= currentOnOff;
			when reset =>
				nextSound <= 50000000;
				nextState <= waiting;
				nextTicks <= currentTicks;
				nextOnOff <= currentOnOff;
			end case;
		end process;	
	GPIO(0) <= currentOnOff;
	
end architecture behavioral;
--500000- game over 
--100000- bounce off 