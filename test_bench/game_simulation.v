`timescale 1ns / 1ps

module game_top_tb();

    // Test Bench Signals
    reg clk;
    reg rst;
    reg up, down, left, right;
    wire [3:0] pix_r, pix_g, pix_b;
    wire hsync, vsync;

    // Instantiate the game_top module
    game_top uut (
        .clk(clk),
        .rst(rst),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Clock generation (50MHz for example)
    always #5 clk = ~clk; // 50MHz clock, period = 20ns

    // Random input generator task
    task randomize_inputs;
        begin
            up = $random % 2;
            down = $random % 2;
            left = $random % 2;
            right = $random % 2;
        end
    endtask

    // Test Bench Logic
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        up = 0;
        down = 0;
        left = 0;
        right = 0;

        // Reset the system
        #100;
        rst = 0;

        // Continuously generate random inputs
        forever begin
            #20; // Change the inputs every 20ns
            randomize_inputs();
        end
    end

    // Optional: Automatic stop of simulation after a specific time
    initial begin
        #500000000; // Stop simulation after 500 microseconds for example
        $finish;
    end

endmodule
