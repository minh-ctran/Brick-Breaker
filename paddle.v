module paddle (
	input clk,
	input rst,
	input left,
	input right,
	input start,
	input delay_done,
	output reg [8:0] x
);

reg delay;

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		x <= 290;
		delay <= 0;
	end
	else if (start == 1'b1)
	begin
		if (delay >= delay_done)
		begin
			delay <= 0;
			// Paddle movement logic
			if (left == 1'b0 && x > 134)
				 x <= x - 1;
			else if (right == 1'b0 && x + 62 < 506)
				 x <= x + 1;
		end
		else
			delay <= delay + 1;
	end
end
endmodule 
