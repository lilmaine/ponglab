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
--	 generic (dx: unsigned(3 downto 0);
--				dy: unsigned;
--				velocity: "1");
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
	type state_type is
		(stationary, paddle_up, paddle_down);
	signal state_reg, state_next: state_type;
	signal ballx_reg, bally_reg, ballx_next, bally_next, paddley_next : unsigned(10 downto 0);
	
	signal paddley_reg: unsigned(10 downto 0) := to_unsigned(240, 11);

begin
	-- state register
process(clk, reset)
	begin
		if (reset='1') then
			state_reg <= stationary;
		elsif rising_edge(clk) then
			state_reg <= state_next;
		end if;
	end process;

	--output buffer
	process(clk)
	begin
		if rising_edge(clk) then
			paddley_reg <= paddley_next;
		end if;
	end process;
		
	--next-state logic
		process(state_reg, up, down)
		begin
			state_next <= state_reg;
		
			case state_reg is
				when paddle_up =>					
					if(up='0') then
						state_next <= stationary;
					elsif(down='1') then
						state_next <= paddle_down;
					end if;						
				when paddle_down =>
					if(down='0') then
						state_next <= stationary;
					elsif(up='1') then
						state_next <= paddle_up;
					end if;	
				when stationary =>
					if(up='1') then
						state_next <= paddle_up;
					elsif(down='1') then
						state_next <= paddle_down;
					end if;
			end case;		
	end process;	
	
	--look ahead output logic
	process(paddley_next, paddley_reg)
	begin
			paddley_next <= paddley_reg;
			case state_next is
				when stationary =>
				when paddle_up =>
					paddley_next <= paddley_reg + 1;
				when paddle_down =>
					paddley_next <= paddley_reg - 1;
			end case;		
	end process;
	paddle_y <= paddley_reg;

end Behavioral;




