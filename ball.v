module ball (
    input clk,
    input rst,
	 input start,
	 input destroyed,
	 input [24:0] delay_done,
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
	 input wire [5:0] brick_exist,
    output reg [8:0] x,
    output reg [8:0] y
);

reg [2:0] s;
reg [2:0] ns;
reg [24:0] delay;

reg brick1;
reg brick2;
reg brick3;
reg brick4;
reg brick5;
reg brick6;

reg top_bottom;
reg left_right;
reg paddle;
// reg corner;

reg dx;
reg dy;

parameter START = 0,
			MOVE = 1,
			COLLIDE = 2,
			BOUNCE = 3,
			DESTROYED = 4,
			ERROR = 5;

always@(posedge clk or posedge rst)
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
			if (start == 1'b1)
				ns = MOVE;
			else 
				ns = START;
		end
		MOVE:
		begin
			if (destroyed == 1'b1)
				ns = DESTROYED;
			else
				ns = COLLIDE;
		end
		COLLIDE: ns = BOUNCE;
		BOUNCE: ns = MOVE;
		DESTROYED: ns = DESTROYED;
		default: ns = ERROR;
	endcase
end

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		x <= 176;
		y <= 459;
	end
	else
	begin
		case(s)
			START:
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
				dx <= 1;
				dy <= 1;
				delay <= 0;
			end
			MOVE:
			begin
				if (delay >= delay_done)
				begin
					x <= x + dx;
					y <= y + dy;
					delay <= 0;
				end
				else
					delay <= delay + 1;
			end
			COLLIDE:
			begin
				paddle <= (x <= paddle_x + 62) && (x + 20 >= paddle_x) && (y + 20 == 458);
				
				brick1 <= ((x <= brick1_x + 57) && (x + 20 >= brick1_x)) && ((y <= brick1_y + 19) && (y + 20 >= brick1_y) && brick_exist[0]);
				brick2 <= ((x <= brick2_x + 57) && (x + 20 >= brick2_x)) && ((y <= brick2_y + 19) && (y + 20 >= brick2_y) && brick_exist[1]);
				brick3 <= ((x <= brick3_x + 57) && (x + 20 >= brick3_x)) && ((y <= brick3_y + 19) && (y + 20 >= brick3_y) && brick_exist[2]);
				brick4 <= ((x <= brick4_x + 57) && (x + 20 >= brick4_x)) && ((y <= brick4_y + 19) && (y + 20 >= brick4_y) && brick_exist[3]);
				brick5 <= ((x <= brick5_x + 57) && (x + 20 >= brick5_x)) && ((y <= brick5_y + 19) && (y + 20 >= brick5_y) && brick_exist[4]);
				brick6 <= ((x <= brick6_x + 57) && (x + 20 >= brick6_x)) && ((y <= brick6_y + 19) && (y + 20 >= brick6_y) && brick_exist[5]);
				
				left_right <= (brick1 && (y < brick1_y + 19) && (y + 20 > brick1_y)) ||
							(brick2 && (y < brick2_y + 19) && (y + 20 > brick2_y)) ||
							(brick3 && (y < brick3_y + 19) && (y + 20 > brick3_y)) || 
							(brick4 && (y < brick4_y + 19) && (y + 20 > brick4_y)) ||
							(brick5 && (y < brick5_y + 19) && (y + 20 > brick5_y)) ||
							(brick6 && (y < brick6_y + 19) && (y + 20 > brick6_y)) ||
							(x + 1 == 505) || (x - 1 == 133);

				top_bottom <= (brick1 && (x < brick1_x + 57) && (x + 20 > brick1_x)) ||
							(brick2 && (x < brick2_x + 57) && (x + 20 > brick2_x)) ||
							(brick3 && (x < brick3_x + 57) && (x + 20 > brick3_x)) ||
							(brick4 && (x < brick4_x + 57) && (x + 20 > brick4_x)) ||
							(brick5 && (x < brick5_x + 57) && (x + 20 > brick5_x)) ||
							(brick6 && (x < brick6_x + 57) && (x + 20 > brick6_x)) ||
							(y == 0);
				
				/*corner <= ((y == brick1_y + 19) && (y + 20 == brick1_y) && (x == brick1_x + 57) && (x + 20 == brick1_x)) ||
							((y == brick2_y + 19) && (y + 20 == brick2_y) && (x == brick2_x + 57) && (x + 20 == brick2_x)) ||
							((y == brick3_y + 19) && (y + 20 == brick3_y) && (x == brick3_x + 57) && (x + 20 == brick3_x)) ||
							((y == brick4_y + 19) && (y + 20 == brick4_y) && (x == brick4_x + 57) && (x + 20 == brick4_x)) ||
							((y == brick5_y + 19) && (y + 20 == brick5_y) && (x == brick5_x + 57) && (x + 20 == brick5_x)) ||
							((y == brick6_y + 19) && (y + 20 == brick6_y) && (x == brick6_x + 57) && (x + 20 == brick6_x)); */
			end
			BOUNCE:
			begin
				if (paddle == 1'b1)
				begin
					if (x + 20 >= paddle_x && x <= paddle_x + 9)
						dx <= -dx;
					else if (x + 19 >= paddle_x + 10 && x <= paddle_x + 30 && dx > 1)
						dx <= -(dx - 1);
					else if (x + 19 >= paddle_x + 31 && x <= paddle_x + 62 && dx <= 5)
						dx <= -(dx + 1);
				end
				
				if (left_right == 1'b1)
					dy <= -dy;
				else if (top_bottom == 1'b1)
					dx <= -dx;
			end
		endcase
	end
end

endmodule





