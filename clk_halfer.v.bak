module clk_halfer(
	input clk,
	output reg half_clk
	);

reg [1:0]S = CLK_HIGH, NS;

parameter CLK_HIGH = 2'd0, CLK_LOW = 2'd1;

always@(posedge clk)
begin
	S <= NS;
end

always@(*)
begin
	case(S)
		CLK_HIGH: NS = CLK_LOW;
		CLK_LOW:  NS = CLK_HIGH;
	endcase
end

always@(posedge clk)
begin
	case(S)
		CLK_HIGH: half_clk <= 1'b1;
		CLK_LOW: half_clk <= 1'b0;
	endcase
end

endmodule