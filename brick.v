module brick (
    input clk,
    input rst,
	 input wire [7:0] ball_x,
	 input wire [7:0] ball_y,
	 input wire [7:0] init_x,
	 input wire [7:0] init_y,
	 input created,
	 input [24:0] delay_done,
    output reg [7:0] x,
    output reg [7:0] y,
    output reg exist
);

// Speed of the brick movement
parameter speed = 1;

// State machine states for brick movement
reg [1:0] s;
reg [1:0] ns;
reg [24:0] delay;

reg destroyed;

parameter NOT_EXIST = 2'b00,
			EXIST = 2'b01,
			COLLIDE = 2'b10,
			MOVE = 2'b11;

always@(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		s <= NOT_EXIST;
	else
		s <= ns;
end

always@(*)
begin
	case(s)
		NOT_EXIST:
		begin
			if (created == 1'b0)
				ns = NOT_EXIST;
			else 
				ns = EXIST;
		end
		EXIST: ns = COLLIDE;
		COLLIDE: 
		begin
			if (exist == 1'b0)
				ns = MOVE;
			else
				ns = NOT_EXIST;
		end
		MOVE: ns = EXIST;
	endcase
end

always @(posedge clk or posedge rst)
begin
	if (rst == 1'b0)
		exist <= 0;
	else 
	begin
		case(s)
			NOT_EXIST:
			begin
				delay <= 0;
				x <= init_x;
				y <= init_y;
				exist <= 0;
			end
			EXIST: 
			begin
				delay <= delay + 1;
				exist <= ~((ball_x <= x + 57) && (ball_x + 20 >= x)) && ((ball_y <= y + 19) && (ball_y + 20 >= y));
			end
			MOVE:
			begin
				delay <= delay + 2;
				if (delay >= delay_done)
				begin
					y <= y + speed;
					delay <= 0;
				end
			end
		endcase
	end
end
endmodule

