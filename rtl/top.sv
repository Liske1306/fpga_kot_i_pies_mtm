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
logic [11:0] xpos, ypos, xpos_prebuff, ypos_prebuff;

vga_if vga_if_timing();
vga_if vga_if_background();

assign vs = vga_if_background.vsync;
assign hs = vga_if_background.hsync;
assign {r,g,b} = vga_if_background.rgb;
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
    .clk(clk100MHz),
    .rst,
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .xpos(xpos_prebuff),
    .ypos(ypos_prebuff),
    .left
    );

bufor100_60 u_bufor100_60(
    .clk(clk60MHz),
    .xpos_nxt(xpos_prebuff),
    .ypos_nxt(ypos_prebuff),
    .xpos(xpos),
    .ypos(ypos)
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

endmodule