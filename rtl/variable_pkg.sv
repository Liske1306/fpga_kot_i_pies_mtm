/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Package with vga related constants.
 */

package variable_pkg;

// Parameters for VGA Display 800 x 600 @ 60fps using a 40 MHz clock;
localparam HOR_PIXELS = 800;
localparam HOR_BLANK_START = 800;
localparam HOR_BLANK_END = 1055;
localparam HOR_SYNC_START = 840;
localparam HOR_SYNC_END = 967;
localparam VER_PIXELS = 600;
localparam VER_BLANK_START = 600;
localparam VER_BLANK_END = 627;
localparam VER_SYNC_START = 601;
localparam VER_SYNC_END = 604;

//Prameters for draw_rect
//localparam HOR_RECT_POSITION= 100;
//localparam VER_RECT_POSITION= 100;
localparam RECT_WIDTH= 48;
localparam RECT_HEIGHT= 64;
localparam RECT_COLOR= 12'ha_b_e;
localparam RECT_FONT_SIGNS_X= 16;
localparam RECT_FONT_SIGNS_Y= 16;
localparam RECT_FONT_XPOS= 203;
localparam RECT_FONT_YPOS= 22;

//Players
localparam PLAYER_1 = 1;
localparam PLAYER_2 = 0;
localparam OFF = 1;
localparam ON = 0;

//Gameplay
localparam HIT = 288;
localparam FENCE = 384;
endpackage
