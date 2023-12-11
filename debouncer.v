`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 03:04:26 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,          // Clock input
    input reset,        // Reset input
    input noisy_switch, // Input from the mechanical switch
    output reg clean_switch // Debounced switch output
);

    // Parameters (Adjust based on your clock frequency and expected bounce time)
    parameter MAX_COUNT = 50000; // Example count for debounce delay
    reg [15:0] counter = 0;      // Counter for delay (width depends on MAX_COUNT)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clean_switch <= 0;
        end else begin
            if (noisy_switch == clean_switch) begin
                // Reset counter if switch state matches the debounced state
                counter <= 0;
            end else begin
                // Increment counter if switch state does not match
                if (counter < MAX_COUNT) begin
                    counter <= counter + 1;
                end else begin
                    // Update debounced state and reset counter
                    clean_switch <= noisy_switch;
                    counter <= 0;
                end
            end
        end
    end
endmodule
