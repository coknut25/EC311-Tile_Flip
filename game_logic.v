`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 07:16:53 PM
// Design Name: 
// Module Name: game_logic
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


module game_logic(
    input clk,
    input reset,
    input [15:0] switches,
    output reg [15:0] tile_states,
    output reg [47:0] tile_values_flat, // Flattened 48-bit wide signal for tile values
    output reg game_reset,
    output reg [3:0] tries
);

    reg [3:0] first_selected = 0, second_selected = 0;
    reg [15:0] previous_state;
    reg selecting_second = 0;
    reg [15:0] matched_tiles;  // Register to track matched tiles
    reg [15:0] mismatched_tiles; // Register to track mismatched tiles
    reg [3:0] mismatch_counter = 0; // Counter for time after mismatch
    integer i;

    always @(posedge clk) begin
        if (reset || tries >= 10) begin
            // Reset the game state
            tries <= 0;
            game_reset <= 1;
            tile_states <= 0;
            selecting_second <= 0;
            matched_tiles <= 0;  // Reset matched tiles
            mismatched_tiles <= 0; // Reset mismatched tiles
            mismatch_counter <= 0; // Reset mismatch counter
            tile_values_flat <= 0; // Reset tile values
            // Reset other states as needed
        end else begin
            game_reset <= 0;
           
            // Detect switch changes to select tiles
            for (i = 0; i < 16; i = i + 1) begin
                if (switches[i] && !previous_state[i] && !matched_tiles[i] && !mismatched_tiles[i]) begin
                    if (!selecting_second) begin
                        first_selected <= i;
                        selecting_second <= 1;
                        tile_states[i] <= 1;
                    end else begin
                        second_selected <= i;
                        tile_states[i] <= 1;
                        selecting_second <= 0;
                        tries <= tries + 1;

                        // Check if tiles match
                        if (tile_values_flat[first_selected*3 +: 3] == tile_values_flat[second_selected*3 +: 3]) begin
                            // Handle matched tiles
                            matched_tiles[first_selected] <= 1;
                            matched_tiles[second_selected] <= 1;
                        end else begin
                            // Handle unmatched tiles
                            mismatched_tiles[first_selected] <= 1;
                            mismatched_tiles[second_selected] <= 1;
                            mismatch_counter <= 0; // Start counter for 1 second
                        end
                    end
                end
            end
           
            // Increment mismatch counter if needed
            if (mismatch_counter < 100000000) begin
                mismatch_counter <= mismatch_counter + 1; // Assuming 1 second is 100000000 clock cycles
            end else begin
                // Reset mismatched tiles after 1 second
                mismatched_tiles <= 0;
                mismatch_counter <= 0;
            end
           
            // Update previous state
            previous_state <= switches;
        end
    end

endmodule






