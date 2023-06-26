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
    input  logic clk40MHz,
    input  logic clk100MHz,
    input  logic rst,
    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    inout  wire  ps2_clk,
    inout  wire  ps2_data
);

/**
 * Local variables and signals
 */
logic [11:0] xpos;
logic [11:0] ypos;
logic [11:0] xpos_temp;
logic [11:0] ypos_temp;
logic [11:0] rect_xpos;
logic [11:0] rect_ypos;
logic [11:0] address;
logic [11:0] rgb;
logic [10:0] addr;
logic [7:0] pixels;
logic [7:0] char_xy;
logic [6:0] char_code;
logic [3:0] char_line;
logic left_click;

//VGA interfaces
vga_if tim_bg_if();
vga_if bg_char_if();
vga_if char_rect_if();
vga_if rect_mouse_if();
vga_if mouse_out_if();

/**
 * Signals assignments
 */

assign vs = mouse_out_if.vsync;
assign hs = mouse_out_if.hsync;
assign {r,g,b} = mouse_out_if.rgb;


/**
 * Submodules instances
 */

vga_timing u_vga_timing (
    .clk(clk40MHz),
    .rst,
    .out(tim_bg_if)
);

draw_bg u_draw_bg (
    .clk(clk40MHz),
    .rst,
    .in(tim_bg_if),
    .out(bg_char_if)
);

draw_rect_char u_draw_rect_char (
    .clk(clk40MHz),
    .rst,
    .char_pixels(pixels),
    .in(bg_char_if),
    .out(char_rect_if),
    .char_line(char_line),
    .char_xy(char_xy)
);

char_rom_16x16 u_char_rom_16x16 (
    .clk(clk40MHz),
    .char_xy(char_xy),
    .char_code(char_code)
);

font_rom u_font_rom (
    .clk(clk40MHz),
    .addr({char_code,char_line}),
    .char_line_pixels(pixels)
);

MouseCtl u_MouseCtl (
    .clk(clk100MHz),
    .rst,
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos_temp),
    .ypos(ypos_temp),
    .left(left_click)
    );

bufor100_40 u_bufor100_40(
    .clk(clk40MHz),
    .xpos_nxt(xpos_temp),
    .ypos_nxt(ypos_temp),
    .xpos(xpos),
    .ypos(ypos)
);

draw_rect_ctl u_draw_rect_ctl(
    .clk(clk40MHz),
    .rst,
    .mouse_left(left_click),
    .mouse_xpos(xpos),
    .mouse_ypos(ypos),
    .xpos(rect_xpos),
    .ypos(rect_ypos)
);

draw_rect u_draw_rect (
    .clk(clk40MHz),
    .rst,
    .rgb_pixel(rgb),
    .xpos(rect_xpos),
    .ypos(rect_ypos),
    .in(char_rect_if),
    .out(rect_mouse_if),
    .pixel_addr(address)
);

image_rom u_image_rom(
    .clk(clk40MHz),
    .address,
    .rgb
);

draw_mouse u_draw_mouse (
    .clk(clk40MHz),
    .rst,
    .xpos(xpos),
    .ypos(ypos),
    .in(rect_mouse_if),
    .out(mouse_out_if)
);

endmodule
