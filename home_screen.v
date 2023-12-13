`timescale 1ns / 1ps

module home_screen(
    input clk,         // System clock input
    input reset,       // System reset input
    input [3:0] level_buttons,    // Input for level selection buttons
    output reg [1:0] level,       // Output representing the selected game level
    output reg start              // Output indicating the start signal for the game
);

    reg active; // Flag indicating if the game is currently active; reset needed to change the level
    
    // Clocked process triggered on the positive edge of the system clock or the reset signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Resetting the game state when the reset signal is asserted
            level <= 2'b00;
            start <= 0; 
            active <= 0;
        end else begin
            if (!active) begin
                // Checking level selection buttons and updating the game state accordingly
                case (level_buttons)
                    4'b0001: begin
                        level <= 2'b00;
                        start <= 1;
                    end
                    4'b0010: begin
                        level <= 2'b01;
                        start <= 1;
                    end
                    4'b0100: begin
                        level <= 2'b10;
                        start <= 1;
                    end
                    4'b1000: begin
                        level <= 2'b11;
                        start <= 1;
                    end
                    default: begin 
                        start <= 0;
                    end
                endcase
            end
            if (start) begin 
                // Activating the game when the start signal is asserted
                active <= 1;
            end
        end 
    end
endmodule
