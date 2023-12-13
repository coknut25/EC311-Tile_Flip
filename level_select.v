`timescale 1ns/1ps

module level_select(
    input clk,
    input reset,
    input [1:0] level,
    output reg [47:0] tile_setup  // 16 tiles x 3 bits each
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tile_setup <= 48'b0;
        end else begin
            case (level)
                2'b00: begin
                    tile_setup <= {3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7};
                end
                2'b01: begin
                    tile_setup <= {3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5};
                end
                2'b10: begin
                    tile_setup <= {3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1};
                end
                2'b11: begin
                    tile_setup <= {3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6, 3'd7, 3'd0, 3'd1, 3'd2, 3'd3};
                end
                default: begin
                    tile_setup <= 48'b0;
                end
            endcase
        end
    end
endmodule
