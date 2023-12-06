`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2023 10:28:52 AM
// Design Name: 
// Module Name: control_box
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


module control_box(
    input wire clk,
    input wire [10:0] blkpos_x_target,  // Target block's X position
    input wire [9:0] blkpos_y_target,  // Target block's Y position
    input wire [10:0] blkpos_x,         // Reference block's X position
    input wire [9:0] blkpos_y,         // Reference block's Y position
    output reg [1:0] direction           // Output direction
);
    // Assume N is the bit-width of blkpos_x and blkpos_y

    reg [10:0] delta_x;
    reg [9:0] delta_y;

    always @(posedge clk) begin
        // Calculate deltas
        delta_x = blkpos_x_target >= blkpos_x ? blkpos_x_target - blkpos_x : blkpos_x - blkpos_x_target;
        delta_y = blkpos_y_target >= blkpos_y ? blkpos_y_target - blkpos_y : blkpos_y - blkpos_y_target;

        // Compare deltas and decide direction
        if (delta_x > delta_y) begin
            if (blkpos_x_target > blkpos_x) begin
                direction <= 2'd2;  // Move left
            end else if (blkpos_x_target < blkpos_x) begin
                direction <= 2'd3;  // Move right
            end
        end else if (delta_y > delta_x) begin
            if (blkpos_y_target > blkpos_y) begin
                direction <= 2'd1;  // Move down
            end else if (blkpos_y_target < blkpos_y) begin
                direction <= 2'd0;  // Move up
            end
        end else begin
            direction <= direction;  // Maintain current direction
        end
    end
endmodule

