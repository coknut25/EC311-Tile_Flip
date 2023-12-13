`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:33:31 PM
// Design Name: 
// Module Name: array_shuffle
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


module array_shuffle(
    input clk, 
    input reset, 
    output reg [47:0] shuffled_vals
);

    wire [2:0] random_num; 
    reg [2:0] tile_array [15:0]; 
    integer i, j; 
    reg [2:0] temp; 

    lfsr_random lfsr(
        .clk(clk),
        .reset(reset), 
        .random_num(random_num)
    );

    always @(posedge clk or posedge reset) begin 
        if (reset) begin
            for (i = 0; i < 16; i = i + 1) begin
                tile_array[i] = i % 8;
            end
        end else begin
            for (i = 15; i > 0; i = i - 1) begin
                j = random_num % (i + 1); 
                temp = tile_array[i]; 
                tile_array[i] = tile_array[j]; 
                tile_array[j] = temp; 
            end
        end
        
        for (i = 0; i < 16; i = i + 1) begin
            shuffled_vals[i*3 +: 3] = tile_array[i]; 
        end
    end
endmodule
