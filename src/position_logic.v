`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 06:50:26 PM
// Design Name: 
// Module Name: position_logic
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


module position_logic(
//    input clk,   // Block position inputs
    input clk,
    input rst,       // Current pixel position inputs
    input up,down,left,right,
    input boom_state,
    input boom_state_2,
    input boom_state_3,
    input boom_state_4,
    input boom_state_5,
    output reg [10:0] blkpos_x,
    output reg [9:0] blkpos_y,
    output reg [10:0] blkpos_x_2,
    output reg [9:0] blkpos_y_2,
    output reg [10:0] blkpos_x_3,
    output reg [9:0] blkpos_y_3,
    output reg [10:0] blkpos_x_4,//new target
    output reg [9:0] blkpos_y_4,
    output reg [10:0] blkpos_x_5,
    output reg [9:0] blkpos_y_5,
    output reg [10:0] blkpos_x_6,
    output reg [9:0] blkpos_y_6                                 // RGB output values
);
// Assuming these are the limits for the screen or safe area
parameter SCREEN_WIDTH = 11'd1280;
parameter SCREEN_HEIGHT = 10'd720;
parameter box_WIDTH = 6'd61;
parameter box_HEIGHT = 6'd49;
parameter FORBID1_X1 = 9'd151;
parameter FORBID1_X2 = 11'd707;
parameter FORBID1_Y1 = 11'd476;
parameter FORBID1_Y2 = 11'd556;
parameter FORBID2_X1 = 9'd156;
parameter FORBID2_X2 = 11'd717;
parameter FORBID2_Y1 = 9'd95;
parameter FORBID2_Y2 = 8'd179;
parameter FORBID3_X1 = 11'd231;
parameter FORBID3_X2 = 11'd397;
parameter FORBID3_Y1 = 11'd299;
parameter FORBID3_Y2 = 11'd379;
parameter FORBID4_X1 = 11'd473;
parameter FORBID4_X2 = 11'd645;
parameter FORBID4_Y1 = 11'd299;
parameter FORBID4_Y2 = 11'd379;
parameter FORBID5_X1 = 11'd846;
parameter FORBID5_X2 = 11'd1010;
parameter FORBID5_Y1 = 11'd522;
parameter FORBID5_Y2 = 11'd654;
parameter FORBID6_X1 = 11'd874;
parameter FORBID6_X2 = 12'd1046;
parameter FORBID6_Y1 = 11'd166;
parameter FORBID6_Y2 = 11'd475;

parameter STEP_SIZE = 3'd4; // Step size for block movement 


function is_in_forbidden_area;
        input integer pos_x, pos_y;
        begin
            is_in_forbidden_area = ((pos_x > FORBID1_X1) && (pos_x < FORBID1_X2 + 4) && (pos_y > FORBID1_Y1 - 26) && (pos_y < FORBID1_Y2-16)) ||
                                   ((pos_x > FORBID2_X1) && (pos_x < FORBID2_X2 + 4) && (pos_y > FORBID2_Y1 - 8) && (pos_y < FORBID2_Y2-6)) ||
                                   ((pos_x > FORBID3_X1) && (pos_x < FORBID3_X2 + 4) && (pos_y > FORBID3_Y1 - 14) && (pos_y < FORBID3_Y2-6)) ||
                                   ((pos_x > FORBID4_X1) && (pos_x < FORBID4_X2 + 4) && (pos_y > FORBID4_Y1 - 14) && (pos_y < FORBID4_Y2-6)) ||
                                   ((pos_x > FORBID5_X1 - 8) && (pos_x < FORBID5_X2 - 8) && (pos_y > FORBID5_Y1 -32 ) && (pos_y < FORBID5_Y2-32 ))||
                                   ((pos_x > FORBID6_X1) && (pos_x < FORBID6_X2 + 4) && (pos_y > FORBID6_Y1 - 26) && (pos_y < FORBID6_Y2-32));
        end
endfunction

wire [1:0] direction;
wire [1:0] direction_2;
wire [1:0] direction_3;
wire [1:0] direction_4;
wire [1:0] direction_5;


control_box box_2 (
    .clk(clk),
    .blkpos_x_target(blkpos_x_2),
    .blkpos_y_target(blkpos_y_2),
    .blkpos_x(blkpos_x),
    .blkpos_y(blkpos_y),
    .direction(direction)
);

control_box box_3 (
    .clk(clk),
    .blkpos_x_target(blkpos_x_3),
    .blkpos_y_target(blkpos_y_3),
    .blkpos_x(blkpos_x),
    .blkpos_y(blkpos_y),
    .direction(direction_2)
);

control_box box_4 (
    .clk(clk),
    .blkpos_x_target(blkpos_x_4),
    .blkpos_y_target(blkpos_y_4),
    .blkpos_x(blkpos_x),
    .blkpos_y(blkpos_y),
    .direction(direction_5)
);

control_box box_5 (
    .clk(clk),
    .blkpos_x_target(blkpos_x_5),
    .blkpos_y_target(blkpos_y_5),
    .blkpos_x(blkpos_x),
    .blkpos_y(blkpos_y),
    .direction(direction_3)
);

control_box box_6 (
    .clk(clk),
    .blkpos_x_target(blkpos_x_6),
    .blkpos_y_target(blkpos_y_6),
    .blkpos_x(blkpos_x),
    .blkpos_y(blkpos_y),
    .direction(direction_4)
);




//always @(posedge clk) begin
//    // Declare variables to store differences
//    delta_x = blkpos_x_2 >= blkpos_x ? blkpos_x_2 - blkpos_x : blkpos_x - blkpos_x_2;
//    delta_y = blkpos_y_2 >= blkpos_y ? blkpos_y_2 - blkpos_y : blkpos_y - blkpos_y_2;
//    // Compare deltas and decide direction
//    if (delta_x > delta_y) begin
//        // Movement based on X-coordinate
//        if (blkpos_x_2 > blkpos_x) begin
//            direction <= 2'd2;  // Move left
//        end else if (blkpos_x_2 < blkpos_x) begin
//            direction <= 2'd3;  // Move right
//        end
//    end else if (delta_y > delta_x) begin
//        // Movement based on Y-coordinate
//        if (blkpos_y_2 > blkpos_y) begin
//            direction <= 2'd1;  // Move down
//        end else if (blkpos_y_2 < blkpos_y) begin
//            direction <= 2'd0;  // Move up
//        end
//    end else begin
//        // If deltas are equal or positions are the same, maintain current direction
//        direction <= direction;
//    end
//end

//always @(posedge clk) begin
//    // Declare variables to store differences
//    delta_x = blkpos_x_3 >= blkpos_x ? blkpos_x_3 - blkpos_x : blkpos_x - blkpos_x_3;
//    delta_y = blkpos_y_3 >= blkpos_y ? blkpos_y_3 - blkpos_y : blkpos_y - blkpos_y_3;
//    // Compare deltas and decide direction
//    if (delta_x > delta_y) begin
//        // Movement based on X-coordinate
//        if (blkpos_x_3 > blkpos_x) begin
//            direction_2 <= 2'd2;  // Move left
//        end else if (blkpos_x_3 < blkpos_x) begin
//            direction_2 <= 2'd3;  // Move right
//        end
//    end else if (delta_y > delta_x) begin
//        // Movement based on Y-coordinate
//        if (blkpos_y_3 > blkpos_y) begin
//            direction_2 <= 2'd1;  // Move down
//        end else if (blkpos_y_3 < blkpos_y) begin
//            direction_2 <= 2'd0;  // Move up
//        end
//    end else begin
//        // If deltas are equal or positions are the same, maintain current direction
//        direction_2 <= direction_2;
//    end
//end
 
 
//always @(posedge clk) begin
//    // Declare variables to store differences
//    delta_x = blkpos_x_5 >= blkpos_x ? blkpos_x_5 - blkpos_x : blkpos_x - blkpos_x_5;
//    delta_y = blkpos_y_5 >= blkpos_y ? blkpos_y_5 - blkpos_y : blkpos_y - blkpos_y_5;
//    // Compare deltas and decide direction
//    if (delta_x > delta_y) begin
//        // Movement based on X-coordinate
//        if (blkpos_x_5 > blkpos_x) begin
//            direction_3 <= 2'd2;  // Move left
//        end else if (blkpos_x_5 < blkpos_x) begin
//            direction_3 <= 2'd3;  // Move right
//        end
//    end else if (delta_y > delta_x) begin
//        // Movement based on Y-coordinate
//        if (blkpos_y_5 > blkpos_y) begin
//            direction_3 <= 2'd1;  // Move down
//        end else if (blkpos_y_5 < blkpos_y) begin
//            direction_3 <= 2'd0;  // Move up
//        end
//    end else begin
//        // If deltas are equal or positions are the same, maintain current direction
//        direction_3 <= direction_3;
//    end
//end         


//always @(posedge clk) begin
//    // Declare variables to store differences
//    delta_x = blkpos_x_6 >= blkpos_x ? blkpos_x_6 - blkpos_x : blkpos_x - blkpos_x_6;
//    delta_y = blkpos_y_6 >= blkpos_y ? blkpos_y_6 - blkpos_y : blkpos_y - blkpos_y_6;
//    // Compare deltas and decide direction
//    if (delta_x > delta_y) begin
//        // Movement based on X-coordinate
//        if (blkpos_x_6 > blkpos_x) begin
//            direction_4 <= 2'd2;  // Move left
//        end else if (blkpos_x_6 < blkpos_x) begin
//            direction_4 <= 2'd3;  // Move right
//        end
//    end else if (delta_y > delta_x) begin
//        // Movement based on Y-coordinate
//        if (blkpos_y_6 > blkpos_y) begin
//            direction_4 <= 2'd1;  // Move down
//        end else if (blkpos_y_6 < blkpos_y) begin
//            direction_4 <= 2'd0;  // Move up
//        end
//    end else begin
//        // If deltas are equal or positions are the same, maintain current direction
//        direction_4 <= direction_4;
//    end
//end 

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x <= SCREEN_WIDTH / 2 + 64;
        blkpos_y <= SCREEN_HEIGHT / 2;
    end else begin
        // Move up if within bounds
        if (up && (blkpos_y < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x, blkpos_y + STEP_SIZE) )
            blkpos_y <= blkpos_y + STEP_SIZE;
        // Move down if within bounds
        else if (down && (blkpos_y > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x, blkpos_y - STEP_SIZE) )
            blkpos_y <= blkpos_y - STEP_SIZE;
        // Move left if within bounds
        if (left && (blkpos_x > box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x - STEP_SIZE, blkpos_y))
            blkpos_x <= blkpos_x - STEP_SIZE;
        // Move right if within bounds
        else if (right && (blkpos_x < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x + STEP_SIZE, blkpos_y))
            blkpos_x <= blkpos_x + STEP_SIZE;
    end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x_2 <= SCREEN_WIDTH / 2 + 64 + 32 + 32;
        blkpos_y_2 <= SCREEN_HEIGHT / 2 + 32 - 150;
    end else begin
        // Move up if within bounds
        if (boom_state == 1'b0) begin
        if (direction == 2'd0 && (blkpos_y_2 < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x_2, blkpos_y_2 + STEP_SIZE) )
            blkpos_y_2 <= blkpos_y_2 + STEP_SIZE/4;
        // Move down if within bounds
        else if (direction == 2'd1 && (blkpos_y_2 > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_2, blkpos_y_2 - STEP_SIZE) )
            blkpos_y_2 <= blkpos_y_2 - STEP_SIZE/4;
        // Move left if within bounds
        if (direction == 2'd2 && (blkpos_x_2 > box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_2 - STEP_SIZE, blkpos_y_2))
            blkpos_x_2 <= blkpos_x_2 - STEP_SIZE/4;
        // Move right if within bounds
        else if (direction == 2'd3 && (blkpos_x_2 < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x_2 + STEP_SIZE, blkpos_y_2))
            blkpos_x_2 <= blkpos_x_2 + STEP_SIZE/4; 
        end else begin
            blkpos_x_2 <= blkpos_x_2;
            blkpos_y_2 <= blkpos_y_2;
            end 
    end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x_3 <= SCREEN_WIDTH  - 150;
        blkpos_y_3 <= SCREEN_HEIGHT  - 300;
    end else begin
        // Move up if within bounds
        if ( boom_state_2 == 1'b0 && boom_state == 1'b1) begin
        if (direction_2 == 2'd0 && (blkpos_y_3 < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x_3, blkpos_y_3 + STEP_SIZE) )
            blkpos_y_3 <= blkpos_y_3 + STEP_SIZE/4;
        // Move down if within bounds
        else if (direction_2 == 2'd1 && (blkpos_y_3 > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_3, blkpos_y_3 - STEP_SIZE) )
            blkpos_y_3 <= blkpos_y_3 - STEP_SIZE/4;
        // Move left if within bounds
        if (direction_2 == 2'd2 && (blkpos_x_3 > box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_3 - STEP_SIZE, blkpos_y_3))
            blkpos_x_3 <= blkpos_x_3 - STEP_SIZE/4;
        // Move right if within bounds
        else if (direction_2 == 2'd3 && (blkpos_x_3 < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x_3 + STEP_SIZE, blkpos_y_3))
            blkpos_x_3 <= blkpos_x_3 + STEP_SIZE/4; 
        end else begin
            blkpos_x_3 <= blkpos_x_3;
            blkpos_y_3 <= blkpos_y_3;
        end 
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x_4 <= SCREEN_WIDTH / 2 + 64 + 32;
        blkpos_y_4 <= SCREEN_HEIGHT / 2 + 32 + 450;
    end else begin
        if ( boom_state_3 == 1'b0 && boom_state == 1'b1) begin
        if (direction_5 == 2'd0 && (blkpos_y_4 < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x_4, blkpos_y_4 + STEP_SIZE) )
            blkpos_y_4 <= blkpos_y_4 + STEP_SIZE/4;
        // Move down if within bounds
        else if (direction_5 == 2'd1 && (blkpos_y_4 > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_4, blkpos_y_4 - STEP_SIZE) )
            blkpos_y_4 <= blkpos_y_4 - STEP_SIZE/4;
        // Move left if within bounds
        if (direction_5 == 2'd2 && (blkpos_x_4> box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_4 - STEP_SIZE, blkpos_y_4))
            blkpos_x_4 <= blkpos_x_4 - STEP_SIZE/4;
        // Move right if within bounds
        else if (direction_5 == 2'd3 && (blkpos_x_4 < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x_4 + STEP_SIZE, blkpos_y_4))
            blkpos_x_4 <= blkpos_x_4 + STEP_SIZE/4; 
        end else begin 
        blkpos_x_4 <= blkpos_x_4;
        blkpos_y_4 <= blkpos_y_4;
        end
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x_5 <= SCREEN_WIDTH / 2 + 64 - 150;
        blkpos_y_5 <= SCREEN_HEIGHT / 2 + 32 - 150;
    end else begin
        if ( boom_state_4 == 1'b0 && boom_state == 1'b1) begin  
        if (direction_3 == 2'd0 && (blkpos_y_5 < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x_5, blkpos_y_5 + STEP_SIZE) )
            blkpos_y_5 <= blkpos_y_5 + STEP_SIZE/4;
        // Move down if within bounds
        else if (direction_3 == 2'd1 && (blkpos_y_5 > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_5, blkpos_y_5 - STEP_SIZE) )
            blkpos_y_5 <= blkpos_y_5 - STEP_SIZE/4;
        // Move left if within bounds
        if (direction_3 == 2'd2 && (blkpos_x_5> box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_5 - STEP_SIZE, blkpos_y_5))
            blkpos_x_5 <= blkpos_x_5 - STEP_SIZE/4;
        // Move right if within bounds
        else if (direction_3 == 2'd3 && (blkpos_x_5 < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x_5 + STEP_SIZE, blkpos_y_5))
            blkpos_x_5 <= blkpos_x_5 + STEP_SIZE/4; 
        end else begin 
        blkpos_x_5 <= blkpos_x_5;
        blkpos_y_5 <= blkpos_y_5;
        end
    end
end


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset block position to the center of the screen
        blkpos_x_6 <= SCREEN_WIDTH / 2 + 64  - 200;
        blkpos_y_6 <= SCREEN_HEIGHT / 2 + 32 - 450;
    end else begin
        if ( boom_state_5 == 1'b0 && boom_state == 1'b1) begin
        if (direction_4 == 2'd0 && (blkpos_y_6 < SCREEN_HEIGHT - box_HEIGHT - STEP_SIZE + 16) && !is_in_forbidden_area(blkpos_x_6, blkpos_y_6 + STEP_SIZE) )
            blkpos_y_6 <= blkpos_y_6 + STEP_SIZE/4;
        // Move down if within bounds
        else if (direction_4 == 2'd1 && (blkpos_y_6 > box_HEIGHT + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_6, blkpos_y_6 - STEP_SIZE) )
            blkpos_y_6 <= blkpos_y_6 - STEP_SIZE/4;
        // Move left if within bounds
        if (direction_4 == 2'd2 && (blkpos_x_6> box_WIDTH + STEP_SIZE) && !is_in_forbidden_area(blkpos_x_6 - STEP_SIZE, blkpos_y_6))
            blkpos_x_6 <= blkpos_x_6 - STEP_SIZE/4;
        // Move right if within bounds
        else if (direction_4 == 2'd3 && (blkpos_x_6 < SCREEN_WIDTH - box_WIDTH - 32) && !is_in_forbidden_area(blkpos_x_6 + STEP_SIZE, blkpos_y_6))
            blkpos_x_6 <= blkpos_x_6 + STEP_SIZE/4; 
        end else begin 
        blkpos_x_6 <= blkpos_x_6;
        blkpos_y_6 <= blkpos_y_6;
        end
    end
end


endmodule
