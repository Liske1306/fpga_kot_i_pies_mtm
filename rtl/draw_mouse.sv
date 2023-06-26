/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


 `timescale 1 ns / 1 ps

 module draw_mouse (
     input  logic clk,
     input  logic rst,
     input  logic [11:0] xpos,
     input  logic [11:0] ypos,
     vga_if.in in,
     vga_if.out out
 );
 
 import vga_pkg::*;
 
 
 /**
  * Local variables and signals
  */
 
 logic [11:0] rgb_nxt;
 
 
 /**
  * Internal logic
  */
 
 always_ff @(posedge clk) begin : rect_ff_blk
     if (rst) begin
         out.vcount <= '0;
         out.vsync  <= '0;
         out.vblnk  <= '0;
         out.hcount <= '0;
         out.hsync  <= '0;
         out.hblnk  <= '0;
         out.rgb    <= '0;
     end else begin
         out.vcount <= in.vcount;
         out.vsync  <= in.vsync;
         out.vblnk  <= in.vblnk;
         out.hcount <= in.hcount;
         out.hsync  <= in.hsync;
         out.hblnk  <= in.hblnk;
         out.rgb    <= rgb_nxt;
     end
 end
 
MouseDisplay u_MouseDisplay(
    .pixel_clk(clk),
    .blank(in.vblnk || in.hblnk),
    .hcount(in.hcount),
    .vcount(in.vcount),
    .rgb_in(in.rgb),
    .rgb_out(rgb_nxt),
    .xpos(xpos),
    .ypos(ypos)
);
 
 endmodule
 