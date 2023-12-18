`timescale 1ns / 1ps

module tb;

    // Inputs
    reg clk;
    reg rst;
    reg right;
    reg left;
    reg start;

    // Outputs
    wire vga_clk;
    wire vga_sync;
    wire vga_blank;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    wire vga_hsync;
    wire vga_vsync;
    wire game_over;
    wire victory;
    wire [5:0] bricks_exist;
	 
	 parameter simdelay = 20;
	 parameter clock_delay = 5;

    // Instantiate the design
    brick_breaker dut (
        .clk(clk),
        .rst(rst),
        .right(right),
        .left(left),
        .start(start),
        .vga_clk(vga_clk),
        .vga_sync(vga_sync),
        .vga_blank(vga_blank),
        .red(red),
        .green(green),
        .blue(blue),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync),
        .game_over(game_over),
        .victory(victory),
        .bricks_exist(bricks_exist)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initialize inputs
    initial begin
        rst = 1;
        right = 0;
        left = 0;
        start = 0;

        #50 rst = 0;  // De-assert reset after 50 time units
        #100 start = 1; // Start the game after 100 time units
    end

    // Stimulus
    initial begin
        // Add your test scenarios here
        // You can toggle inputs, wait for specific events, etc.
        // For example:
        #200 left = 1; // Press left
        #300 left = 0; // Release left
        #400 right = 1; // Press right
        #500 right = 0; // Release right
        // ...
        // Continue with your test cases
        // ...

        // Finish simulation
        #1000 $finish;
    end

endmodule
