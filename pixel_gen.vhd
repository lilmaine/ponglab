----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:31:46 01/29/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
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

entity pixel_gen is
    Port ( row : in  unsigned (10 downto 0);
           column : in  unsigned (10 downto 0);
           blank : in  STD_LOGIC;
			  ball_x : in unsigned(10 downto 0);
			  ball_y : in unsigned(10 downto 0);	
			  paddle_y : in unsigned(10 downto 0);
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pixel_gen;

architecture Behavioral of pixel_gen is

constant paddle_width, ball_radius: unsigned(4 downto 0) := "01000";
constant  paddle_height: unsigned(4 downto 0) := "11100";


begin
process(row, column, blank, paddle_y, ball_x, ball_y)
begin

-- Paddle
			if(row >=paddle_y and column >=5 and column <= paddle_width and row <= paddle_y + to_integer(paddle_height)) then
					r <= (others => '0');
					g <= "11111111";						
					b <= (others => '0');
--Ball					
			elsif(row >= ball_y and column >=ball_x and column <= ball_x + ball_radius and row <= ball_y+ ball_radius) then
					g <= (others => '0');
					r <= "11111111";						
					b <= (others => '0');
--Ball					
--			elsif(row >= to_integer(ball_y) and column >= to_integer(ball_x) and column <= (to_integer(ball_x) + to_integer(ball_radius)) and row <= to_integer(ball_x) + to_integer(ball_radius)) then
--					g <= (others => '0');
--					r <= "11111111";						
--					b <= (others => '0');

--above of AF
			elsif(blank = '0') then
					if(row < 140) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');					
--AF Logo			
			elsif(row >= 140) then
				if (column >=200 and column <= 420 and row <=340) then
					r <= (others => '0');
					g <= (others => '0');
					b <= "11111111";
					--Top BOx of A
					if(column >=220 and column <=280 and row >= 160 and row <= 220) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');
					--bottom of A	
					elsif(column >=220 and column <=280 and row >= 240) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');						
					--dividing line	
					elsif(column >=300 and column <= 320) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');						
					--end if;	
					--Top BOx of F
					elsif(column >=340 and row >= 160 and row <= 220) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');
					--bottom of F	
					elsif(column >=340 and row >= 240) then
						r <= (others => '0');
						g <= (others => '0');
						b <= (others => '0');
					end if;	
				else
					r <= (others => '0');
					g <= (others => '0');
					b <= (others => '0');
				end if;
--below AF				
			elsif(row > 340) then
					r <= (others => '0');
					g <= (others => '0');
					b <= (others => '0');				
			end if;
	else
		r <= "11111111";
		g <= "11111111";
		b <= "11111111";			
		
	end if;
	


	
	
	
end process;


end Behavioral;

