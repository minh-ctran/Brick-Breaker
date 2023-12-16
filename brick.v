module brick (
    input clk,
    input rst,
	 input wire [7:0] ball_x,
	 input wire [7:0] ball_y,
	 input wire [7:0] init_x,
	 input wire [7:0] init_y,
	 input [24:0] delay_done,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg exist,
	 output reg game_over
);

// Speed of the brick movement
parameter speed = 1;

// State machine states for brick movement
reg [1:0] s;
reg [1:0] ns;
reg [24:0] delay;

parameter NOT_EXIST = 0,
			EXIST = 1,
			COLLIDE = 2,
			MOVE = 3;

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		s <= EXIST;
	else
		s <= ns;
end

always@(*)
begin
	case(s)
		NOT_EXIST: ns = NOT_EXIST;
		EXIST: ns = COLLIDE;
		COLLIDE: 
		begin
			if (exist == 1'b1 && game_over == 1'b0)
				ns = MOVE;
			else
				ns = NOT_EXIST;
		end
		MOVE: ns = EXIST;
	endcase
end

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		exist <= 1;
		x <= init_x;
		y <= init_y;
		game_over <= 0;
		delay <= 0;
	end
	else 
	begin
		case(s)
			NOT_EXIST:
			begin
				delay <= 0;
				exist <= 0;
			end
			EXIST: 
			begin
				delay <= delay + 1;
				exist <= ~((ball_x <= x + 57) && (ball_x + 20 >= x)) && ((ball_y <= y + 19) && (ball_y + 20 >= y));
				game_over <= (y >= 458);
			end
			MOVE:
			begin
				if (delay >= delay_done)
				begin
					y <= y + speed;
					delay <= 0;
				end
				else
					delay <= delay + 2; 
			end
		endcase
	end
end
endmodule

