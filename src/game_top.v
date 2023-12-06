`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 06:46:30 PM
// Design Name: 
// Module Name: game_top
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


module game_top (
    input clk,
    input rst,       // Current pixel position inputs
    input up,down,left,right,fire,
    output [3:0] pix_r,    // 4-bit output for red pixel value
    output [3:0] pix_g,    // 4-bit output for green pixel value
    output [3:0] pix_b,    // 4-bit output for blue pixel value
    output hsync,          // horizontal sync pulse
    output vsync           // vertical sync pulse
);
    wire pixclk; // Wire for the pixel clock from clock divider
    wire clk_60hz;
    wire [10:0] curr_x;
    wire [9:0] curr_y;
    wire [3:0] draw_r, draw_g, draw_b;
    wire [10:0] blkpos_x;
    wire [9:0] blkpos_y;
    wire [10:0] blkpos_x_2;
    wire [9:0] blkpos_y_2;
    wire [10:0] blkpos_x_3;
    wire [9:0] blkpos_y_3;
    wire [10:0] blkpos_x_4;
    wire [9:0] blkpos_y_4;
    wire [10:0] blkpos_x_5;
    wire [9:0] blkpos_y_5;
    wire [10:0] blkpos_x_6;
    wire [9:0] blkpos_y_6;
//    wire [1:0] random_number;
    wire boom_state;
    wire boom_state_2;
    wire boom_state_3;
    wire boom_state_4;
    wire boom_state_5;
   
  clk_wiz_0 clk_divider
   (
    // Clock out ports
    .clk_out1(pixclk),     // output clk_out1
   // Clock in ports
    .clk_in1(clk));      // input clk_in1

  clk_counter clk_counter
  (
    .clk(clk),
    .clk_60Hz(clk_60hz));
    
    
//  box_control box_control
//  (
//    .clk(clk_60Hz),
//    .blkpos_x(blkpos_x),
//    .blkpos_y(blkpos_y),
//    .blkpos_x_2(blkpos_x_2),
//    .blkpos_y_2(blkpos_y_2),
//    .random_number(random_number));
    
  
    // vga_out instantiation
    vga_out vga_unit(
        .clk(pixclk),
        .r(draw_r),
        .g(draw_g),
        .b(draw_b),
        .pix_r(pix_r),
        .pix_g(pix_g),
        .pix_b(pix_b),
        .hsync(hsync),
        .vsync(vsync),
        .curr_x(curr_x),
        .curr_y(curr_y)
    );
    
    drawcon dc (
        .clk(pixclk),
        .rst(rst),
        .sw({up,down,left,right}),
        .fire(fire),
        .blkpos_x(blkpos_x),
        .blkpos_y(blkpos_y),
        .blkpos_x_2(blkpos_x_2),
        .blkpos_y_2(blkpos_y_2),
        .blkpos_x_3(blkpos_x_3),
        .blkpos_y_3(blkpos_y_3),
        .blkpos_x_4(blkpos_x_4),
        .blkpos_y_4(blkpos_y_4),
        .blkpos_x_5(blkpos_x_5),
        .blkpos_y_5(blkpos_y_5),
        .blkpos_x_6(blkpos_x_6),
        .blkpos_y_6(blkpos_y_6),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .boom_state(boom_state),
        .boom_state_2(boom_state_2),
        .boom_state_3(boom_state_3),
        .boom_state_4(boom_state_4),
        .boom_state_5(boom_state_5),
        .draw_r(draw_r),
        .draw_g(draw_g),
        .draw_b(draw_b)
    );
    
    position_logic position (
        .clk(clk_60hz),
        .rst(rst),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .boom_state(boom_state),
        .boom_state_2(boom_state_2),
        .boom_state_3(boom_state_3),
        .boom_state_4(boom_state_4),
        .boom_state_5(boom_state_5),
        .blkpos_x(blkpos_x),
        .blkpos_y(blkpos_y),
        .blkpos_x_2(blkpos_x_2),
        .blkpos_y_2(blkpos_y_2),
        .blkpos_x_3(blkpos_x_3),
        .blkpos_y_3(blkpos_y_3),
        .blkpos_x_4(blkpos_x_4),
        .blkpos_y_4(blkpos_y_4),
        .blkpos_x_5(blkpos_x_5),
        .blkpos_y_5(blkpos_y_5),
        .blkpos_x_6(blkpos_x_6),
        .blkpos_y_6(blkpos_y_6)
    );
    

endmodule
