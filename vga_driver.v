`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 03:31:50 PM
// Design Name: 
// Module Name: vga_driver
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


module vga_driver(
    input clk,  // Pixel clock
    input reset,
    input [15:0] game_state,  // Game state indicating tile states (1 bit per tile)
    input [15:0] matched_tiles, // Indicates matched tiles
    input [15:0] mismatched_tiles, // Indicates mismatched tiles
    output reg hsync,
    output reg vsync,
    output reg [11:0] rgb  // 4 bits for Red, Green, and Blue
);

    // VGA timing parameters for 640x480 @ 60Hz
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_FRONT_PORCH = 16;
    parameter H_DISPLAY = 640;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_FRONT_PORCH = 10;
    parameter V_DISPLAY = 480;

    // Counters
    reg [9:0] h_count = 0;  // Horizontal counter
    reg [9:0] v_count = 0;  // Vertical counter

    // Sync signal generation
    always @(posedge clk) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            // Horizontal counter
            if (h_count < H_SYNC_PULSE + H_BACK_PORCH + H_DISPLAY + H_FRONT_PORCH - 1)
                h_count <= h_count + 1;
            else begin
                h_count <= 0;
                // Vertical counter
                if (v_count < V_SYNC_PULSE + V_BACK_PORCH + V_DISPLAY + V_FRONT_PORCH - 1)
                    v_count <= v_count + 1;
                else
                    v_count <= 0;
            end
        end

        // Generate HSYNC and VSYNC signals
        hsync <= (h_count < H_SYNC_PULSE) ? 0 : 1;
        vsync <= (v_count < V_SYNC_PULSE) ? 0 : 1;
    end

    // Tile display parameters
    parameter TILE_SIZE = 80; // Size of each tile in pixels
    parameter GRID_OFFSET_X = 120; // Horizontal offset of the grid
    parameter GRID_OFFSET_Y = 60;  // Vertical offset of the grid

    wire [3:0] tile_row, tile_col;
    assign tile_row = (v_count - GRID_OFFSET_Y) / TILE_SIZE;
    assign tile_col = (h_count - GRID_OFFSET_X) / TILE_SIZE;
    wire is_tile_area = (h_count >= GRID_OFFSET_X) && (h_count < GRID_OFFSET_X + TILE_SIZE * 4) &&
                        (v_count >= GRID_OFFSET_Y) && (v_count < GRID_OFFSET_Y + TILE_SIZE * 4);
    integer tile_index;
    
    // RGB signal generation based on game state and counters
    always @(posedge clk) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
            rgb <= 12'h000; // Default to black
        end else begin
            if (is_tile_area) begin
                tile_index = tile_row * 4 + tile_col; 
                if (game_state[tile_index]) begin
                    // Tile is selected
                    if (matched_tiles[tile_index]) begin
                        rgb <= 12'h0F0; // Green for matched tiles
                    end else if (mismatched_tiles[tile_index]) begin
                        rgb <= 12'hF00; // Red for mismatched tiles
                    end else begin
                        rgb <= 12'hFFF; // White for selected tiles
                    end
                end else begin
                    rgb <= 12'h00F; // Default color (blue) for unselected tiles
                end
            end else begin
                rgb <= 12'h000; // Black for non-tile areas
            end
        end
    end
endmodule
