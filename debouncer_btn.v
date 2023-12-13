`timescale 1ns / 1ps

module debouncer_btn(
    input clk, 
    input [4:0] noise, 
    output reg [4:0] calm
    );
    
    reg [4:0] state = 0; 
    reg [20:0] count = 0; 
    localparam limit = 1000000;
    
    integer i; 
    
    always@(posedge clk) begin
        for(i = 0; i < 5; i = i + 1) begin 
            if(noise[i] != state[i]) begin
                count[i] <= count[i] + 1; 
                if(count[i] >= limit) begin
                    state[i] <= noise; 
                    count[i] <= 0; 
                end
            end 
            else begin
                count[i] <= 0;
            end
            calm[i] <= state[i];
        end        
    end
endmodule
