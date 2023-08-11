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

//Prameters for draw_*
localparam HOR_CAT_POSITION = 113;
localparam VER_CAT_POSITION = 471;
localparam HOR_CAT_POSITION1 = 176;
localparam VER_CAT_POSITION1 = 471;
localparam HOR_CAT_POSITION2 = 113;
localparam VER_CAT_POSITION2 = 535;
localparam HOR_CAT_POSITION3 = 176;
localparam VER_CAT_POSITION3 = 535;

localparam HOR_CRATE_POSITION = 112;
localparam VER_CRATE_POSITION = 599;

localparam HOR_DOG_POSITION = 763;
localparam VER_DOG_POSITION = 472;
localparam HOR_DOG_POSITION1 = 826;
localparam VER_DOG_POSITION1 = 472;
localparam HOR_DOG_POSITION2 = 762;
localparam VER_DOG_POSITION2 = 535;
localparam HOR_DOG_POSITION3 = 826;
localparam VER_DOG_POSITION3 = 535;

localparam HOR_DOGHOUSE_POSITION = 762;
localparam VER_DOGHOUSE_POSITION = 599;

localparam PLAYER_WIDTH = 128;
localparam PLAYER_HEIGHT = 144;
localparam PLAYER_WIDTH1 = 64;
localparam PLAYER_HEIGHT1 = 64;

localparam PARTICLE_WIDTH = 50;
localparam PARTICLE_HEIGHT = 50;

localparam HP_PLAYER1_XPOS = 400;
localparam HP_YPOS = 100;
localparam HP_PLAYER2_XPOS = 624;
localparam HP_HEIGHT = 20;

localparam POWER_PLAYER1_XPOS = 240;
localparam POWER_YPOS = 320;
localparam POWER_PLAYER2_XPOS = 763;
localparam POWER_HEIGHT = 20;

//Players
localparam PLAYER_1 = 1;
localparam PLAYER_2 = 2;
localparam OFF = 1;
localparam ON = 0;

//Gameplay
localparam HIT = 288;
localparam FENCE = 384;
endpackage
