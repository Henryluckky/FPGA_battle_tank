`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2023 09:38:38 PM
// Design Name: 
// Module Name: box_control
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


module box_control(
    input clk,
    input [10:0] blkpos_x,
    input [9:0] blkpos_y,
    input [10:0] blkpos_x_2,
    input [9:0] blkpos_y_2, 
    output reg [1:0] random_number // 2-bit direction output
);

reg [10:0] delta_x, delta_y;

always @(posedge clk) begin
    // Declare variables to store differences
      // Assume N is the bit-width of blkpos_x and blkpos_y
    // Calculate the differences
    delta_x = blkpos_x_2 >= blkpos_x ? blkpos_x_2 - blkpos_x : blkpos_x - blkpos_x_2;
    delta_y = blkpos_y_2 >= blkpos_y ? blkpos_y_2 - blkpos_y : blkpos_y - blkpos_y_2;

    // Compare deltas and decide direction
    if (delta_x > delta_y) begin
        // Movement based on X-coordinate
        if (blkpos_x_2 > blkpos_x) begin
            random_number <= 2'd2;  // Move left
        end else if (blkpos_x_2 < blkpos_x) begin
            random_number <= 2'd3;  // Move right
        end
    end else if (delta_y > delta_x) begin
        // Movement based on Y-coordinate
        if (blkpos_y_2 > blkpos_y) begin
            random_number <= 2'd0;  // Move down
        end else if (blkpos_y_2 < blkpos_y) begin
            random_number <= 2'd1;  // Move up
        end
    end else begin
        // If deltas are equal or positions are the same, maintain current direction
        random_number <= random_number;
    end
end



endmodule



