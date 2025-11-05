`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2025 08:48:48 PM
// Design Name: 
// Module Name: matrix2by2X2by1
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


module matrix2by2X2by1(
    input [7:0] a11, a12, a21, a22,
    input [7:0] x1, x2,
    output [15:0] y1, y2
    );
    
    assign y1 = ($signed(a11) * $signed(x1)) + ($signed(a12) * $signed(x2));
    assign y2 = ($signed(a21) * $signed(x1)) + ($signed(a22) * $signed(x2));
    
    
endmodule
