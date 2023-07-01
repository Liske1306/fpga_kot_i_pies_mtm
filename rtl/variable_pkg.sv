package variable_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 40 MHz clock;
localparam HOR_PIXELS = 1024;
localparam HOR_BLANK_START = 1024;
localparam HOR_BLANK_END = 1344;
localparam HOR_SYNC_START = 1048;
localparam HOR_SYNC_END = 1184;
localparam VER_PIXELS = 768;
localparam VER_BLANK_START = 768;
localparam VER_BLANK_END = 806;
localparam VER_SYNC_START = 771;
localparam VER_SYNC_END = 777;

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
