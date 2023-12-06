`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2023 11:36:19 AM
// Design Name: 
// Module Name: vga_out_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_vga_out;

    // Clock signal for simulation
    reg clk;
    
    // Switch inputs for color selection
    reg [2:0] sw_r = 3'b101; // Sample value
    reg [2:0] sw_g = 3'b011; // Sample value
    reg [2:0] sw_b = 3'b001; // Sample value

    // Outputs to observe in the simulation
    wire [3:0] pix_r;
    wire [3:0] pix_g;
    wire [3:0] pix_b;
    wire hsync;
    wire vsync;

    // Instantiate the design under test (DUT)
    vga_out uut (
        .clk(clk),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .hsync(hsync),
        .vsync(vsync)
    );

    // Clock generation for simulation
    always begin
        #5 clk = ~clk;  // Assuming a 10ns period (100MHz) clock for this simulation
    end

    initial begin
        // Initial conditions
        clk = 0;
        
        // Run simulation for a certain duration
        #500000; // Run for 50,000 ns or 50 us, adjust as needed
       
        // Finish simulation
        $finish;
    end

endmodule
