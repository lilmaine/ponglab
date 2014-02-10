pong prelab
=======

383 Lab 2 - Pong

1. State diagram
==========
____________
![state diagram](state.png)


Bounds Checking
==============
______________
2. The bounds checking will be done using if/else statements checking to see if the x and y postions are on any of the
boundaries or near the paddle. If the ball hits the paddle or the right wall the x direction will be inverted. If the ball
hits the top or bottom the y direction will be inverted. The ball will be updated via ball_x = ball_x/y + dx/dy  where dx/dy
equals a constant change in pixels predetrmined at the beginning.

3. Register/Combinational equations
==============
______________
begin
	process(v_completed)
	begin
		if(ball_x <= 0 + RADIUS or ball_x >= WIDTH - RADIUS) then
			reset <= 1;
		elsif(ball_x <= paddle_x + RADIUS and ball_y <= paddle_y + paddle_height)
			dx <= -dx;
		elsif( ball_y <= HEIGHT - RADIUS or ball_y <= 0 + RADIUS)
			dy < = -dy;
		end ifl
	end process	
	
	
process(up, down)
begin
	if(paddle_y <= paddle_height or paddle_y >= HEIGHT - paddle_height) then
		paddle_y <= paddle_y;
	elsif(up = '1') then
		paddle_y <= paddle_y + dy;
	elsif(down = '1') then
		paddle_y <= paddle_y - dy;
	end if;
end process;
