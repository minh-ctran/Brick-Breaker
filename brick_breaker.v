module brick_breaker (
    input wire clk,
    input wire rst,
    input right,
	 input left,
	 input start, 
	 output vga_clk,
	 output vga_sync,
	 output vga_blank,
    output wire [7:0] red,
    output wire [7:0] green,
    output wire [7:0] blue,
    output wire vga_hsync,
    output wire vga_vsync,
	 output reg game_over,
	 output reg victory
);

wire [8:0] ball_x, ball_y;
wire [8:0] paddle_x;
wire [8:0] brick1_x, brick1_y;
wire [8:0] brick2_x, brick2_y;
wire [8:0] brick3_x, brick3_y;
wire [8:0] brick4_x, brick4_y;
wire [8:0] brick5_x, brick5_y;
wire [8:0] brick6_x, brick6_y;
wire [5:0] bricks_exist;
wire [5:0] bricks_death_zone;

parameter delay_done_bricks = 50000000;
parameter delay_done_ball = 50000000;

reg [7:0] color_input;
reg launch;
wire clk_25; //25MHz clock for vga
wire [9:0] pixel_x;
wire [9:0] pixel_y;

reg [3:0] s;
reg [3:0] ns;

reg lose;
reg win;

parameter START = 0,
			PLAY = 1,
			CHECK_STATUS = 2,
			LOSE = 3,
			WIN = 4;

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		s <= START;
	else 
		s <= ns;
end

always@(*)
begin
	case(s)
		START:
		begin
			if (launch == 1'b1)
				ns = PLAY;
			else 
				ns = START;
		end
		PLAY: ns = CHECK_STATUS;
		CHECK_STATUS:
		begin
			if (lose == 1'b1)
				ns = LOSE;
			else if (win == 1'b1)
				ns = WIN;
			else
				ns = PLAY;
		end
		LOSE: ns = LOSE;
		WIN: ns = WIN;
	endcase
end


always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		game_over <= 0;
		victory <= 0;
		launch <= 0;
	end
	else
	begin
		if (start == 1'b0)
			launch <= 1;
		case(s)
			START:
			begin
				game_over <= 0;
				victory <= 0;
			end
			PLAY:
			begin
				lose <= lose || bricks_death_zone[0] || bricks_death_zone[1] || bricks_death_zone[2] || bricks_death_zone[3] || bricks_death_zone[4] || bricks_death_zone[5];
				win <= (bricks_exist == 6'b0);
			end
			WIN: victory <= 1;
			LOSE: game_over <= 1;
		endcase
	end
end

// Instantiate ball, paddle, and bricks modules
ball ball_inst (
    .clk(clk),
    .rst(rst),
	.start(launch),
	 .delay_done(delay_done_ball),
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
    .bricks_exist(bricks_exist),
    .x(ball_x),
    .y(ball_y),
	 .destroyed(lose)
);

paddle paddle_inst (
    .clk(clk),
    .rst(rst),
    .left(left), // Connect left control signal
    .right(right), // Connect right control signal
	.start(launch), // Connect start control signal
    .x(paddle_x)
);

brick brick1_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(134),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick1_x),
    .y(brick1_y),
    .exist(bricks_exist[0]),
	 .game_over(bricks_death_zone[0])
);

brick brick2_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(197),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick2_x),
    .y(brick2_y),
    .exist(bricks_exist[1]),
	 .game_over(bricks_death_zone[1])
);

brick brick3_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(260),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick3_x),
    .y(brick3_y),
    .exist(bricks_exist[2]),
	 .game_over(bricks_death_zone[2])
);

brick brick4_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(323),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick4_x),
    .y(brick4_y),
    .exist(bricks_exist[3]),
	 .game_over(bricks_death_zone[3])
);

brick brick5_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(386),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick5_x),
    .y(brick5_y),
    .exist(bricks_exist[4]),
	 .game_over(bricks_death_zone[4])
);

brick brick6_inst (
    .clk(clk),
    .rst(rst),
    .ball_x(ball_x),
    .ball_y(ball_y),
    .init_x(449),
	.init_y(0),
    .delay_done(delay_done_bricks), // Connect delay_done signal
    .x(brick6_x),
    .y(brick6_y),
    .exist(bricks_exist[5]),
	 .game_over(bricks_death_zone[5])
);

// Instantiate VGA controller
vga_driver vga_inst (
    .clock(clk_25),
    .reset(!rst),
	 .color_in(color_input),
	 .pixel_x(pixel_x),
	 .pixel_y(pixel_y),
	 .hsync(vga_hsync),
    .vsync(vga_vsync),
	 .red(red),
    .green(green),
    .blue(blue),
	 .sync(vga_sync),
	 .clk(vga_clk),
	 .blank(vga_blank)
);

draw draw_things (
	.clk(clk),
	.rst(rst),
	.start(start),
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
	.bricks_exist(bricks_exist),
	.ball_x(ball_x),
	.ball_y(ball_y),
	.pixel_x(pixel_x),
	.pixel_y(pixel_y),/*
	.lose(lose),
	.win(win),*/
	.color_out(color_input)
);

clk_convert convert (
	.clk(clk),
	.half_clk(clk_25)
);

endmodule
