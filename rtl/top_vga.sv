/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * The project top module.
 */

`timescale 1 ns / 1 ps

module top_vga (
    input  logic clk,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
);


/**
 * Local variables and signals
 */

// VGA signals from timing
wire [10:0] vcount_tim, hcount_tim;
wire vsync_tim, hsync_tim;
wire vblnk_tim, hblnk_tim;

// VGA signals from background
wire [10:0] vcount_bg, hcount_bg;
wire vsync_bg, hsync_bg;
wire vblnk_bg, hblnk_bg;
wire [11:0] rgb_bg;


/**
 * Signals assignments
 */

assign vs = vsync_bg;
assign hs = hsync_bg;
assign {r,g,b} = rgb_bg;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk,
    .rst,
    .vcount (vcount_tim),
    .vsync  (vsync_tim),
    .vblnk  (vblnk_tim),
    .hcount (hcount_tim),
    .hsync  (hsync_tim),
    .hblnk  (hblnk_tim)
);

draw_bg u_draw_bg (
    .clk,
    .rst,

    .vcount_in  (vcount_tim),
    .vsync_in   (vsync_tim),
    .vblnk_in   (vblnk_tim),
    .hcount_in  (hcount_tim),
    .hsync_in   (hsync_tim),
    .hblnk_in   (hblnk_tim),

    .vcount_out (vcount_bg),
    .vsync_out  (vsync_bg),
    .vblnk_out  (vblnk_bg),
    .hcount_out (hcount_bg),
    .hsync_out  (hsync_bg),
    .hblnk_out  (hblnk_bg),

    .rgb_out    (rgb_bg)
);

endmodule
