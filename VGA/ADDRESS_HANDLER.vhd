library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.Numeric_Std.all;


entity ADDRESS_HANDLER is
	generic (
		Height: integer;
		Width : integer
	);
	port (
		CLK : in std_logic;
		h_pos : in integer;
		v_pos : in integer;
		addr_pos : out std_logic_vector(15 downto 0)
	);
end ADDRESS_HANDLER;

architecture Behavioral of ADDRESS_HANDLER is

	signal temp : std_logic_vector(15 downto 0);

begin
	Main : process(CLK)
	begin
		if (rising_edge(CLK)) then
			if ((h_pos < Width) and (v_pos < Height)) then
				temp <= std_logic_vector(to_unsigned(v_pos * Height + h_pos, 16));
			end if;
		end if;
	end process;

	addr_pos <= temp;

end Behavioral;


