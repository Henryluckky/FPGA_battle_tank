`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 06:49:09 PM
// Design Name: 
// Module Name: clk_counter
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


module clk_counter(
    input clk,         // 1 MHz input clock
    output reg clk_60Hz // 60 Hz output clock
);
    // Using a 32-bit counter for large count values
    reg [20:0] counter;


    always @(posedge clk) begin
        if (counter >= 266664) begin //
            clk_60Hz <= ~clk_60Hz;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
