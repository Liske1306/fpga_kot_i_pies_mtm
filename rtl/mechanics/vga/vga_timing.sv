/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Grzegorz Lis
 * Modified: Karolina Sawosz
 *
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk60MHz,
    input  logic rst,
    vga_if.out out
);

import variable_pkg::*;

logic [10:0] hcount_nxt;
logic [10:0] vcount_nxt;
logic hblnk_nxt;
logic vblnk_nxt;
logic vsync_nxt;
logic hsync_nxt;

  always_ff @(posedge clk60MHz) begin
    if (rst) begin
      out.hcount <= 11'b0;
      out.vcount <= 11'b0;
      out.hblnk  <= 1'b0;
      out.vsync  <= 1'b0;
      out.hsync  <= 1'b0;
      out.vblnk  <= 1'b0;
      out.rgb    <= '0;
    end
    else begin
      out.hcount <= hcount_nxt;
      out.vcount <= vcount_nxt;
      out.hblnk  <= hblnk_nxt;
      out.vsync  <= vsync_nxt;
      out.hsync  <= hsync_nxt;
      out.vblnk  <= vblnk_nxt;
      out.rgb    <= '0;
    end
  end

  always_comb begin
    if (out.hcount == HOR_BLANK_END) begin
      hcount_nxt = 11'b0;
    end
    else begin
      hcount_nxt = out.hcount + 1;
    end

    if (out.hcount == HOR_BLANK_END) begin
      if (out.vcount == VER_BLANK_END) begin
        vcount_nxt = 11'b0;
      end
      else begin
        vcount_nxt = out.vcount + 1;
      end
    end
    else begin
      vcount_nxt = out.vcount;
    end
  end

  always_comb begin
    if ((out.hcount >= HOR_BLANK_START - 1)&&(out.hcount <= HOR_BLANK_END - 1)) begin
      hblnk_nxt = 1'b1;
      if ((out.hcount >= HOR_SYNC_START - 1)&&(out.hcount <= HOR_SYNC_END - 1)) begin
        hsync_nxt = 1'b1;
      end
      else begin
        hsync_nxt = 1'b0;
      end
    end
    else begin
      hblnk_nxt = 1'b0;
      hsync_nxt = 1'b0;
    end
      
    if (out.hcount == HOR_BLANK_END) begin
      if ((out.vcount >= VER_BLANK_START - 1)&&(out.vcount <= VER_BLANK_END - 1)) begin
        vblnk_nxt = 1'b1;
        if((out.vcount >= VER_SYNC_START - 1)&&(out.vcount <= VER_SYNC_END - 1)) begin
          vsync_nxt = 1'b1;
        end
        else begin
          vsync_nxt = 1'b0;
        end
      end
      else begin
        vblnk_nxt = 1'b0;
        vsync_nxt = 1'b0;
      end
    end
    else begin
      vsync_nxt = out.vsync;
      vblnk_nxt = out.vblnk;
    end
  end


endmodule
