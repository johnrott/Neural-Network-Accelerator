`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 10:14:05 PM
// Design Name: 
// Module Name: matrixMultiply3x3
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


module matrixMultiply3x3(
    input [7:0] a11, a12, a13, a21, a22, a23, a31, a32, a33,
    input [7:0] x1, x2, x3,
    output [15:0] y1, y2, y3
    );
    
    assign y1 = ($signed(a11) * $signed(x1)) + ($signed(a12) * $signed(x2)) + ($signed(a13) * $signed(x3));
    assign y2 = ($signed(a21) * $signed(x1)) + ($signed(a22) * $signed(x2)) + ($signed(a23) * $signed(x3));
    assign y3 = ($signed(a31) * $signed(x1)) + ($signed(a32) * $signed(x2)) + ($signed(a33) * $signed(x3));
    
    
endmodule
