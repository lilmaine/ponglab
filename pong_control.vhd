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
	signal p_state_reg, p_state_next: p_state_type;
	type b_state_type is
		(new_game, game_over, moving, hit_paddle, hit_top_wall, hit_right_wall, hit_bottom_wall);	
	signal b_state_reg, b_state_next: b_state_type;	
	signal  paddley_next, count_next : unsigned(10 downto 0);
	signal count_reg: unsigned(10 downto 0):= "00000000000";	
	signal paddley_reg: unsigned(10 downto 0) := to_unsigned(240, 11);
	signal ballx_reg, ballx_next: unsigned(10 downto 0) := to_unsigned(20, 11);
	signal bally_reg, bally_next: unsigned(10 downto 0) := to_unsigned(245, 11);
	signal direction: unsigned(1 downto 0) := "11";
	
	constant speed : integer := 1000;
	constant HEIGHT : integer := 480;
	constant WIDTH : integer := 640;
	constant dx, dy : integer := 1;
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
	
	
--	-- ball state register
--	process(clk, reset)
--	begin
--		if (reset='1') then
--			b_state_reg <= new_game;
--		elsif rising_edge(clk) then
--			b_state_reg <= b_state_next;
--		end if;
--	end process;	
--	
--	-- ball output buffer
--	process(clk)
--	begin
--		if rising_edge(clk) then
--			ballx_reg <= ballx_next;
--			bally_reg <= bally_next;
--		end if;
--	end process;	
--	
--	--ball next-state logic
--		process(b_state_reg, ballx_reg, bally_reg, count_reg)
--		begin
--			b_state_next <= b_state_reg;
--			if(count_reg = speed) then
--				case b_state_reg is
--					when new_game =>					
--						b_state_next <= moving;
--					when moving =>
--						-- left wall or paddle hit
--						if(ballx_reg <= 13) then
--							if(bally_reg <= paddley_reg and bally_reg >= (paddley_reg + 28)) then
--								b_state_next <= hit_paddle;
--							else
--								b_state_next <= game_over;
--							end if;
--						end if;
--						-- right wall
--						if(ballx_reg + 8 >= WIDTH) then
--							b_state_next <= hit_right_wall;
--						end if;
--						-- bottom wall
--						if(bally_reg + 8 >= HEIGHT) then
--							b_state_next <= hit_bottom_wall;
--						end if;
--						-- top wall
--						if(bally_reg - 8 >= 0) then
--							b_state_next <= hit_top_wall;
--						end if;					
--					when hit_paddle =>
--						b_state_next <= moving;
--					when hit_top_wall =>
--						b_state_next <= moving;
--					when hit_bottom_wall =>
--						b_state_next <= moving;						
--					when hit_right_wall =>
--						b_state_next <= moving;	
--					when game_over =>					
--				end case;
--			end if;	
--	end process;	
--	
--	-- ball look ahead output logic
--	process(b_state_reg, ballx_next, bally_reg, ballx_reg, count_reg, direction)
--	begin
--			bally_next <= bally_reg;
--			ballx_next <= ballx_reg;
--			if(count_reg = speed) then
--				case b_state_next is
--					when new_game =>
--						ballx_next <= to_unsigned(20,11);
--						bally_next <= to_unsigned(240,11);
--					when moving =>
--						if(direction = "11") then
--							bally_next <= bally_reg - to_unsigned(dy,11);
--							ballx_next <= ballx_reg + to_unsigned(dx,11);
--						elsif(direction = "10") then
--							bally_next <= bally_reg + to_unsigned(dy,11);
--							ballx_next <= ballx_reg + to_unsigned(dx,11);
--						elsif(direction = "01") then
--							bally_next <= bally_reg - to_unsigned(dy,11);
--							ballx_next <= ballx_reg - to_unsigned(dx,11);	
--						elsif(direction = "00") then
--							bally_next <= bally_reg + to_unsigned(dy,11);
--							ballx_next <= ballx_reg - to_unsigned(dx,11);								
--						end if;	
--					when hit_paddle =>
--						if(direction = "01") then
--							direction <= "11";
--						else
--							direction <= "10";
--						end if;
--					when hit_bottom_wall =>
--						if(direction = "00") then
--							direction <= "01";
--						else
--							direction <= "11";
--						end if;
--					when hit_top_wall =>
--						if(direction = "11") then
--							direction <= "10";
--						else
--							direction <= "00";
--						end if;
--					when hit_right_wall =>
--						if(direction = "11") then
--							direction <= "01";
--						else
--							direction <= "00";
--						end if;
--					when game_over =>
--				end case;
--			end if;		
--	end process;	
	
	
		
	--outputs
	paddle_y <= paddley_next;
	ball_x <= ballx_next;
	ball_y <= bally_next;
	
end Behavioral;




