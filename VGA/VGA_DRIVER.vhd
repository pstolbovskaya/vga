----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:24:16 12/10/2019 
-- Design Name: 
-- Module Name:    VGA_DRIVER - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity VGA_DRIVER is
	port(
		CLK : in std_logic;
		RST : in std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		db : in std_logic_vector(11 downto 0) := "000000000000";
		rgb : out std_logic_vector(11 downto 0);
		HorPos : out integer; 
		VerPos : out integer
	);
end VGA_DRIVER;

architecture Beh of VGA_DRIVER is

	constant HD : integer := 639; --400
	constant HFP : integer := 16;
	constant HSP : integer := 96;
	constant HBP : integer := 48;
	
	constant VD : integer := 479; --399
	constant VFP : integer := 11;
	constant VSP : integer := 2;
	constant VBP : integer := 31;
	
	signal hPos : integer := 0;
	signal vPos : integer := 0;
	
	signal video_on : std_logic;
begin

	H_POS_COUNTER : process(CLK, RST)
	begin
		if (RST = '1') then
			hPos <= 0;
		elsif (rising_edge(CLK)) then
			if (hPos = (HD + HFP + HSP + HBP)) then
				hPos <= 0;
			else
				hPos <= hPos + 1;
			end if;
		end if;
--		HorPos <= hPos;
	end process;
	
	V_POS_COUNTER : process(CLK, RST, hPos)
	begin
		if (RST = '1') then
			vPos <= 0;
		elsif (rising_edge(CLK)) then
			if (hPos = (HD + HFP + HSP + HBP)) then
				if (vPos = (VD + VFP + VSP + VBP)) then
					vPos <= 0;
				else
					vPos <= vPos + 1;
				end if;
			end if;
		end if;
--		VerPos <= vPos;
	end process;
	
	H_SYNC: process(CLK, RST, hPos)
	begin
		if (RST = '1') then
			HSYNC <= '0';
		elsif (rising_edge(CLK)) then
			if ((hPos > HD + HFP) and (hPos <= HD + HFP + HSP)) then
				HSYNC <= '0';
			else
				HSYNC <= '1';
			end if;
		end if;
	end process;
	
	V_SYNC: process(CLK, RST, vPos)
	begin
		if (RST = '1') then
			VSYNC <= '0';
		elsif (rising_edge(CLK)) then
			if ((vPos > VD + VFP) and (vPos <= VD + VFP + VSP)) then
				VSYNC <= '0';
			else
				VSYNC <= '1';
			end if;
		end if;
	end process;
	
	HorPos <= hPos;
	VerPos <= vPos;
	
	VIDEO: process (CLK, RST, hPos, vPos)
	begin
		if (RST = '1') then
			video_on <= '0';
		elsif (rising_edge(CLK)) then
			if (hPos < HD and vPos < VD) then
				video_on <= '1';
			else
				video_on <= '0';
			end if;
		end if;
	end process;

	
	draw:process(CLK, hPos, vPos, video_on, db)
	begin
		if (RST = '1') then
			RGB<=(others=>'0');
		elsif(CLK'event and CLK = '1')then
			if(video_on = '1')then
				if ((hPos > 0) AND (hPos < HD)) AND ((vPos > 0) AND (vPos < VD)) then
					RGB<=db;
				else 
					RGB<=(others=>'0');
				end if;
			end if;
		end if;
		end process;

end Beh;

