/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps

module draw_rect (
    input  logic clk,
    input  logic rst,
    input  logic [11:0] xpos,
    input  logic [11:0] ypos,
    input  logic [11:0] rgb_pixel,
    vga_if.in in,
    vga_if.out out,
    output [11:0] pixel_addr
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
logic [11:0] rgb_temp;
logic [5:0] addrx;
logic [5:0] addry;
logic [10:0] vcount_temp, hcount_temp;
logic hsync_temp, vsync_temp, vblnk_temp, hblnk_temp;

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
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end else begin
        out.vcount <= vcount_temp;
        out.vsync  <= vsync_temp;
        out.vblnk  <= vblnk_temp;
        out.hcount <= hcount_temp;
        out.hsync  <= hsync_temp;
        out.hblnk  <= hblnk_temp;
        out.rgb   <= rgb_nxt;
    end
end

always_comb begin : rect_comb_blk
        if ( (!vblnk_temp) && (!hblnk_temp) && (hcount_temp >= xpos) && (hcount_temp < xpos + RECT_WIDTH) && (vcount_temp >= ypos) && (vcount_temp < ypos + RECT_HEIGHT) )
        begin
            rgb_nxt = rgb_pixel;
        end
        else
        begin                                 
            rgb_nxt = rgb_temp;                
        end
end

assign addry = in.vcount - ypos;
assign addrx = in.hcount - xpos;
assign pixel_addr = {addry[5:0], addrx[5:0]};

endmodule
