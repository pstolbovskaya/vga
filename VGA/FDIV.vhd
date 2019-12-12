----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:32:56 12/10/2019 
-- Design Name: 
-- Module Name:    FDIV - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FDIV is
	
	generic 
	( 
		n: integer := 2
	);
	port (
		CLK : in std_logic;
		RST : in std_logic;
		CE : in std_logic;
		K : in std_logic_vector(n - 1 downto 0);
		Q : out std_logic
	);
end FDIV;

architecture Behavioral of FDIV is
	signal counter : std_logic_vector(2**n-1 downto 0);
begin
	Main: process (RST, CLK, CE)
	begin
		if (RST = '1') then
			counter <= (others => '0');
		elsif (CE = '1') then
			if (rising_edge(CLK)) then
				counter <= counter + 1;
			end if;
		end if;
	end process;

	Q <= counter(conv_integer(K));

end Behavioral;

