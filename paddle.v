module paddle (
	input clk,
	input rst,
	input left,
	input right,
	input start,
	output reg [8:0] x
);

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0) 
		x <= 290;
	else if (start == 1'b1)
	begin
		// Paddle movement logic
		if (left == 1'b0 && x > 134)
			 x <= x - 1;
		else if (right == 1'b0 && x + 62 < 506)
			 x <= x + 1;
	end
end
endmodule 
