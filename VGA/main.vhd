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
			db : in std_logic_vector(11 downto 0);
			rgb : out std_logic_vector(11 downto 0);
			HorPos : out integer;
			VerPos : out integer
		);
	end component;

	component ADDRESS_HANDLER
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
	end component;

	component Picture_Block_RAM 
		generic (
			AddressWidth : integer := 556;
			DataWidth : integer := 12
		);
		port (
			CLK : in std_logic;
			WR : in std_logic;
			AB : in std_logic_vector(AddressWidth - 1 downto 0);
			draw_on : in std_logic;
			DB : out std_logic_vector(DataWidth - 1 downto 0)
		);
	end component;
	
	component RAM
		port (
			addra : in std_logic_vector (16 downto 0);
			CLKA : in std_logic;
			douta : out std_logic_vector(11 downto 0)
		);
	end component;
	
	constant screen_width : integer := 640;
	constant screen_height : integer := 480;
	
	constant divide_counter : std_logic_vector(2 downto 0) := "100";
	
	signal div_CLK: std_logic;
	signal addra : std_logic_vector (16 downto 0);
--	signal out_h_pos : std_logic;
--	signal out_v_pos : std_logic;
	signal out_h_pos : integer;
	signal out_v_pos : integer;
	signal draw_on : std_logic := '1';
	signal out_addr : std_logic_vector(555 downto 0);
	signal rgb : std_logic_vector(11 downto 0);
	signal not_rgb : std_logic_vector(11 downto 0);
	signal db : std_logic_vector(11 downto 0);
begin

--	U0: RAM
--	port map (
--		addra => addra,
--		clka => div_clk,
--		douta => rgb
--	);

	U1: FDIV  
	generic map
	(
		n => 2
	)
	port map
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
		db => db,
		rgb => rgb,
		HorPos => out_h_pos,
		VerPos => out_v_pos
	);
	
	U3: ADDRESS_HANDLER 
	generic map
	(
		ImgHeight => 480,
		ImgWidth => 640,
		Height => screen_height,
		Width => screen_width
	)
	port map 
	(
		CLK => div_CLK,
		h_pos => out_h_pos,
		v_pos => out_v_pos,
		draw_on => draw_on,
		addr_pos => out_addr
	);

	U4: Picture_Block_RAM
	generic map 
	(
		AddressWidth => 556,
		DataWidth => 12
	)
	port map 
	(
		CLK => div_CLK,
		WR => '1',
		AB => out_addr,
		draw_on => draw_on,
		DB => db
	);
	
	R <= rgb(3 downto 0);
	G <= rgb(7 downto 4);
	B <= rgb(11 downto 8);
end Behavioral;

