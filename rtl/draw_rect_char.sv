/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps

module draw_rect_char (
    input  logic clk,
    input  logic rst,
    input  logic [7:0] char_pixels,
    vga_if.in in,
    vga_if.out out,
    output [3:0] char_line,
    output [7:0] char_xy
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

logic [7:0] char_x;
logic [7:0] char_y;
logic [7:0] char_x_temp1;
logic [11:0] rgb_nxt;
logic [11:0] rgb_temp;
logic [11:0] rgb_temp1;
logic [10:0] vcount_temp, hcount_temp;
logic hsync_temp, vsync_temp, vblnk_temp, hblnk_temp;
logic [10:0] vcount_temp1, hcount_temp1;
logic hsync_temp1, vsync_temp1, vblnk_temp1, hblnk_temp1;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin
    if (rst) begin
        vcount_temp <= '0;
        vsync_temp  <= '0;
        vblnk_temp  <= '0;
        hcount_temp <= '0;
        hsync_temp  <= '0;
        hblnk_temp  <= '0;
        rgb_temp  <= '0;
    end else begin
        vcount_temp <= in.vcount;
        vsync_temp  <= in.vsync;
        vblnk_temp  <= in.vblnk;
        hcount_temp <= in.hcount;
        hsync_temp  <= in.hsync;
        hblnk_temp  <= in.hblnk;
        rgb_temp  <= in.rgb;
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        vcount_temp1 <= '0;
        vsync_temp1  <= '0;
        vblnk_temp1  <= '0;
        hcount_temp1 <= '0;
        hsync_temp1  <= '0;
        hblnk_temp1  <= '0;
        rgb_temp1    <= '0;
    end else begin
        vcount_temp1 <= vcount_temp;
        vsync_temp1  <= vsync_temp;
        vblnk_temp1  <= vblnk_temp;
        hcount_temp1 <= hcount_temp;
        hsync_temp1  <= hsync_temp;
        hblnk_temp1  <= hblnk_temp;
        rgb_temp1   <= rgb_nxt;
    end
end


always_ff @(posedge clk) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end else begin
        out.vcount <= vcount_temp1;
        out.vsync  <= vsync_temp1;
        out.vblnk  <= vblnk_temp1;
        out.hcount <= hcount_temp1;
        out.hsync  <= hsync_temp1;
        out.hblnk  <= hblnk_temp1;
        out.rgb   <= rgb_temp1;
    end
end

always_comb begin : rect_comb_blk
        if ( (!vblnk_temp) && (!hblnk_temp) && (hcount_temp1 >=RECT_FONT_XPOS) && (hcount_temp1 < RECT_FONT_XPOS + (8*RECT_FONT_SIGNS_X)) && (vcount_temp1 >= RECT_FONT_YPOS) && (vcount_temp1 < RECT_FONT_YPOS + (16*RECT_FONT_SIGNS_Y)) )
        begin
            if(char_pixels[7-char_x_temp1[2:0]]==0) 
            begin
                rgb_nxt = rgb_temp;
            end
            else 
            begin
                rgb_nxt = 12'hf_0_f;
            end
        end
        else
        begin                                 
            rgb_nxt = rgb_temp;                
        end
end

assign char_x_temp1 = hcount_temp1 - RECT_FONT_XPOS;
assign char_x = in.hcount-RECT_FONT_XPOS;
assign char_y = in.vcount-RECT_FONT_YPOS;
assign char_xy = {char_x[6:3],char_y[7:4]};
assign char_line = char_y[3:0];

endmodule
