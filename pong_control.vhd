----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:52:45 02/10/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
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

entity pong_control is

    Port (
          clk         : in std_logic;
          reset       : in std_logic;
          up          : in std_logic;
          down        : in std_logic;
          v_completed : in std_logic;
          ball_x      : out unsigned(10 downto 0);
          ball_y      : out unsigned(10 downto 0);
          paddle_y    : out unsigned(10 downto 0)
  );
end pong_control;


architecture Behavioral of pong_control is
	type p_state_type is
		(stationary, paddle_up, paddle_down);	
	type b_state_type is
		(moving, hit_top_wall, hit_bottom_wall, hit_right_wall, hit_paddle, hit_left_wall);	
	signal p_state_reg, p_state_next: p_state_type;
	signal b_state_reg, b_state_next: b_state_type;	
	signal  paddley_next, count_next : unsigned(10 downto 0);
	signal count_reg: unsigned(10 downto 0):= "00000000000";	
	signal paddley_reg: unsigned(10 downto 0) := to_unsigned(240, 11);
	signal ballx_reg, ballx_next: unsigned(10 downto 0) := to_unsigned(20, 11);
	signal bally_reg, bally_next: unsigned(10 downto 0) := to_unsigned(210, 11);
	
	shared variable x_direction, y_direction: STD_LOGIC := '1';
	shared variable x_velocity, y_velocity : integer := 1;
	
	constant speed : integer := 600;
	constant HEIGHT : integer := 480;
	constant WIDTH : integer := 640;
	
	constant ball_radius : integer := 8;
	
begin
	-- paddle state register
process(clk, reset)
	begin
		if (reset='1') then
			p_state_reg <= stationary;
		elsif rising_edge(clk) then
			p_state_reg <= p_state_next;
		end if;
	end process;

	--paddle output buffer
	process(clk)
	begin
		if rising_edge(clk) then
			paddley_reg <= paddley_next;
		end if;
	end process;

	-- count register						
	count_next <= (others => '0') when count_reg = speed else
					count_reg +1 when v_completed = '1' else
					count_reg;
	
	process(clk, reset)
	begin
		if (reset ='1') then
			count_reg <= (others => '0');
		elsif rising_edge(clk) then
			count_reg <= count_next;
		end if;
	end process;	


		
	--paddle next-state logic
		process(p_state_reg, up, down, count_reg)
		begin
			p_state_next <= p_state_reg;
			if(count_reg = speed) then
			case p_state_reg is
				when paddle_up =>					
					if(up='0') then
						p_state_next <= stationary;
					elsif(down='1') then
						p_state_next <= paddle_down;
					end if;						
				when paddle_down =>
					if(down='0') then
						p_state_next <= stationary;
					elsif(up='1') then
						p_state_next <= paddle_up;
					end if;	
				when stationary =>
					if(up='1') then
						p_state_next <= paddle_up;
					elsif(down='1') then
						p_state_next <= paddle_down;
					end if;
			end case;
			end if;	
	end process;	
	
	--look ahead output logic
	process(paddley_next, paddley_reg, count_reg, p_state_next)
	begin
			paddley_next <= paddley_reg;
			if(count_reg = speed) then
				case p_state_next is
					when stationary =>
					when paddle_up =>
						if (paddley_reg >0) then
							paddley_next <= paddley_reg - to_unsigned(1,11);
						end if;	
					when paddle_down =>
						if (paddley_reg < 450) then
							paddley_next <= paddley_reg + to_unsigned(1,11);
						end if;
				end case;
			end if;		
	end process;
-----------------------------------------------------------------------------------------------------	
	
	
	--state register for the ball
	process(reset, clk)
	begin			
		if(reset='1') then
			b_state_reg <= moving;
		elsif(rising_edge(clk)) then
			b_state_reg <= b_state_next;
		end if;
	end process;

	--output buffer for ball
	process(clk)
	begin
		if(rising_edge(clk)) then
			bally_reg <= bally_next;
			ballx_reg <= ballx_next;
		end if;
	end process;

	--next state logic for ball
	process(b_state_reg, ballx_reg, bally_reg)
	begin
	b_state_next <= b_state_reg;
	if(count_reg = speed) then
		case b_state_reg is
			when moving =>

				if (ballx_reg >= 625) then
					b_state_next <= hit_right_wall;
				elsif (ballx_reg <= 1) then
					b_state_next <= hit_left_wall;
				end if;

				if	(bally_reg >= 479) then
					b_state_next <= hit_bottom_wall;
				elsif (bally_reg <= 1) then
					b_state_next <= hit_top_wall;
				end if;

				if (ballx_reg <=20 and bally_reg >= paddley_reg and bally_reg <= paddley_reg+100) then
					if (bally_reg >= (paddley_reg + 50)
							 and bally_reg <= (paddley_reg + 100)) then
						b_state_next <= hit_paddle;
					elsif (bally_reg >= paddley_reg and bally_reg < (paddley_reg + 50)) then
						b_state_next <= hit_paddle;
					end if;
				end if;
			when hit_top_wall =>
				b_state_next <= moving;
			when hit_right_wall =>
				b_state_next <= moving;
			when hit_bottom_wall =>
				b_state_next <= moving;
			when hit_paddle =>
				b_state_next <= moving;
			when hit_left_wall =>
			end case;
	end if;
	end process;

	--look ahead output logic
	process(b_state_next, bally_reg, ballx_reg, count_reg)
	begin
		bally_next <= bally_reg;
		ballx_next <= ballx_reg;
		if(count_reg = speed) then
			case b_state_next is
				when hit_left_wall =>
				when moving =>
					if(x_direction = '1' and y_direction = '0') then
						bally_next <= bally_reg + to_unsigned(y_velocity, 11);
						ballx_next <= ballx_reg + to_unsigned(x_velocity, 11);
					elsif(x_direction = '0' and y_direction = '0') then
						bally_next <= bally_reg + to_unsigned(y_velocity, 11);
						ballx_next <= ballx_reg - to_unsigned(x_velocity, 11);
					elsif(x_direction = '0' and y_direction = '1') then
						bally_next <= bally_reg - to_unsigned(y_velocity, 11);
						ballx_next <= ballx_reg - to_unsigned(x_velocity, 11);
					elsif(x_direction = '1' and y_direction = '1') then
						bally_next <= bally_reg - to_unsigned(y_velocity, 11);
						ballx_next <= ballx_reg + to_unsigned(x_velocity, 11);
					end if;
				when hit_top_wall =>
					y_direction := '0';
					bally_next <= bally_reg + to_unsigned(y_velocity, 11);
				when hit_right_wall =>
					x_direction := '0';
					ballx_next <= ballx_reg - to_unsigned(x_velocity, 11);
				when hit_bottom_wall => 
					y_direction := '1';
					bally_next <= bally_reg - to_unsigned(y_velocity, 11);
				when hit_paddle =>
					x_direction := '1';
					ballx_next <= ballx_reg + to_unsigned(x_velocity, 11);
			end case;
		end if;
	end process;

	--outputs
	paddle_y <= paddley_reg;
	ball_x <= ballx_reg;
	ball_y <= bally_reg;

end Behavioral;