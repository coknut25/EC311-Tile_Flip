`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2023 01:21:24 PM
// Design Name: 
// Module Name: lfsr_random
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


module lfsr_random(
    input clk, 
    input reset, 
    output reg [2:0] random_num 
    );
    
    reg [2:0] lfsr_reg = 3'b001;
    
    always@(posedge clk or posedge reset) begin
        if(reset) 
            lfsr_reg <= 3'b001; 
        else begin
           lfsr_reg <= {lfsr_reg[1:0], lfsr_reg[2] ^ lfsr_reg[0]};
           random_num <= lfsr_reg;          
        end
    end         
endmodule
