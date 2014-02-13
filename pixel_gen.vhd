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
           r : out  STD_LOGIC_VECTOR (7 downto 0);
           g : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0));
end pixel_gen;

architecture Behavioral of pixel_gen is

begin
process(row, column, blank, switch_1, switch_2)
begin
--above of AF
	if(blank = '0') then
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

