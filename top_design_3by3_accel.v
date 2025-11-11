`timescale 1ns / 1ps


module top_design_3by3_accel(
    output led0_g,
    output [3:0] ja,
    input [1:0] btn,
    input clk
    );
    

    wire [7:0] a11, a12, a13, a21, a22, a23, a31, a32, a33;
    wire [7:0] x1, x2, x3;
    wire [15:0] y1, y2, y3;
    
   
    wire doneFlag;
    assign ja[3] = btn[0];

    
   
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
    
    reg done_prev;
    always @(posedge clk) begin
        if (btn[0]) begin // reset
            done_prev <= 0;
        end
        else begin
            done_prev <= doneFlag;
        end
    end

wire transmitPulse = doneFlag & ~done_prev;
     assign led0_g = transmitPulse;
    

    transmitter y1output(
        .data(y1[7:0]),
        .clk(clk),
        .reset(btn[0]),
        .transmit(transmitPulse),
        .TxD(ja[0]));
    
    transmitter y2output(
        .data(y2[7:0]),
        .clk(clk),
        .reset(btn[0]),
        .transmit(transmitPulse),
        .TxD(ja[1]));
    
    transmitter y3output(
        .data(y3[7:0]),
        .clk(clk),
        .reset(btn[0]),
        .transmit(transmitPulse),
        .TxD(ja[2]));
   
    
endmodule
    
