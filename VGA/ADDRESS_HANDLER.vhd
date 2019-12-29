library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.Numeric_Std.all;


entity ADDRESS_HANDLER is
	generic (
		ImgHeight : integer;
		ImgWidth : integer;
		Height: integer;
		Width : integer 
	);
	port (
		CLK : in std_logic;
		h_pos : in integer;
		v_pos : in integer;
		draw_on : out std_logic;
		addr_pos : out std_logic_vector(555 downto 0)
	);
end ADDRESS_HANDLER;

architecture Behavioral of ADDRESS_HANDLER is
	
	signal flag : std_logic;
	signal temp : std_logic_vector(555 downto 0);

begin
	Main : process(CLK)
	begin
		if (rising_edge(CLK)) then
			if ((h_pos < Width) and (v_pos < Height)) then
					flag <= '1';
					temp <= std_logic_vector(to_unsigned((v_pos * width + h_pos), 556));
				else 
					flag <= '0';
			end if;
		end if;
	end process;
	
	draw_on <= flag;
	addr_pos <= temp;

end Behavioral;


