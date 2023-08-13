/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Karolina Sawosz
 *
 */

`timescale 1 ns / 1 ps

module draw_dog(
    input  logic clk60MHz,
    input  logic rst,

    input  logic [11:0] rgb_pixel,
    input  logic [11:0] rgb_pixel1,
    input  logic [11:0] rgb_pixel2,
    input  logic [11:0] rgb_pixel3,
    output logic [11:0] pixel_addr,
    output logic [11:0] pixel_addr1,
    output logic [11:0] pixel_addr2,
    output logic [11:0] pixel_addr3,

    vga_if.in in,
    vga_if.out out
);

import variable_pkg::*;

logic [11:0] rgb_nxt;
wire [5:0] addrx, addry, addrx1, addry1, addrx2, addry2, addrx3, addry3;

logic [11:0] rgb_temp;
logic [10:0] vcount_temp, hcount_temp;
logic vsync_temp, vblnk_temp, hsync_temp, hblnk_temp;

always_ff @(posedge clk60MHz) begin
    if (rst) begin
        vcount_temp <= '0;
        vsync_temp  <= '0;
        vblnk_temp  <= '0;
        hcount_temp <= '0;
        hsync_temp  <= '0;
        hblnk_temp  <= '0;
        rgb_temp    <= '0;
    end 
    else begin
        vcount_temp <= in.vcount;
        vsync_temp  <= in.vsync;
        vblnk_temp  <= in.vblnk;
        hcount_temp <= in.hcount;
        hsync_temp  <= in.hsync;
        hblnk_temp  <= in.hblnk;
        rgb_temp    <= in.rgb;
    end
end

always_ff @(posedge clk60MHz) begin
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end 
    else begin
        out.vcount <= vcount_temp;
        out.vsync  <= vsync_temp;
        out.vblnk  <= vblnk_temp;
        out.hcount <= hcount_temp;
        out.hsync  <= hsync_temp;
        out.hblnk  <= hblnk_temp;
        out.rgb    <= rgb_nxt;
    end
end

always_comb begin
    if(!vblnk_temp && !hblnk_temp) begin
        if((hcount_temp >= HOR_DOG_POSITION)&&(hcount_temp < HOR_DOG_POSITION + PLAYER_WIDTH1)&&(vcount_temp >= VER_DOG_POSITION)&&(vcount_temp < VER_DOG_POSITION + PLAYER_HEIGHT1)) begin
            rgb_nxt = rgb_pixel;
        end
        else if((hcount_temp >= HOR_DOG_POSITION1)&&(hcount_temp < HOR_DOG_POSITION1 + PLAYER_WIDTH1)&&(vcount_temp >= VER_DOG_POSITION1)&&(vcount_temp < VER_DOG_POSITION1 + PLAYER_HEIGHT1)) begin
            rgb_nxt = rgb_pixel1;
        end
        else if((hcount_temp >= HOR_DOG_POSITION2)&&(hcount_temp < HOR_DOG_POSITION2 + PLAYER_WIDTH1)&&(vcount_temp >= VER_DOG_POSITION2)&&(vcount_temp < VER_DOG_POSITION2 + PLAYER_HEIGHT1)) begin
            rgb_nxt = rgb_pixel2;
        end
        else if((hcount_temp >= HOR_DOG_POSITION3)&&(hcount_temp < HOR_DOG_POSITION3 + PLAYER_WIDTH1)&&(vcount_temp >= VER_DOG_POSITION3)&&(vcount_temp < VER_DOG_POSITION3 + PLAYER_HEIGHT1)) begin
            rgb_nxt = rgb_pixel3;
        end
        else begin
            rgb_nxt = rgb_temp;  
        end
    end
    else begin
        rgb_nxt = rgb_temp;
    end
end

assign addry = in.vcount - VER_DOG_POSITION;
assign addrx = in.hcount - HOR_DOG_POSITION;
assign pixel_addr = {addry[5:0], addrx[5:0]};

assign addry1 = in.vcount - VER_DOG_POSITION1;
assign addrx1 = in.hcount - HOR_DOG_POSITION1;
assign pixel_addr1 = {addry1[5:0], addrx1[5:0]};

assign addry2 = in.vcount - VER_DOG_POSITION2;
assign addrx2 = in.hcount - HOR_DOG_POSITION2;
assign pixel_addr2 = {addry2[5:0], addrx2[5:0]};

assign addry3 = in.vcount - VER_DOG_POSITION3;
assign addrx3 = in.hcount - HOR_DOG_POSITION3;
assign pixel_addr3 = {addry3[5:0], addrx3[5:0]};

endmodule
