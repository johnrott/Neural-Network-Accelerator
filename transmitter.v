`timescale 1ns / 1ps


module transmitter(
    input clk,
    input [7:0] data,
    input transmit,
    input reset,
    output reg TxD
    );
    
    
    reg [3:0] bit_counter;
    reg [13:0] baud_rate_counter; //baud reate of 9600 bps // needs to go 10415 cc per baud
    reg [9:0] shift_right_register; //10 bits serially transitted
    reg state, nextState;
    reg shift, load, clear;
    
    //UART transmission
    
    always @(posedge clk) begin
        if (reset) begin
            state <= 0;
            bit_counter <= 0;
            baud_rate_counter <= 0;
        end
        else begin
            baud_rate_counter <= baud_rate_counter + 1;
            if(baud_rate_counter == 13020) begin //when we match buad rate
                state <= nextState;
                baud_rate_counter <= 0;  
                if(load) begin
                    shift_right_register <= {1'b1, data, 1'b0}; //load in date with start and stop bits  
                end 
                if(clear) begin
                    bit_counter <= 0;
                end
                if(shift) begin
                    shift_right_register <= shift_right_register >> 1;//shift data to next bit for transmission
                    bit_counter <= bit_counter + 1;
                end                 
            end          
        end 
    end
    
    
    //state machine
    always @(posedge clk) begin
        load <= 0;
        shift <= 0;
        clear <= 0;
        TxD <= 1;//when 1, no transmission in progress
        
        case(state)
        
            0: begin
                if(transmit) begin
                    nextState <= 1;
                    load <= 1;
                    shift <= 0;
                    clear <= 0;
                end
                else begin
                    nextState <= 0;
                    TxD <= 1;
                end
            end
            
            1: begin
                if(bit_counter == 10) begin
                    nextState <= 0;
                    clear <= 1;
                end
                else begin 
                    nextState <= 1;
                    TxD <= shift_right_register[0];
                    shift <= 1;
                end
            end
            
            default: begin
                nextState <= 0;
            end
        endcase
    end
                
    
    
    
    
    
    
    
    
endmodule
