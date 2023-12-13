`timescale 1 ns/ 1 ps

module clk_divider (
    input in_clk,
    output reg clk
    );
    
    reg [32:0] count; 
    
    initial begin
        count = 0; 
        clk = 0; 
    end
    
    always @(negedge in_clk) begin
        count = count + 1; 
        if(count == 2) begin
            clk <= ~clk; 
            count <= 0; 
        end
    end
    
    
    
    
endmodule
