/**
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Grzegorz Lis, Karolina Sawosz
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA modules.
 * 
 * 27.06 GL - added declaration of the module and choose_player module
 * 28.06 KS - added turn manager module
 * 29.06 GL - added throw module, MouseCtl and bufor100_40
 */

 `timescale 1 ns / 1 ps

module top(
    input  logic clk60MHz,
    input  logic clk100MHz,
    input  logic rst,
    input  logic player1_choose,
    input  logic player2_choose,
    output logic player1_led,
    output logic player2_led,
    input  logic in_player1_ready,
    output logic out_player1_ready,
    input  logic in_player2_ready,
    output logic out_player2_ready,
    input  logic [4:0] in_power,
    output logic [4:0] out_power,
    input  logic in_throw_flag,
    output logic out_throw_flag,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    output logic hs,
    output logic vs,
    inout  logic ps2_clk,
    inout  logic ps2_data
);

logic throw_flag;
logic current_player;
logic left;
logic end_throw;
logic [2:0] wind, turn;
logic [4:0] power;
logic [11:0] xpos, ypos, xpos_particle, ypos_particle;
logic [11:0] address_cat, address_dog, address_particle, address_crate, address_doghouse;
logic [11:0] rgb;
logic [11:0] rgb_cat, rgb_crate, rgb_dog, rgb_doghouse, rgb_particle1, rgb_particle2;

vga_if vga_if_timing();
vga_if vga_if_background();
vga_if vga_if_cat();
vga_if vga_if_crate();
vga_if vga_if_dog();
vga_if vga_if_doghouse();
vga_if vga_if_particle();
vga_if vga_if_mouse();

assign vs = vga_if_mouse.vsync;
assign hs = vga_if_mouse.hsync;
assign {r,g,b} = vga_if_mouse.rgb;
assign out_throw_flag = throw_flag;
assign out_power = power;

choose_player u_choose_player(
    .clk60MHz,
    .rst,
    .in_player1_ready,
    .out_player1_ready,
    .in_player2_ready,
    .out_player2_ready,
    .player1_led,
    .player2_led,
    .player1_choose,
    .player2_choose,
    .current_player
);

turn_manager u_turn_manager(
    .clk60MHz,
    .rst,
    .throw_flag,
    .in_throw_flag,
    .turn
);

set_wind u_set_wind(
    .clk60MHz,
    .rst,
    .turn,
    .wind
);

MouseCtl u_MouseCtl (
    .clk(clk60MHz),
    .rst,
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos,
    .ypos,
    .left(left_nxt)
);

throw u_throw(
    .clk60MHz,
    .rst,
    .left,
    .power,
    .throw_flag,
    .end_throw,
    .turn(turn[0]),
    .current_player
);

vga_timing u_vga_timing(
    .clk60MHz,
    .rst,
    .out(vga_if_timing)
);

draw_background u_draw_background(
    .clk60MHz,
    .rst,
    .in(vga_if_timing),
    .out(vga_if_background)
);

cat_rom u_cat_rom(
    .clk60MHz,
    .address(address_cat),
    .rgb(rgb_cat)
);

draw_cat u_draw_cat(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_cat),
    .pixel_addr(address_cat),
    .in(vga_if_background),
    .out(vga_if_cat)
);

crate_rom u_crate_rom(
    .clk60MHz,
    .address(address_crate),
    .address1(address_doghouse),
    .rgb(rgb_crate),
    .rgb1(rgb_doghouse)
);

draw_crate u_draw_crate(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_crate),
    .pixel_addr(address_crate),
    .in(vga_if_cat),
    .out(vga_if_crate)
);

dog_rom u_dog_rom(
    .clk60MHz,
    .address(address_dog),
    .rgb(rgb_dog)
);

draw_dog u_draw_dog(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_dog),
    .pixel_addr(address_dog),
    .in(vga_if_crate),
    .out(vga_if_dog)
);

draw_doghouse u_draw_doghouse(
    .clk60MHz,
    .rst,
    .rgb_pixel(rgb_doghouse),
    .pixel_addr(address_doghouse),
    .in(vga_if_dog),
    .out(vga_if_doghouse)
);

particle1_rom u_particle1_rom(
    .clk60MHz,
    .address(address_particle),
    .rgb(rgb_particle1)
);

particle2_rom u_particle2_rom(
    .clk60MHz,
    .address(address_particle),
    .rgb(rgb_particle2)
);

draw_particle u_draw_particle(
    .clk60MHz,
    .rst,
    .turn(turn[0]),
    .xpos_particle,
    .ypos_particle,
    .rgb_pixel1(rgb_particle1),
    .rgb_pixel2(rgb_particle2),
    .pixel_addr(address_particle),
    .in (vga_if_doghouse),
    .out (vga_if_particle)
);

draw_mouse u_draw_mouse(
    .clk60MHz,
    .rst,
    .xpos,
    .ypos,
    .in (vga_if_particle),
    .out (vga_if_mouse)
);

endmodule