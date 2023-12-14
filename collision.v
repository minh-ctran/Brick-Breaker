module collision (
    input clk,
    input rst,
	 input wire [8:0] ball_x,
	 input wire [8:0] ball_y,
    input wire [8:0] paddle_x,
    input wire [8:0] brick1_x,
    input wire [8:0] brick1_y,
	 input wire [8:0] brick2_x,
    input wire [8:0] brick2_y,
	 input wire [8:0] brick3_x,
    input wire [8:0] brick3_y,
	 input wire [8:0] brick4_x,
    input wire [8:0] brick4_y,
	 input wire [8:0] brick5_x,
    input wire [8:0] brick5_y,
	 input wire [8:0] brick6_x,
    input wire [8:0] brick6_y,
    output reg brick1,
	 output reg brick2,
	 output reg brick3,
	 output reg brick4,
	 output reg brick5,
	 output reg brick6,
	 output reg game_over,
	 output reg [3:0] dx,
	 output reg [3:0] dy
);

reg top_bottom;
reg left_right;
reg paddle;

always @(posedge clk or posedge rst) 
begin
	if (rst == 1'b0)
	begin
		paddle <= 0;
		brick1 <= 0;
		brick2 <= 0;
		brick3 <= 0;
		brick4 <= 0;
		brick5 <= 0;
		brick6 <= 0;
		top_bottom <= 0;
		left_right <= 0;
		game_over <= 0;
		dx <= 1;
		dy <= 1;
	end
	else
	begin
		if (ball_y + 19 >= 459 || brick1_y >= 458 || brick2_y >= 458 || brick3_y >= 458 || brick4_y >= 458 || brick5_y >= 458 || brick6_y >= 458)
			game_over <= 1;
		else
		begin
			brick1 <= ((ball_x <= brick1_x + 57) && (ball_x + 20 >= brick1_x)) && ((ball_y <= brick1_y + 19) && (ball_y + 20 >= brick1_y));
			brick2 <= ((ball_x <= brick2_x + 57) && (ball_x + 20 >= brick2_x)) && ((ball_y <= brick2_y + 19) && (ball_y + 20 >= brick2_y));
			brick3 <= ((ball_x <= brick3_x + 57) && (ball_x + 20 >= brick3_x)) && ((ball_y <= brick3_y + 19) && (ball_y + 20 >= brick3_y));
			brick4 <= ((ball_x <= brick4_x + 57) && (ball_x + 20 >= brick4_x)) && ((ball_y <= brick4_y + 19) && (ball_y + 20 >= brick4_y));
			brick5 <= ((ball_x <= brick5_x + 57) && (ball_x + 20 >= brick5_x)) && ((ball_y <= brick5_y + 19) && (ball_y + 20 >= brick5_y));
			brick6 <= ((ball_x <= brick6_x + 57) && (ball_x + 20 >= brick6_x)) && ((ball_y <= brick6_y + 19) && (ball_y + 20 >= brick6_y));
			
			paddle = (ball_x <= paddle_x + 62) && (ball_x + 20 >= paddle_x) && (ball_y + 20 == 458);
			
			if (paddle == 1'b1)
			begin
				if (ball_x + 20 >= paddle_x && ball_x <= paddle_x + 9)
					dx <= -dx;
				else if (ball_x + 19 >= paddle_x + 10 && ball_x <= paddle_x + 30 && dx > 1)
					dx <= -(dx - 1);
				else if (ball_x + 19 >= paddle_x + 31 && ball_x <= paddle_x + 62 && dx <= 5)
					dx <= -(dx + 1);
			end
			
			left_right = (brick1 && (ball_y >= brick1_y + 19) && (ball_y + 20 >= brick1_y)) ||
							(brick2 && (ball_y <= brick2_y + 19) && (ball_y + 20 >= brick2_y)) ||
							(brick3 && (ball_y <= brick3_y + 19) && (ball_y + 20 >= brick3_y)) || 
							(brick4 && (ball_y <= brick4_y + 19) && (ball_y + 20 >= brick4_y)) ||
							(brick5 && (ball_y <= brick5_y + 19) && (ball_y + 20 >= brick5_y)) ||
							(brick6 && (ball_y <= brick6_y + 19) && (ball_y + 20 >= brick6_y)) ||
							(ball_x + 1 == 505) || (ball_x - 1 == 133) || (ball_y + 19 == 458);

			top_bottom = (brick1 && (ball_x <= brick1_x + 57) && (ball_x + 20 >= brick1_x)) ||
							(brick2 && (ball_x <= brick2_x + 57) && (ball_x + 20 >= brick2_x)) ||
							(brick3 && (ball_x <= brick3_x + 57) && (ball_x + 20 >= brick3_x)) ||
							(brick4 && (ball_x <= brick4_x + 57) && (ball_x + 20 >= brick4_x)) ||
							(brick5 && (ball_x <= brick5_x + 57) && (ball_x + 20 >= brick5_x)) ||
							(brick6 && (ball_x <= brick6_x + 57) && (ball_x + 20 >= brick6_x)) ||
							(ball_y == 0);
			
			if (left_right == 1'b1)
				dy <= -dy;
			if (top_bottom == 1'b1)
				dx <= -dx;
		end
	end
end
endmodule








