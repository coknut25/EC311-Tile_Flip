`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 03:37:46 PM
// Design Name: 
// Module Name: top_level
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

module top_level(
    input clk,  // System clock at 50 MHz
    input reset,  // System reset
    input [15:0] switches,  // Input switches
    input button,
    output [15:0] leds,  // Output LEDs
    // VGA outputs (if using VGA display)
    output hsync,
    output vsync,
    output [11:0] rgb
);

    // Internal signals for interconnecting submodules
    wire [15:0] debounced_switches;
    wire [47:0] shuffled_array;
    wire [2:0] random_number;
    wire [15:0] game_state, matched_tiles, mismatched_tiles;
    reg start_shuffle_signal = 0;
    reg btn_start_prev = 0;

    wire clk_25MHz;  // 25 MHz clock for VGA

    // Instantiate the clock divider
    clk_divider divider(
        .in_clk(clk),
        .out_clk(clk_25MHz)
    );
   
    always@(posedge clk) begin
        if(reset) begin
            start_shuffle_signal <= 0;
            btn_start_prev <= 0;
        end else begin
            if(button && !btn_start_prev) begin
                start_shuffle_signal <= 1;
            end else begin
                start_shuffle_signal <= 0;
            end
           
            btn_start_prev <= button;
        end
    end
    // Instantiate the debouncer
    debouncer switch (
        .clk(clk),
        .reset(reset),
        .noisy_switch(switches),
        .clean_switch(debounced_switches)
    );
    
    wire debounced_button; 
    
    debouncer btn (
        .clk(clk),
        .reset(reset),
        .noisy_switch(button),
        .clean_switch(debounced_button)
        );

    // Instantiate the LFSR
    lfsr_random lfsr (
        .clk(clk),
        .reset(reset),
        .random_num(random_number)
    );

    // Instantiate the array shuffle
    array_shuffle shuffle (
        .clk(clk),
        .reset(reset),
        .start(start_shuffle_signal),  // You need to define how and when to start shuffling
        .array(shuffled_array)
    );

    // Instantiate the game logic
    game_logic gl (
    .clk(clk),
    .reset(reset),
    .switches(debounced_switches), // Connect debounced switches
    .tile_states(), // Optionally connect if you need to monitor tile states externally
    .tile_values_flat(), // Optionally connect if needed externally
    .game_reset(), // Optionally connect if needed externally
    .tries() // Optionally connect if needed externally
);

    // Instantiate the VGA driver (if using VGA display)
    vga_driver vga (
        .clk(clk_25MHz),
        .reset(reset),
        .game_state(game_state),
        .matched_tiles(matched_tiles),
        .mismatched_tiles(mismatched_tiles),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );

    

endmodule
