`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 06:48:05 PM
// Design Name: 
// Module Name: vga_out
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2023 10:29:53 AM
// Design Name: 
// Module Name: vga_out
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


module vga_out (
    input clk,
    input [3:0] r,
    input [3:0] g,
    input [3:0] b,
    output [3:0] pix_r,    // 4-bit output for red pixel value
    output [3:0] pix_g,    // 4-bit output for green pixel value
    output [3:0] pix_b,    // 4-bit output for blue pixel value
    output hsync,          // horizontal sync pulse
    output vsync,           // vertical sync pulse
    output reg [10:0] curr_x,
    output reg [9:0] curr_y
);
//    reg [3:0] sw_r = 4'b1001; // Sample value
//    reg [3:0] sw_g = 4'b0011; // Sample value
//    reg [3:0] sw_b = 4'b0001; // Sample value
    
    // Declare internal counters
    reg [10:0] hcount = 0; // 11-bit horizontal counter
    reg [9:0] vcount = 0;  // 10-bit vertical counter
    
    always @(posedge clk) begin
        if (hcount == 1679) begin
            hcount <= 0;   // wrap around
            if (vcount == 827) begin
                vcount <= 0;   // wrap around
            end else begin
                vcount <= vcount + 1;
            end
        end else begin
            hcount <= hcount + 1;
        end
    end
    
    
    always @(posedge clk) begin
        if (hcount >= 336 && hcount <= 1615 && vcount >= 27 && vcount <= 826) begin
            curr_x <= hcount - 336;
            curr_y <= vcount - 27;
        end
    end

    // Assign values to sync pulses
    assign hsync = (hcount <= 135) ? 0 : 1;
    assign vsync = (vcount <= 2) ? 1 : 0;
    

//    always @* begin
//        if (curr_x > 520 && curr_x < 760 && curr_y > 300 && curr_y < 500) begin
//            // Inside the rectangle
//            r_color = 4'b1111; // Example: White color
//            g_color = 4'b1111;
//            b_color = 4'b1111;
//        end else begin
//            // Outside the rectangle (background)
//            r_color = 4'b0000; // Example: Black color
//            g_color = 4'b0000;
//            b_color = 4'b0000;
//        end
//    end

    // Set pixel values during the visible region
    assign pix_r = (hcount >= 336 && hcount <= 1615 && vcount >= 27 && vcount <= 826) ? r : 4'b0000;
    assign pix_g = (hcount >= 336 && hcount <= 1615 && vcount >= 27 && vcount <= 826) ? g : 4'b0000;
    assign pix_b = (hcount >= 336 && hcount <= 1615 && vcount >= 27 && vcount <= 826) ? b : 4'b0000;
    


endmodule
