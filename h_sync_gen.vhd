----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:18:08 01/29/2014 
-- Design Name: 
-- Module Name:    h_sync_gen - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity h_sync_gen is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           h_sync : out  STD_LOGIC;
           blank : out  STD_LOGIC;
           completed : out  STD_LOGIC;
           column : out  unsigned (10 downto 0));
end h_sync_gen;

architecture look_ahead_moore of h_sync_gen is
	type state_type is
		(active_video, front_porch, sync, back_porch, completed_state);
	signal count_reg: unsigned(10 downto 0):= "00000000000";
	signal state_reg, state_next: state_type;
	signal hsync_reg, hsync_next, blank_reg, blank_next, completed_reg, completed_next: std_logic;
	signal column_reg, column_next, count_next: unsigned (10 downto 0);


begin
	-- state register
	process(clk, reset)
	begin
		if (reset='1') then
			state_reg <= active_video;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;
	
	--output buffer
	process(clk)
	begin
		if rising_edge(clk) then
			hsync_reg <= hsync_next;
			blank_reg <=	blank_next;
			completed_reg <= completed_next;
			column_reg <=  column_next;
		end if;
	end process;
	
	count_next <= 	(others => '0') when state_reg /= state_next else 
						count_reg + 1;
	
	--count register
	
	process(clk, reset)
	begin
		if (reset ='1') then
			count_reg <= (others => '0');
		elsif rising_edge(clk) then
			count_reg <= count_next;
		end if;
	end process;	
			
	
	--next-state logic
		process(state_reg, count_reg)
		begin
			state_next <= state_reg;
		
			case state_reg is
				when active_video =>
					if (count_reg = 640) then
						state_next <= front_porch;
					end if;
				when front_porch =>
					if (count_reg = 16) then
						state_next <= sync;
					end if;
				when sync =>
					if (count_reg = 96) then
						state_next <= back_porch;
					end if;
				when back_porch =>
					if (count_reg = 47) then
						state_next <= completed_state;
					end if;				
				when completed_state =>
					state_next <= active_video;
			end case;		
	end process;
	
--column <= count_reg when count_reg < 640 else "00000000000"; 

	--look ahead output logic
	process(state_next, count_reg)
	begin
			hsync_next <= '1';
			blank_next <=	'1';
			completed_next <= '0';
			column_next <=  (others => '0');
			case state_next is
				when active_video =>
					blank_next <=	'0';
					column_next <= count_reg;
				when front_porch =>
				when sync =>
					hsync_next <= '0';
				when back_porch =>
				when completed_state =>
					completed_next <= '1';
			end case;
	end process;
	--output
	h_sync <= hsync_reg;
	blank <=	blank_reg;
	completed <= completed_reg;
	column <=  column_reg;

end look_ahead_moore;

