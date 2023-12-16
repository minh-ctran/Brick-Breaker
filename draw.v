module draw(
	input clk,
	input rst,
	input start,
	input [8:0] paddle_x,
	input [8:0] brick1_x,
	input [8:0] brick1_y,
	input [8:0] brick2_x,
	input [8:0] brick2_y,
	input [8:0] brick3_x,
	input [8:0] brick3_y,
	input [8:0] brick4_x,
	input [8:0] brick4_y,
	input [8:0] brick5_x,
	input [8:0] brick5_y,
	input [8:0] brick6_x,
	input [8:0] brick6_y,
	input [5:0] bricks_exist,
	input [8:0] ball_x,
	input [8:0] ball_y,
	input [9:0] pixel_x,
	input [9:0] pixel_y,/*
	input lose,
	input win,*/

	output reg [7:0]color_out
	);
	
	parameter black = 8'b00000000;
	parameter red   = 8'b11100000;
	parameter white  = 8'b11111111;
	
	reg [7:0] pixel_color = 8'b00000000;
	
	//resolution 640x480
	always@(posedge clk)
	begin
		if (start == 1'b0)
		begin
			pixel_color <= black;
		end
		else
		begin
			//due to vga we only know the next pixel to be drawn
			color_out <= pixel_color;
			
			//set initial screen to black
			/*if ((pixel_x >= 134 && pixel_x < 505))
			begin
				if (lose == 1'b1)
					pixel_color <= red;
				else if (win == 1'b1)
					pixel_color <= white;
			end*/
			
			//draw ball (square)
			if ((pixel_x < ball_x + 20 && pixel_x >= ball_x) && 
						(pixel_y < ball_y + 20 && pixel_y >= ball_y))
				pixel_color <= red;
			
			//draw paddle (rectangle)
			else if ((pixel_x < paddle_x + 74 && pixel_x >= paddle_x) && 
						(pixel_y <= 477 && pixel_y >= 458))
				pixel_color <= white;
			
			//draw brick1 (rectangle)
			else if (/*(bricks_exist[0] == 1) && */(pixel_x < brick1_x + 57 && pixel_x >= brick1_x) && 
						(pixel_y < brick1_y + 19 && pixel_y >= brick1_y))
				pixel_color <= white;
			
			//draw brick2 (rectangle)
			else if (/*(bricks_exist[1] == 1) && */(pixel_x < brick2_x + 57 && pixel_x >= brick2_x) && 
						(pixel_y < brick2_y + 19 && pixel_y >= brick2_y))
				pixel_color <= white;
			
			//draw brick3 (rectangle)
			else if ((bricks_exist[2] == 1) && (pixel_x < brick1_x + 57 && pixel_x >= brick3_x) && 
						(pixel_y < brick3_y + 19 && pixel_y >= brick3_y))
				pixel_color <= white;
			
			//draw brick4 (rectangle)
			else if ((bricks_exist[3] == 1) && (pixel_x < brick4_x + 57 && pixel_x >= brick4_x) && 
						(pixel_y < brick4_y + 19 && pixel_y >= brick4_y))
				pixel_color <= white;
				
			//draw brick5 (rectangle)
			else if ((bricks_exist[4] == 1) && (pixel_x < brick5_x + 57 && pixel_x >= brick5_x) && 
						(pixel_y < brick5_y + 19 && pixel_y >= brick5_y))
				pixel_color <= white;
			
			//draw brick6 (rectangle)
			else if ((bricks_exist[5] == 1) && (pixel_x < brick6_x + 57 && pixel_x >= brick6_x) && 
						(pixel_y < brick6_y + 19 && pixel_y >= brick6_y))
				pixel_color <= white;
			
			else if ((pixel_x < 134 && pixel_x >= 127) || (pixel_x >= 505 && pixel_x < 511))
				pixel_color <= white;
			
			else
				pixel_color <= black;
		end
	end
	
endmodule 