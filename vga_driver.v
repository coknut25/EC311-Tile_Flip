// VGA driver module for displaying graphics on a VGA monitor.
module vga_driver (
    input in_clk,
    input [15:0] states,  // Tile states from game_logic module
    input [47:0] tile_vals,  // Tile values from level_select module
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    output reg VGA_HS,
    output reg VGA_VS
);

    // Clock divider module for generating an internal clock
    clk_divider CD(in_clk, clk);

    // Counter and state variables for horizontal and vertical synchronization
    reg [31:0] count, vertical_count;
    reg [31:0] vertical_position, horizontal_position;
    reg [1:0] vertical_state, horizontal_state;
    reg vertical_trigger, vertical_blank; // Triggers the vertical state machine

    // Initial setup
    initial begin
        vertical_position = 0;
        count = 1;
        vertical_count = 1;
        horizontal_position = 0;
        vertical_state = 3;
        horizontal_state = 3;
        VGA_HS = 1;
        VGA_VS = 1;
        VGA_R = 0;
        VGA_G = 0;
        VGA_B = 0;
        vertical_trigger = 0;
        vertical_blank = 1;
    end

    // Main clocked process
    always @(posedge clk) begin
        // Horizontal state machine logic
        if (horizontal_state == 0) begin
            // Counter for horizontal synchronization
            if (count == 47) begin
                count <= 1;
                horizontal_state <= 1;
                vertical_trigger <= 1;
            end else begin
                vertical_trigger <= 0;
                count <= count + 1;
            end
        end
        else if (horizontal_state == 1) begin
            // Displaying pixel colors based on tile values and states
            if (horizontal_position == 640) begin
                VGA_R <= 0;
                VGA_G <= 0;
                VGA_B <= 0;
                horizontal_position <= 0;
                horizontal_state <= 2;
            end else begin
                // Checking tile state and setting RGB values accordingly
                if (vertical_blank == 0) begin
                    if (states[(horizontal_position / 160) + (vertical_position / 120) * 4]) begin
                        case (tile_vals[(horizontal_position / 160) + (vertical_position / 120) * 4])
                            3'd0: begin // Red
                                VGA_R <= 8;
                                VGA_G <= 0;
                                VGA_B <= 0;
                            end
                            3'd1: begin // Green
                                VGA_R <= 0;
                                VGA_G <= 8;
                                VGA_B <= 0;
                            end
                            3'd2: begin // Yellow
                                VGA_R <= 8;
                                VGA_G <= 8;
                                VGA_B <= 0;
                            end
                            3'd3: begin // Orange
                                VGA_R <= 8;
                                VGA_G <= 4;
                                VGA_B <= 0;
                            end
                            3'd4: begin // Purple
                                VGA_R <= 8;
                                VGA_G <= 0;
                                VGA_B <= 8;
                            end
                            3'd5: begin // Blue
                                VGA_R <= 0;
                                VGA_G <= 0;
                                VGA_B <= 8;
                            end
                            3'd6: begin // Teal
                                VGA_R <= 0;
                                VGA_G <= 8;
                                VGA_B <= 8;
                            end
                            3'd7: begin // White
                                VGA_R <= 8;
                                VGA_G <= 8;
                                VGA_B <= 8;
                            end
                            default: begin
                                VGA_R <= 0;
                                VGA_G <= 0;
                                VGA_B <= 0;
                            end
                        endcase
                    end else begin
                        VGA_R <= 8;
                        VGA_G <= 8;
                        VGA_B <= 8;
                    end
                end else begin
                    VGA_R <= 0;
                    VGA_G <= 0;
                    VGA_B <= 0;
                end
                horizontal_position <= horizontal_position + 1;
            end
        end
        else if (horizontal_state == 2) begin
            // Counter for horizontal synchronization
            if (count == 16) begin
                count <= 1;
                VGA_HS <= 0;
                horizontal_state <= 3;
            end else begin
                count <= count + 1;
            end
        end
        else begin // horizontal_state == 3
            // Counter for horizontal synchronization
            if (count == 96) begin
                VGA_HS <= 1;
                count <= 1;
                horizontal_state <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

    // Vertical synchronization process
    always @(posedge vertical_trigger) begin
        if (vertical_state == 0) begin
            // Counter for vertical synchronization
            if (vertical_count == 32) begin
                vertical_count <= 1;
                vertical_state <= 1;
            end else begin
                vertical_count <= vertical_count + 1;
            end
        end
        else if (vertical_state == 1) begin
            // Display vertical position and check for vertical blank
            if (vertical_position == 480) begin
                vertical_position <= 0;
                vertical_state <= 2;
                vertical_blank <= 1;
            end else begin
                vertical_blank <= 0;
                vertical_position <= vertical_position + 1;
            end
        end
        else if (vertical_state == 2) begin
            // Counter for vertical synchronization
            if (vertical_count == 10) begin
                vertical_count <= 1;
                VGA_VS <= 0;
                vertical_state <= 3;
            end else begin
                vertical_count <= vertical_count + 1;
            end
        end
        else begin // vertical_state == 3
            // Counter for vertical synchronization
            if (vertical_count == 2) begin
                VGA_VS <= 1;
                vertical_count <= 1;
                vertical_state <= 0;
            end else begin
                vertical_count <= vertical_count + 1;
            end
        end
    end
endmodule
