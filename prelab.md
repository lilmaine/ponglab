pong prelab
=======

383 Lab 2 - Pong

1. State diagram
=========
____________
![state diagram](state.png)


Bounds Checking
=========
_________
2. The bounds checking will be done using if/else statements checking to see if the x and y postions are on any of the
boundaries or near the paddle. If the ball hits the paddle or the right wall the x direction will be inverted. If the ball
hits the top or bottom the y direction will be inverted. The ball will be updated via ball_x = ball_x/y + dx/dy  where dx/dy
equals a constant change in pixels predetrmined at the beginning.

3. Register/Combinational equations
===========
___________
![code](code.png)
