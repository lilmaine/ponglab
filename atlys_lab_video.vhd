----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:25 01/29/2014 
-- Design Name: 
-- Module Name:    atlys_lab_video - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_lab_video is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  up : in STD_LOGIC;
			  down: in STD_LOGIC;
			  BTNU: in STD_LOGIC;
			  BTND: in STD_LOGIC;
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end atlys_lab_video;

architecture barnett of atlys_lab_video is
    -- TODO: Signals, as needed
	 signal pixel_clk, red_s, blue_s, green_s, h_sync, v_sync, blank, clock_s, serialize_clk, serialize_clk_n, vcompleted_sig: std_logic;
	 signal red, green, blue: std_logic_vector (7 downto 0);
	 signal row_sig, column_sig, ballx_sig, bally_sig, paddley_sig: unsigned (10 downto 0);
	 
	 
begin
		
	--Instantiate VGA SYNC--

    -- Clock divider - creates pixel clock from 100MHz clock
    inst_DCM_pixel: DCM
    generic map(
                   CLKFX_MULTIPLY => 2,
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => pixel_clk
            );

    -- Clock divider - creates HDMI serial output clock
    inst_DCM_serialize: DCM
    generic map(
                   CLKFX_MULTIPLY => 10, -- 5x speed of pixel clock
                   CLKFX_DIVIDE   => 8,
                   CLK_FEEDBACK   => "1X"
               )
    port map(
                clkin => clk,
                rst   => reset,
                clkfx => serialize_clk,
                clkfx180 => serialize_clk_n
            );

    -- TODO: VGA component instantiation
	Inst_vga_sync: entity work.vga_sync(Behavioral) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		h_sync => h_sync,
		v_sync => v_sync,
		v_completed => vcompleted_sig,
		blank => blank,
		row => row_sig, 
		column => column_sig 
	);
	Inst_pixel_gen: entity work.pixel_gen(Behavioral) PORT MAP(
		row => row_sig,
		column => column_sig,
		blank => blank,
		ball_x => ballx_sig,
		ball_y => bally_sig,
		paddle_y => paddley_sig,
		r => red,
		g => green,
		b => blue
	);	 

	Inst_pong_control: entity work.pong_control(Behavioral) PORT MAP(
		clk => pixel_clk,
		reset => reset,
		up => BTNU,
		down => BTND,
		v_completed => vcompleted_sig,
		ball_x => ballx_sig,
		ball_y => bally_sig,
		paddle_y => paddley_sig 
	);
	 
    -- TODO: Pixel generator component instantiation

    -- Convert VGA signals to HDMI (actually, DVID ... but close enough)
    inst_dvid: entity work.dvid
    port map(
                clk       => serialize_clk,
                clk_n     => serialize_clk_n, 
                clk_pixel => pixel_clk,
                red_p     => red,
                green_p   => green,
                blue_p    => blue,
                blank     => blank,
                hsync     => h_sync,
                vsync     => v_sync,
                -- outputs to TMDS drivers
                red_s     => red_s,
                green_s   => green_s,
                blue_s    => blue_s,
                clock_s   => clock_s
            );

    -- Output the HDMI data on differential signalling pins
    OBUFDS_blue  : OBUFDS port map
        ( O  => TMDS(0), OB => TMDSB(0), I  => blue_s  );
    OBUFDS_red   : OBUFDS port map
        ( O  => TMDS(1), OB => TMDSB(1), I  => green_s );
    OBUFDS_green : OBUFDS port map
        ( O  => TMDS(2), OB => TMDSB(2), I  => red_s   );
    OBUFDS_clock : OBUFDS port map
        ( O  => TMDS(3), OB => TMDSB(3), I  => clock_s );

end barnett;

