`timescale 1ns / 1ps


module controller(clk, start, reset, done, busy, load_mat, computation);

    input  clk, start, reset;
    output reg done, busy, load_mat, computation;

    reg [1:0] state, nextState;

    localparam idle = 2'd0, load = 2'd1, compute = 2'd2, write = 2'd3;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= idle;
        else
            state <= nextState;
    end

    always @(*) begin
        // ---------- SAFE DEFAULTS ----------
        nextState   = state; 
        load_mat    = 1'b0;
        computation = 1'b0;
        busy        = 1'b0;
        done        = 1'b0;  

        case (state)
            idle: begin
                // nothing running
                busy = 1'b0;
                if (start) begin
                    nextState = load;
                    busy      = 1'b1;
                    // done stays 0 by default
                end
            end

            load: begin
                nextState   = compute;
                load_mat    = 1'b1;  // one-cycle load
                busy        = 1'b1;
            end

            compute: begin
                nextState   = write;
                computation = 1'b1;  // one-cycle compute enable
                busy        = 1'b1;
            end

            write: begin
                nextState = idle;
                // signal completion for exactly one cycle
                done      = 1'b1;
                // busy default is 0 here (we’re finishing)
            end

            default: begin
                nextState   = idle;
                // defaults already deassert all outputs
            end
        endcase
    end

endmodule
