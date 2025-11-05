`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2025 11:59:12 AM
// Design Name: 
// Module Name: top_design_3by3_accel
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


module top_design_3by3_accel(
    output led0_g, led0_r,
    output [4:0] ja,
    input [1:0] btn,
    input clk
    );
    
    // ---------- MATRIX INPUTS ----------
    wire [7:0] a11, a12, a13, a21, a22, a23, a31, a32, a33;
    wire [7:0] x1, x2, x3;
    wire [15:0] y1, y2, y3;
    
    // ---------- CONTROL & OUTPUT ----------
    reg [3:0] tempOut;
    wire ClkOut;
    reg [3:0] count;
    reg resetFlag;
    wire doneFlag;
    reg [3:0] pulseCount; // used to stretch the done pulse
    
    // ---------- CONSTANT MATRIX VALUES ----------
    assign x1 = 1;
    assign x2 = 1;
    assign x3 = 1;
    
    assign a11 = 1;
    assign a12 = 2;
    assign a13 = 3;
    
    assign a21 = 1;
    assign a22 = 1;
    assign a23 = 1;
    
    assign a31 = 2;
    assign a32 = 1;
    assign a33 = 2;
    
    // ---------- OUTPUT CONNECTIONS ----------
    assign ja[3:0] = tempOut;
    assign ja[4] = resetFlag;
    
    // ---------- MODULE INSTANTIATIONS ----------
    datapath3by3accelerator dp(
        .clk(clk),
        .reset(btn[0]),
        .start(btn[1]),
        .a11(a11), .a12(a12), .a13(a13),
        .a21(a21), .a22(a22), .a23(a23),
        .a31(a31), .a32(a32), .a33(a33),
        .x1(x1), .x2(x2), .x3(x3),
        .y1(y1), .y2(y2), .y3(y3),
        .done(doneFlag)
    );
        
    ClkDiv cd(clk, 1'b0, ClkOut);
    
    assign led0_g = ja[4];
    assign led0_r = ja[0];
    
    // ---------- MAIN OUTPUT SEQUENCER ----------
    always @(posedge ClkOut or posedge btn[0]) begin
        if (btn[0]) begin
            count <= 0;
            tempOut <= 0;
            resetFlag <= 0;
            pulseCount <= 0;
        end
        else begin
            // Hold resetFlag HIGH for a few cycles for Arduino to catch
            if (pulseCount > 0) begin
                pulseCount <= pulseCount - 1;
                if (pulseCount == 1)
                    resetFlag <= 0;
            end
            else if (doneFlag) begin
                case (count)
                    4'd0: begin
                        tempOut <= y1[3:0];
                        count <= 4'd1;
                        resetFlag <= 1;
                        pulseCount <= 4'd3;
                    end
                    4'd1: begin
                        tempOut <= y2[3:0];
                        count <= 4'd2;
                        resetFlag <= 1;
                        pulseCount <= 4'd3;
                    end
                    4'd2: begin
                        tempOut <= y3[3:0];
                        count <= 4'd0; // wrap around
                        resetFlag <= 1;
                        pulseCount <= 4'd3;
                    end
                    default: begin
                        count <= 0;
                        resetFlag <= 0;
                    end
                endcase
            end
        end
    end
    
endmodule
    
