`timescale 1ns / 1ps

// This Verilog module represents the logic for a memory match game.
module game_logic(
    input clk,          // System clock input
    input reset,        // System reset input
    input [15:0] switches,  // Input for switches representing game state
    output reg [15:0] leds,  // Output LEDs indicating game state
    output reg [47:0] tiles  // Output representing the memory match tiles
);

    // Registers for storing game state
    reg [3:0] first = 4'b1111, second = 4'b1111;
    reg [15:0] match;
    reg [15:0] mismatch;
    reg select2 = 0; 
    reg [1:0] state [15:0];  // State register for each switch
    integer i; 

    // Clocked process triggered on the positive edge of the system clock or the reset signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin 
            // Resetting game state and LEDs when the reset signal is asserted
            for (i = 0; i < 16; i = i + 1) begin
                state[i] <= 0; 
                leds[i] <= 0; 
                match[i] <= 0; 
                mismatch[i] <= 0; 
            end
            first <= 4'b1111;
            second <= 4'b1111;
            select2 <= 0; 
        end else begin
            for (i = 0; i < 16; i = i + 1) begin 
                if (switches[i]) begin
                    if (!select2 && state[i] == 0) begin 
                        // Handling first selection of a switch
                        first <= i;
                        select2 <= 1;
                        state[i] <= 1;
                    end else if (select2 && state[i] == 0) begin 
                        // Handling second selection of a switch
                        second <= i; 
                        select2 <= 0;
                        state[i] <= 1;
                        
                        // Checking if selected tiles match
                        if (tiles[first*3 +: 3] == tiles[second*3 +: 3]) begin
                            match[first] <= 1; 
                            match[second] <= 1; 
                            leds[first] <= 1; 
                            leds[second] <= 1; 
                        end else begin 
                            mismatch[first] <= 1;
                            mismatch[second] <= 1;
                        end
                        
                        // Resetting selection registers
                        first <= 4'b1111;
                        second <= 4'b1111;
                    end
                end else if (!switches[i] && state[i] == 1) begin
                    // Resetting state if a switch is deselected
                    state[i] <= 0; 
                    if (i == first) first <= 4'b1111;
                    if (i == second) second <= 4'b1111;
                end
            end
        end
    end
endmodule






