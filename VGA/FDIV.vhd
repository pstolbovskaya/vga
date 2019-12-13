library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity FDIV is
	
	generic 
	( 
		n: integer := 2
	);
	port (
		CLK : in std_logic;
		RST : in std_logic;
		CE : in std_logic;
--		K : in std_logic_vector(n - 1 downto 0) := "100";
		Q : out std_logic
	);
end FDIV;

architecture Behavioral of FDIV is
	signal counter : std_logic_vector(2**n-1 downto 0);
	signal div: std_logic := '0';
begin
	Main: process (RST, CLK, CE)
	begin
		if (RST = '1') then
			counter <= (others => '0');
		elsif (CE = '1') then
			if (rising_edge(CLK)) then	
				if (conv_integer(counter) = n-1) then
					div <= not div;
					counter <= (others => '0');
				else
					counter <= counter + 1;
				end if;
			end if;
		end if;
	end process;

	Q <= div;

end Behavioral;

