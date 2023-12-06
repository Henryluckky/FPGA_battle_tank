`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 06:52:36 PM
// Design Name: 
// Module Name: drawcon
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

module drawcon(
    input clk,
    input rst,
    input [3:0] sw,
    input fire,
    input [10:0] blkpos_x,
    input [9:0] blkpos_y,   // Block position inputs
    input [10:0] blkpos_x_2,
    input [9:0] blkpos_y_2,   // Block position inputs
    input [10:0] blkpos_x_3,
    input [9:0] blkpos_y_3,   // Block position inputs
    input [10:0] blkpos_x_4,
    input [9:0] blkpos_y_4,   // Block position inputs
    input [10:0] blkpos_x_5,
    input [9:0] blkpos_y_5,   // Block position inputs
    input [10:0] blkpos_x_6,
    input [9:0] blkpos_y_6,   // Block position inputs
    input [10:0] curr_x,       // Current pixel position inputs
    input [9:0]  curr_y,
    output boom_state, boom_state_2, boom_state_3, boom_state_4, boom_state_5,
    output [3:0] draw_r, draw_g, draw_b              // RGB output values
);

localparam X_SCALE = 512 * 1024 / 1280; // Scale factor for X, in fixed-point format
localparam Y_SCALE = 200 * 1024 / 800;  // Scale factor for Y, in fixed-point format
    parameter  tank_UP  = 2'b00;
    parameter  tank_DOWN = 2'b01;
    parameter  tank_LEFT = 2'b10;
    parameter  tank_RIGHT = 2'b11;
    parameter  tank_FIRE = 3'b100;
    parameter WHITE_COLOR = 12'b1111_1111_1111;
    parameter RED_COLOR = 12'b1111_0000_0000;

    // Internal signals for background and block colors
    reg [1:0] display_state;
    reg [1:0] target_display_state;
    reg [1:0] target_display_state_2;
    reg [1:0] target_display_state_3;
    reg [1:0] target_display_state_4;
    reg [1:0] target_display_state_5;
    reg display_explosion_state = 1'b0;
    reg display_explosion_state_2 = 1'b0;
    reg display_explosion_state_3 = 1'b0;
    reg display_explosion_state_4 = 1'b0;
    reg display_explosion_state_5 = 1'b0;
    reg fire_state;
    reg tank_boom_state = 1'b0;
    wire [11:0] color_from_mem;
    wire [11:0] bg_color_from_mem;
    wire [11:0] loss_color_from_mem;
    wire [11:0] right_color_from_mem;
    wire [11:0] up_color_from_mem;
    wire [11:0] left_color_from_mem;
    wire [11:0] down_color_from_mem;
    wire [11:0] blk2_color_from_mem;
    wire [11:0] blk2_color_from_mem_2;
    wire [11:0] blk2_color_from_mem_3;
    wire [11:0] blk2_color_from_mem_4;
    wire [11:0] blk2_color_from_mem_5;
    wire [11:0] blk2_color_from_mem_6;
    wire [11:0] explosion_color_from_mem;
    wire [11:0] explosion_color_from_mem_2;
    wire [11:0] explosion_color_from_mem_3;
    wire [11:0] explosion_color_from_mem_4;
    wire [11:0] explosion_color_from_mem_5;
    wire [11:0] explosion_color_from_mem_6;
    wire [17:0] mem_address;
    reg [17:0] address_reg;
    reg [9:0] scaled_x;
    reg [8:0] scaled_y;
    reg [9:0] tankup_addr = 10'd0;
    reg [9:0] tankright_addr = 10'd0;
    reg [9:0] tankleft_addr = 10'd0;
    reg [9:0] tankdown_addr = 10'd0;
    reg [9:0] target_address = 10'd0;
    reg [9:0] target_address_2 = 10'd0;
    reg [9:0] target_address_3 = 10'd0;
    reg [9:0] target_address_4 = 10'd0;
    reg [9:0] target_address_5 = 10'd0;
    reg [9:0] target_address_6 = 10'd0;
    reg [9:0] explosion_address= 10'd0;
    reg [1:0] greentank_orient;
    reg [10:0] laser_start_x, laser_start_y;
    reg [11:0] laser_color;
    reg flag = 1'b1;
    reg reset_state = 1'b1;
 
    
   tank_background your_instance_name (
   .clka(clk),    // input wire clka
  .addra(mem_address),  // 
  .douta(bg_color_from_mem)  // 
);

   loss loss (
  .clka(clk),    // input wire clka
  .addra(mem_address),  // input wire [17 : 0] addra
  .douta(loss_color_from_mem)  // output wire [11 : 0] douta
);

  right_tank right_tank(
  .clka(clk),    // input wire clka
  .addra(tankright_addr),  // input wire [9 : 0] addra
  .douta(right_color_from_mem)  // output wire [11 : 0] douta
);

   down_tank up_tank (
  .clka(clk),    // input wire clka
  .addra(tankup_addr),  // input wire [9 : 0] addra
  .douta(up_color_from_mem)  // output wire [11 : 0] douta
);

  left_tank left_tank (
  .clka(clk),    // input wire clka
  .addra(tankleft_addr),  // input wire [9 : 0] addra
  .douta(left_color_from_mem)  // output wire [11 : 0] douta
);

  blk_mem_gen_0 down_tank (
  .clka(clk),    // input wire clka
  .addra(tankdown_addr),  // input wire [9 : 0] addra
  .douta(down_color_from_mem)  // output wire [11 : 0] douta
);

  target target (
  .clka(clk),    // input wire clka
  .addra(target_address),  // input wire [9 : 0] addra
  .douta(blk2_color_from_mem)  // output wire [11 : 0] douta
);

  explosion explosion (
  .clka(clk),    // input wire clka
  .addra(target_address),  // input wire [9 : 0] addra
  .douta(explosion_color_from_mem)  // output wire [11 : 0] douta
);


  target target2 (
  .clka(clk),    // input wire clka
  .addra(target_address_2),  // input wire [9 : 0] addra
  .douta(blk2_color_from_mem_2)  // output wire [11 : 0] douta
);

  explosion explosion2 (
  .clka(clk),    // input wire clka
  .addra(target_address_2),  // input wire [9 : 0] addra
  .douta(explosion_color_from_mem_2)  // output wire [11 : 0] douta
);

  target target3 (
  .clka(clk),    // input wire clka
  .addra(target_address_3),  // input wire [9 : 0] addra
  .douta(blk2_color_from_mem_3)  // output wire [11 : 0] douta
);

  explosion explosion3 (
  .clka(clk),    // input wire clka
  .addra(target_address_3),  // input wire [9 : 0] addra
  .douta(explosion_color_from_mem_3)  // output wire [11 : 0] douta
);

  target target4 (
  .clka(clk),    // input wire clka
  .addra(target_address_4),  // input wire [9 : 0] addra
  .douta(blk2_color_from_mem_4)  // output wire [11 : 0] douta
);

  explosion explosion4 (
  .clka(clk),    // input wire clka
  .addra(target_address_4),  // input wire [9 : 0] addra
  .douta(explosion_color_from_mem_4)  // output wire [11 : 0] douta
);

  target target5 (
  .clka(clk),    // input wire clka
  .addra(target_address_5),  // input wire [9 : 0] addra
  .douta(blk2_color_from_mem_5)  // output wire [11 : 0] douta
);

  explosion explosion5 (
  .clka(clk),    // input wire clka
  .addra(target_address_5),  // input wire [9 : 0] addra
  .douta(explosion_color_from_mem_5)  // output wire [11 : 0] douta
);


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
            is_in_forbidden_area = ((pos_x > FORBID1_X1+32) && (pos_x < FORBID1_X2 + 4) && (pos_y > FORBID1_Y1 - 26 +32) && (pos_y < FORBID1_Y2-16)) ||
                                   ((pos_x > FORBID2_X1+32) && (pos_x < FORBID2_X2 + 4) && (pos_y > FORBID2_Y1 - 8+32) && (pos_y < FORBID2_Y2-6)) ||
                                   ((pos_x > FORBID3_X1+32) && (pos_x < FORBID3_X2 + 4) && (pos_y > FORBID3_Y1 - 14+32) && (pos_y < FORBID3_Y2-6)) ||
                                   ((pos_x > FORBID4_X1+32) && (pos_x < FORBID4_X2 + 4) && (pos_y > FORBID4_Y1 - 14+32) && (pos_y < FORBID4_Y2-6)) ||
                                   ((pos_x > FORBID5_X1 - 8+32) && (pos_x < FORBID5_X2 - 8) && (pos_y > FORBID5_Y1 -32 +32) && (pos_y < FORBID5_Y2-32 ))||
                                   ((pos_x > 1219+16 - 10) || (pos_x < 62) || (pos_y > 751 + 12 - 32 - 12) || (pos_y < 49 +16-12 ))||
                                   ((pos_x > FORBID6_X1+32) && (pos_x < FORBID6_X2 + 4) && (pos_y > FORBID6_Y1 - 26+32) && (pos_y < FORBID6_Y2-32));
        end
endfunction 

function tank_boom;
        input integer target_x, target_y, tank_x, tank_y;
        begin
            tank_boom = ((tank_x > target_x - 32) && (tank_x < target_x + 64) && (tank_y > target_y - 64) && (tank_y < target_y + 32));
        end
endfunction

always @ (posedge clk)
begin
     case (sw)
            4'b1000:  begin greentank_orient <= tank_UP;
                            laser_start_x <= blkpos_x + 16;
                            laser_start_y <= blkpos_y + 32;
                            end
            4'b0100:  begin greentank_orient <= tank_DOWN;
                            laser_start_x <= blkpos_x + 16;
                            laser_start_y <= blkpos_y;
                            end
            4'b0010:  begin greentank_orient <= tank_LEFT;
                            laser_start_x <= blkpos_x;
                            laser_start_y <= blkpos_y + 16;
                            end
            4'b0001:  begin greentank_orient <= tank_RIGHT;
                            laser_start_x <= blkpos_x + 32;
                            laser_start_y <= blkpos_y + 16;
                            end
            default: greentank_orient <= greentank_orient;
     endcase
end


always @(posedge clk) begin
    // Scaling current screen coordinates to memory coordinates
    // Using the reciprocal of the scaling factor
    // Shifting right by 10 bits (1024) to adjust for the fixed-point multiplication
    scaled_x = (curr_x * X_SCALE) >> 10;
    scaled_y = (curr_y * Y_SCALE) >> 10;
    
    // Making sure the scaled coordinates do not exceed the memory bounds
    if (scaled_x >= 512) scaled_x = 511;
    if (scaled_y >= 384) scaled_y = 383;
    
    // Combining the scaled coordinates to form the memory address
    address_reg = {scaled_y, scaled_x};
end
    
assign mem_address = address_reg;

    // Combinational logic for block color
always @(*) begin
if (greentank_orient==tank_UP) begin
    // Check if we're within the bounds of the tank
    if (curr_x >= blkpos_x && curr_x < blkpos_x + 32 &&
        curr_y >= blkpos_y && curr_y < blkpos_y + 32 && bg_color_from_mem==WHITE_COLOR) begin
        // Calculate the address in the tank memory
        // The tank memory is organized as a 32x32 array within a 1024 address space
        tankup_addr = (curr_y - blkpos_y) * 32 + (curr_x - blkpos_x);
        display_state = 1'b1; // Indicate that we are displaying the tank
    end else begin
        // Outside the tank's area, we are displaying the background
        // The address can be reset or maintained, here it is reset
        tankup_addr = 10'd0;
        display_state = 1'b0;
    end
end else if (greentank_orient==tank_DOWN) begin
    // Check if we're within the bounds of the tank
    if (curr_x >= blkpos_x && curr_x < blkpos_x + 32 &&
        curr_y >= blkpos_y && curr_y < blkpos_y + 32 && bg_color_from_mem==WHITE_COLOR) begin
        // Calculate the address in the tank memory
        // The tank memory is organized as a 32x32 array within a 1024 address space
        tankdown_addr = (curr_y - blkpos_y) * 32 + (curr_x - blkpos_x);
        display_state = 1'b1; // Indicate that we are displaying the tank
    end else begin
        // Outside the tank's area, we are displaying the background
        // The address can be reset or maintained, here it is reset
        tankdown_addr = 10'd0;
        display_state = 1'b0;
    end
end else if (greentank_orient==tank_RIGHT) begin
    // Check if we're within the bounds of the tank
    if (curr_x >= blkpos_x && curr_x < blkpos_x + 32 &&
        curr_y >= blkpos_y && curr_y < blkpos_y + 32 && bg_color_from_mem==WHITE_COLOR) begin
        // Calculate the address in the tank memory
        // The tank memory is organized as a 32x32 array within a 1024 address space
        tankright_addr = (curr_y - blkpos_y) * 32 + (curr_x - blkpos_x);
        display_state = 1'b1; // Indicate that we are displaying the tank
    end else begin
        // Outside the tank's area, we are displaying the background
        // The address can be reset or maintained, here it is reset
        tankright_addr = 10'd0;
        display_state = 1'b0;
    end
end else if (greentank_orient==tank_LEFT) begin
    // Check if we're within the bounds of the tank
    if (curr_x >= blkpos_x && curr_x < blkpos_x + 32 &&
        curr_y >= blkpos_y && curr_y < blkpos_y + 32 && bg_color_from_mem==WHITE_COLOR) begin
        // Calculate the address in the tank memory
        // The tank memory is organized as a 32x32 array within a 1024 address space
        tankleft_addr = (curr_y - blkpos_y) * 32 + (curr_x - blkpos_x);
        display_state = 1'b1; // Indicate that we are displaying the tank
    end else begin
        // Outside the tank's area, we are displaying the background
        // The address can be reset or maintained, here it is reset
        tankleft_addr = 10'd0;
        display_state = 1'b0;
    end
    end
end

// blk 2 display
always @(*) begin
    // Default state
    target_address = 10'd0;
    target_address_2 = 10'd0;
    target_address_3 = 10'd0;
    target_address_4 = 10'd0;
    target_address_5 = 10'd0;
    target_display_state = 1'b0;
    target_display_state_2 = 1'b0;
    target_display_state_3 = 1'b0;
    target_display_state_4 = 1'b0;
    target_display_state_5 = 1'b0;

    if (curr_x >= blkpos_x_2 && curr_x < blkpos_x_2 + 32 &&
        curr_y >= blkpos_y_2 && curr_y < blkpos_y_2 + 32 && 
        bg_color_from_mem == WHITE_COLOR) begin
        // Block 2 display logic
        target_address = (curr_y - blkpos_y_2) * 32 + (curr_x - blkpos_x_2);
        target_display_state = 1'b1;
    end else if (boom_state == 1'b1 && 
                 curr_x >= blkpos_x_3 && curr_x < blkpos_x_3 + 32 &&
                 curr_y >= blkpos_y_3 && curr_y < blkpos_y_3 + 32 && 
                 bg_color_from_mem == WHITE_COLOR) begin
        // Block 3 display logic
        target_address_2 = (curr_y - blkpos_y_3) * 32 + (curr_x - blkpos_x_3);
        target_display_state_2 = 1'b1;///////////
    end else if (boom_state == 1'b1 && 
                 curr_x >= blkpos_x_4 && curr_x < blkpos_x_4 + 32 &&
                 curr_y >= blkpos_y_4 && curr_y < blkpos_y_4 + 32 && 
                 bg_color_from_mem == WHITE_COLOR) begin
        // Block 3 display logic
        target_address_3 = (curr_y - blkpos_y_4) * 32 + (curr_x - blkpos_x_4);
        target_display_state_3 = 1'b1;
    end else if (boom_state == 1'b1 && 
                 curr_x >= blkpos_x_5 && curr_x < blkpos_x_5 + 32 &&
                 curr_y >= blkpos_y_5 && curr_y < blkpos_y_5 + 32 && 
                 bg_color_from_mem == WHITE_COLOR) begin
        // Block 3 display logic
        target_address_4 = (curr_y - blkpos_y_5) * 32 + (curr_x - blkpos_x_5);
        target_display_state_4 = 1'b1;
    end else if (boom_state == 1'b1 && 
                 curr_x >= blkpos_x_6 && curr_x < blkpos_x_6 + 32 &&
                 curr_y >= blkpos_y_6 && curr_y < blkpos_y_6 + 32 && 
                 bg_color_from_mem == WHITE_COLOR) begin
        // Block 3 display logic
        target_address_5 = (curr_y - blkpos_y_6) * 32 + (curr_x - blkpos_x_6);
        target_display_state_5 = 1'b1;
    end

end



always @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Reset state
       reset_state = 1'b0;
    end else
       reset_state = 1'b1;
end



// tank state and display
always @(*) begin
    if (reset_state == 1'b1) begin
    if (!tank_boom(blkpos_x_2,blkpos_y_2,blkpos_x,blkpos_x)) begin// &&
//    !tank_boom(blkpos_x_3,blkpos_y_3,blkpos_x,blkpos_x) &&
//    !tank_boom(blkpos_x_4,blkpos_y_4,blkpos_x,blkpos_x) &&
//    !tank_boom(blkpos_x_5,blkpos_y_5,blkpos_x,blkpos_x) &&
//    !tank_boom(blkpos_x_6,blkpos_y_6,blkpos_x,blkpos_x)) begin
     if (fire) begin
        // Check if the current pixel is within the line
        if (greentank_orient == tank_UP && curr_x >= laser_start_x - 2  && curr_x <= laser_start_x + 2 &&
            curr_y >= laser_start_y  && curr_y <= laser_start_y + 80 ) begin
            // If within the line, set the color to red
            if (!is_in_forbidden_area(curr_x, curr_y)) begin
               laser_color = RED_COLOR;
               fire_state = 1'b1;
               if (curr_x >= blkpos_x_2  && curr_x <= blkpos_x_2 + 32 &&
               curr_y >= blkpos_y_2   && curr_y <= blkpos_y_2 +32) begin //need to check and change here
                   display_explosion_state = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_3  && curr_x <= blkpos_x_3 + 32 &&
               curr_y >= blkpos_y_3   && curr_y <= blkpos_y_3 +32 ) begin //need to check and change here
                   display_explosion_state_2 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_4  && curr_x <= blkpos_x_4 + 32 &&
               curr_y >= blkpos_y_4   && curr_y <= blkpos_y_4 +32 ) begin //need to check and change here
                   display_explosion_state_3 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_5  && curr_x <= blkpos_x_5 + 32 &&
               curr_y >= blkpos_y_5   && curr_y <= blkpos_y_5 +32 ) begin //need to check and change here
                   display_explosion_state_4 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_6  && curr_x <= blkpos_x_6 + 32 &&
               curr_y >= blkpos_y_6   && curr_y <= blkpos_y_6 +32 ) begin //need to check and change here
                   display_explosion_state_5 = 1'b1; // Indicate that we are displaying the tank
               end
            end else begin
               fire_state = 1'b0;
               end
            end
        else if (greentank_orient == tank_DOWN && curr_x >= laser_start_x - 2  && curr_x <= laser_start_x + 2 &&
            curr_y >= laser_start_y-80  && curr_y <= laser_start_y ) begin
            // If within the line, set the color to red
            if (!is_in_forbidden_area(curr_x, curr_y)) begin
               laser_color = RED_COLOR;
               fire_state = 1'b1;
               if (curr_x >= blkpos_x_2  && curr_x <= blkpos_x_2 + 32 &&
               curr_y >= blkpos_y_2   && curr_y <= blkpos_y_2 +32) begin //need to check and change here
                   display_explosion_state = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_3  && curr_x <= blkpos_x_3 + 32 &&
               curr_y >= blkpos_y_3   && curr_y <= blkpos_y_3 +32 ) begin //need to check and change here
                   display_explosion_state_2 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_4  && curr_x <= blkpos_x_4 + 32 &&
               curr_y >= blkpos_y_4   && curr_y <= blkpos_y_4 +32 ) begin //need to check and change here
                   display_explosion_state_3 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_5  && curr_x <= blkpos_x_5 + 32 &&
               curr_y >= blkpos_y_5   && curr_y <= blkpos_y_5 +32 ) begin //need to check and change here
                   display_explosion_state_4 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_6  && curr_x <= blkpos_x_6 + 32 &&
               curr_y >= blkpos_y_6   && curr_y <= blkpos_y_6 +32 ) begin //need to check and change here
                   display_explosion_state_5 = 1'b1; // Indicate that we are displaying the tank
               end
            end else begin
               fire_state = 1'b0;
               end
            end
        else if (greentank_orient == tank_LEFT && curr_x >= laser_start_x-80  && curr_x <= laser_start_x &&
            curr_y >= laser_start_y-2  && curr_y <= laser_start_y+2) begin
            if (!is_in_forbidden_area(curr_x, curr_y)) begin
               laser_color = RED_COLOR;
               fire_state = 1'b1;
               if (curr_x >= blkpos_x_2 -32  && curr_x <= blkpos_x_2  &&
               curr_y >= blkpos_y_2   && curr_y <= blkpos_y_2 +32) begin //need to check and change here
                   display_explosion_state = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_3  && curr_x <= blkpos_x_3 + 32 &&
               curr_y >= blkpos_y_3   && curr_y <= blkpos_y_3 +32 ) begin //need to check and change here
                   display_explosion_state_2 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_4  && curr_x <= blkpos_x_4 + 32 &&
               curr_y >= blkpos_y_4   && curr_y <= blkpos_y_4 +32 ) begin //need to check and change here
                   display_explosion_state_3 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_5  && curr_x <= blkpos_x_5 + 32 &&
               curr_y >= blkpos_y_5   && curr_y <= blkpos_y_5 +32 ) begin //need to check and change here
                   display_explosion_state_4 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_6  && curr_x <= blkpos_x_6 + 32 &&
               curr_y >= blkpos_y_6   && curr_y <= blkpos_y_6 +32 ) begin //need to check and change here
                   display_explosion_state_5 = 1'b1; // Indicate that we are displaying the tank
               end
            end else begin
               fire_state = 1'b0;
               end
            end 
        else if (greentank_orient == tank_RIGHT && curr_x >= laser_start_x  && curr_x <= laser_start_x+80 &&
            curr_y >= laser_start_y-2  && curr_y <= laser_start_y+2) begin  
            if (!is_in_forbidden_area(curr_x, curr_y)) begin
               laser_color = RED_COLOR;
               fire_state = 1'b1;
               if (curr_x >= blkpos_x_2  && curr_x <= blkpos_x_2 + 32 &&
               curr_y >= blkpos_y_2   && curr_y <= blkpos_y_2 +32) begin //need to check and change here
                   display_explosion_state = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_3  && curr_x <= blkpos_x_3 + 32 &&
               curr_y >= blkpos_y_3   && curr_y <= blkpos_y_3 +32 ) begin //need to check and change here
                   display_explosion_state_2 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_4  && curr_x <= blkpos_x_4 + 32 &&
               curr_y >= blkpos_y_4   && curr_y <= blkpos_y_4 +32 ) begin //need to check and change here
                   display_explosion_state_3 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_5  && curr_x <= blkpos_x_5 + 32 &&
               curr_y >= blkpos_y_5   && curr_y <= blkpos_y_5 +32 ) begin //need to check and change here
                   display_explosion_state_4 = 1'b1; // Indicate that we are displaying the tank
               end
               if (curr_x >= blkpos_x_6  && curr_x <= blkpos_x_6 + 32 &&
               curr_y >= blkpos_y_6   && curr_y <= blkpos_y_6 +32 ) begin //need to check and change here
                   display_explosion_state_5 = 1'b1; // Indicate that we are displaying the tank
               end
            end else begin
               fire_state = 1'b0;
               end
        end else begin
            laser_color = 12'd0;
            fire_state = 1'b0;
           end 
    end
    else begin
       laser_color = 12'd0;
       fire_state = 1'b0;
    end 
    end else begin
       tank_boom_state = 1'b1;
       end
    end else begin
       tank_boom_state = 1'b0;
       display_explosion_state= 1'b0;
       display_explosion_state_2= 1'b0;
       display_explosion_state_3= 1'b0;
       display_explosion_state_4= 1'b0;
       display_explosion_state_5= 1'b0;
    end
end

reg [11:0] output_color;

always @(*) begin
        if (target_display_state == 1'b1) begin
            if (display_explosion_state == 1'b1) begin
               output_color = explosion_color_from_mem;
            end else begin
               output_color = blk2_color_from_mem;
            end
        end else if (target_display_state_2 == 1'b1) begin
            if (display_explosion_state_2 == 1'b1) begin
               output_color = explosion_color_from_mem_2;
            end else begin
            output_color = blk2_color_from_mem_2;
            end
        end else if (target_display_state_3 == 1'b1) begin
            if (display_explosion_state_3 == 1'b1) begin
               output_color = explosion_color_from_mem_3;
            end else begin
            output_color = blk2_color_from_mem_3;
            end
        end else if (target_display_state_4 == 1'b1) begin
            if (display_explosion_state_4 == 1'b1) begin
               output_color = explosion_color_from_mem_4;
            end else begin
            output_color = blk2_color_from_mem_4;
            end 
        end else if (target_display_state_5 == 1'b1) begin
            if (display_explosion_state_5 == 1'b1) begin
               output_color = explosion_color_from_mem_5;
            end else begin
            output_color = blk2_color_from_mem_5;
            end  
        end
end




assign color_from_mem = (display_state != 0 || fire_state!=0 || target_display_state!=0 || target_display_state_2!=0
                     || target_display_state_3!=0 || target_display_state_4!=0 || target_display_state_5!=0) ? (
                     fire_state == 1'b1    ? laser_color    :
                     target_display_state == 1'b1 || target_display_state_2 ==1'b1 || target_display_state_3 ==1'b1
                     || target_display_state_4 ==1'b1 || target_display_state_5 ==1'b1
                     ? output_color:
                     greentank_orient == tank_UP    ? up_color_from_mem    :
                     greentank_orient == tank_RIGHT ? right_color_from_mem :
                     greentank_orient == tank_DOWN  ? down_color_from_mem  : 
                     greentank_orient == tank_LEFT  ? left_color_from_mem  :
                     bg_color_from_mem // This should be your default case if none above matches
                 ) : bg_color_from_mem;


assign boom_state = (display_explosion_state == 1'b1 ) ? 1'b1 : 1'b0;
assign boom_state_2 = (display_explosion_state_2 == 1'b1 ) ? 1'b1 : 1'b0;
assign boom_state_3 = (display_explosion_state_3 == 1'b1 ) ? 1'b1 : 1'b0;
assign boom_state_4 = (display_explosion_state_4 == 1'b1 ) ? 1'b1 : 1'b0;
assign boom_state_5 = (display_explosion_state_5 == 1'b1 ) ? 1'b1 : 1'b0;

    // Combinational logic to combine foreground and background
wire condition = (display_state != 0 || fire_state != 0 || target_display_state != 0 || target_display_state_2 != 0 
                  || target_display_state_3 != 0 || target_display_state_4 != 0 || target_display_state_5 != 0);


assign draw_r = condition ? color_from_mem[11:8] : bg_color_from_mem[11:8];
assign draw_g = condition ? color_from_mem[7:4] : bg_color_from_mem[7:4];
assign draw_b = condition ? color_from_mem[3:0] : bg_color_from_mem[3:0];

//assign draw_r = (tank_boom_state == 1'b1) ? bg_color_from_mem[11:8] :
//                condition ? color_from_mem[11:8] : bg_color_from_mem[11:8];
//assign draw_g = (tank_boom_state == 1'b1) ? bg_color_from_mem[7:4] :
//                condition ? color_from_mem[7:4] : bg_color_from_mem[7:4];
//assign draw_b = (tank_boom_state == 1'b1) ? bg_color_from_mem[3:0] :
//                condition ? color_from_mem[3:0] : bg_color_from_mem[3:0];



endmodule
