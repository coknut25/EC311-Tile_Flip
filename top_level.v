`timescale 1ns / 1ps

// This module represents the main controller for the game system.
// It handles the integration of various modules such as the clock divider, debouncer for buttons, home screen,
// level selection, game logic, VGA driver, and score counter.

module main(
    input clk,        // System clock
    input reset,      // System reset
    input [15:0] switches,   // Input switches for game interaction
    input [3:0] level_buttons,   // Buttons for level selection
    output [15:0] leds,   // Output LEDs for game feedback
    output [3:0] VGA_R,   // VGA Red channel
    output [3:0] VGA_G,   // VGA Green channel
    output [3:0] VGA_B,   // VGA Blue channel
    output VGA_HS,   // VGA Horizontal Sync
    output VGA_VS,   // VGA Vertical Sync
    output wire [6:0] seg,   // Output from the score counter module
    output wire [3:0] an   // Output from the score counter module
);

    // Wires for interconnecting modules
    wire [47:0] tile_values;
    wire [1:0] current_level;
    wire game_start;
    wire clk_divided;
    wire [15:0] dswitches, dbuttons;

    // Clock divider instantiation
    clk_divider clk_div (
        .in_clk(clk),
        .clk(clk_divided)
    );

    // Debouncer for level buttons instantiation
    debouncer_btn dbutton (
        .clk(clk),
        .noise(level_buttons),
        .calm(dbuttons)
    );

    // Home screen module instantiation
    home_screen home (
        .clk(clk_divided),
        .reset(reset),
        .level_buttons(dbuttons),
        .level(current_level),
        .start(game_start)
    );

    // Level selection module instantiation
    level_select level_sel (
        .clk(clk),
        .reset(reset),
        .level(current_level),
        .tile_setup(tile_values)
    );

    // Game logic module instantiation
    game_logic game (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds),
        .tiles(tile_values)
    );

    // VGA driver module instantiation
    vga_driver vga (
        .in_clk(clk),
        .states(leds), 
        .tile_vals(tile_values),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
    );

    // Score counter module instantiation
    score_counter score (
        .clock_50Mhz(clk),
        .reset(reset),
        .Anode_Activate(an),
        .LED_out(seg)
    );

endmodule
