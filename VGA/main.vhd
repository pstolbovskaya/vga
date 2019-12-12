library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
	generic (N : integer := 4);
	port (
		CLK : in std_logic;
		RST : in std_logic;
		HSYNC : out std_logic;
		VSYNC : out std_logic;
		R : out std_logic_vector(N - 1 downto 0);
		G : out std_logic_vector(N - 1 downto 0);
		B : out std_logic_vector(N - 1 downto 0)
	);
end main;


architecture Behavioral of main is

	component FDIV
		generic ( n: integer := 2);
		port (
			CLK : in std_logic;
			RST : in std_logic;
			CE : in std_logic;
			Q : out std_logic
		);
	end component;
	
	component VGA_DRIVER
		port (
			CLK : in std_logic;
			RST : in std_logic;
			HSYNC : out std_logic;
			VSYNC : out std_logic;
			HorPos : integer; 
			VerPos : integer;
			disp_ena : out std_logic
		);
	end component;

	component ADDRESS_HANDLER
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
	end component;

	component Picture_Block_RAM 
		generic (
			AddressWidth : integer := 16;
			DataWidth : integer := 12
		);
		port (
			CLK : in std_logic;
			WR : in std_logic;
			AB : in std_logic_vector(0 to AddressWidth - 1);
			DB : inout std_logic_vector(0 to DataWidth - 1)
		);
	end component;
	
	constant screen_width : integer := 640;
	constant screen_height : integer := 480;
	
	signal div_CLK: std_logic;
--	signal out_h_pos : std_logic;
--	signal out_v_pos : std_logic;
	signal out_h_pos : integer;
	signal out_v_pos : integer;
	signal out_addr : std_logic_vector(15 downto 0);
	signal rgb : std_logic_vector(0 to 11);
begin

	U1: FDIV port map 
	(
		CLK => CLK,
		RST => RST,
		CE => '1',
		Q => div_CLK
	);

	U2: VGA_DRIVER port map 
	(
		CLK => div_CLK,
		RST => RST,
		HSYNC => HSYNC,
		VSYNC => VSYNC,
		HorPos => out_h_pos,
		VerPos => out_v_pos
	);
	
	U3: ADDRESS_HANDLER 
	generic map
	(
		Height => screen_height,
		Width => screen_width
	)
	port map 
	(
		CLK => div_CLK,
		h_pos => out_h_pos,
		v_pos => out_v_pos,
		addr_pos => out_addr
	);

	U4: Picture_Block_RAM
	generic map 
	(
		AddressWidth => 16,
		DataWidth => 12
	)
	port map 
	(
		CLK => div_CLK,
		WR => '1',
		AB => out_addr,
		DB => rgb
	);
	
	R <= rgb(0 to 3);
	G <= rgb(4 to 7);
	B <= rgb(8 to 11);
end Behavioral;
