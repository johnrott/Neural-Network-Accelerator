`timescale 1ns / 1ps


module datapath3by3accelerator(
    input clk, reset, start,
    input [7:0] a11, a12, a13, a21, a22, a23, a31, a32, a33,
    input[7:0] x1, x2, x3,
    output reg [15:0] y1, y2, y3,
    output done,
    output busy
    );
    
    //declare control signals
    wire load_mat;
    wire computation;
    
    //internal registers
    reg [7:0] A11, A12, A13;
    reg [7:0] A21, A22, A23;
    reg [7:0] A31, A32, A33;
    
    reg [7:0] X1, X2, X3;
    
    //declare result wires
    wire [15:0] Y1, Y2, Y3;
    
    //controller
    controller controls(
        .clk(clk),
        .start(start),
        .reset(reset),
        .done(done),
        .busy(busy),
        .load_mat(load_mat),
        .computation(computation));
        
    //matrix multiplier
    matrixMultiply3x3 matmult(
        .a11(A11), .a12(A12), .a13(A13),
        .a21(A21), .a22(A22), .a23(A23),
        .a31(A31), .a32(A32), .a33(A33),
        .x1(X1), .x2(X2), .x3(X3),
        .y1(Y1), .y2(Y2), .y3(Y3));
        
    //Load phase
    always @(posedge clk or posedge reset) begin
    
        //flush registers if there is a reset
        if (reset) begin
            A11 <= 0; A12 <= 0; A13 <= 0;
            A21 <= 0; A22 <= 0; A23 <= 0;
            A31 <= 0; A32 <= 0; A33 <= 0;
            X1 <= 0; X2 <= 0; X3 <= 0;
        end
        
        //load values into registers
        else if(load_mat) begin
            A11 <= a11; A12 <= a12; A13 <= a13;
            A21 <= a21; A22 <= a22; A23 <= a23;
            A31 <= a31; A32 <= a32; A33 <= a33;
            X1 <= x1; X2 <= x2; X3 <= x3;
        end
        
    end
    
    //Compute phase
    always @(posedge clk or posedge reset) begin
    
        //flush outputs if reset occurs
        if (reset) begin
            y1 <= 0; y2 <= 0; y3 <= 0;
        end
        
        //store computation outputs if in computations stage
        else if(computation) begin
            y1 <= Y1; y2 <= Y2; y3 <= Y3;
        end
    
    end
    
    
    
endmodule
