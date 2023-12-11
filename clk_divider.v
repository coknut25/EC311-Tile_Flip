`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 09:12:02 PM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input in_clk, 
    output reg out_clk);
	
	reg[32:0] count;

	initial begin
		count = 0;
		out_clk = 0;
	end
	
	always @(negedge in_clk)
	begin
		count = count + 1;
		if (count == 2) begin
			out_clk <= ~out_clk;
			count <= 0;
			end
	end


endmodule
