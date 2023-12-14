module game_logic (
    input clk,
    input rst,
	 input left,
	 input right,
	 output reg [8:0] ball_x,
	 output reg [8:0] ball_y,
    output reg [8:0] paddle_x,
    output reg [8:0] brick1_x,
    output reg [8:0] brick1_y,
	 output reg [8:0] brick2_x,
    output reg [8:0] brick2_y,
	 output reg [8:0] brick3_x,
    output reg [8:0] brick3_y,
	 output reg [8:0] brick4_x,
    output reg [8:0] brick4_y,
	 output reg [8:0] brick5_x,
    output reg [8:0] brick5_y,
	 output reg [8:0] brick6_x,
    output reg [8:0] brick6_y,
	 output reg [5:0] brick_exist,
	 output reg game_over
);

reg [5:0] brick_collided;
reg [5:0] brick_created;
reg [24:0] delay_done_bricks;
reg [24:0] delay_done_ball;
reg ball_launched;

paddle paddle_inst (
	.clk(clk),
	.rst(rst),
	.left(left),
	.right(right),
	.x(paddle_x)
);

ball ball_inst (
	.clk(clk),
	.rst(rst),
	.start(start),
	.destroyed(game_over),
	.dx(dx),
	.dy(dy),
	.delay_done(delay_done_ball),
	.x(ball_x),
	.y(ball_y),
	.launched(ball_launched)
);

brick brick1 (
	.clk(clk),
	.rst(rst),
	.init_x(134),
	.init_y(18),
	.collided(brick_collided[0]),
	.created(brick_created[0]),
	.delay_done(delay_done_bricks),
	.x(brick1_x),
	.y(brick1_y),
	.exist(brick_exist[0]),
);

brick brick2 (
	.clk(clk),
	.rst(rst),
	.init_x(197),
	.init_y(18),
	.collided(brick_collided[1]),
	.created(brick_created[1]),
	.delay_done(delay_done_bricks),
	.x(brick2_x),
	.y(brick2_y),
	.exist(brick_exist[1]),
);

brick brick3 (
	.clk(clk),
	.rst(rst),
	.init_x(260),
	.init_y(18),
	.collided(brick_collided[2]),
	.created(brick_created[2]),
	.delay_done(delay_done_bricks),
	.x(brick3_x),
	.y(brick3_y),
	.exist(brick_exist[2]),
);

brick brick4 (
	.clk(clk),
	.rst(rst),
	.init_x(323),
	.init_y(18),
	.collided(brick_collided[3]),
	.created(brick_created[3]),
	.delay_done(delay_done_bricks),
	.x(brick4_x),
	.y(brick4_y),
	.exist(brick_exist[3]),
);

brick brick5 (
	.clk(clk),
	.rst(rst),
	.init_x(386),
	.init_y(18),
	.collided(brick_collided[4]),
	.created(brick_created[4]),
	.delay_done(delay_done_bricks),
	.x(brick1_x),
	.y(brick1_y),
	.exist(brick_exist[4]),
);

brick brick6 (
	.clk(clk),
	.rst(rst),
	.init_x(449),
	.init_y(18),
	.collided(brick_collided[5]),
	.created(brick_created[5]),
	.delay_done(delay_done_bricks),
	.x(brick2_x),
	.y(brick2_y),
	.exist(brick_exist[5]),
);

collision collision_inst (
	.clk(clk),
	.rst(rst),
	.ball_x(ball_x),
	.ball_y(ball_y),
	.ball_dx(ball_dx),
	.ball_dy(ball_dy),
	.paddle_x(paddle_x),
	.brick1_x(brick1_x),
	.brick1_y(brick1_y),
	.brick2_x(brick2_x),
	.brick2_y(brick2_y),
	.brick3_x(brick3_x),
	.brick3_y(brick3_y),
	.brick4_x(brick4_x),
	.brick4_y(brick4_y),
	.brick5_x(brick5_x),
	.brick5_y(brick5_y),
	.brick6_x(brick6_x),
	.brick6_y(brick6_y),
	.game_over(game_over),
	.dx(dx),
	.dy(dy)
);	
		

endmodule