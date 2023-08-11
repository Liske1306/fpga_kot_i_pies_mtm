`timescale 1 ns / 1 ps

module draw_hp(
    input  logic clk60MHz,
    input  logic rst,

    input  logic [6:0] hp_player1,
    input  logic [6:0] hp_player2,

    vga_if.in in,
    vga_if.out out
);

import variable_pkg::*;

logic [11:0] rgb_nxt;

always_ff @(posedge clk60MHz) begin
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
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= rgb_nxt;
    end
end

always_comb begin          
    if ((in.hcount >= HP_PLAYER1_XPOS - hp_player1*3)&&(in.hcount <= HP_PLAYER1_XPOS)&&(in.vcount >= HP_YPOS)&&(in.vcount <= HP_YPOS + HP_HEIGHT)) begin
        rgb_nxt = 12'hf_7_7;
    end
    else if ((in.hcount >= HP_PLAYER2_XPOS)&&(in.hcount <= HP_PLAYER2_XPOS + hp_player2*3)&&(in.vcount >= HP_YPOS)&&(in.vcount <= HP_YPOS + HP_HEIGHT)) begin
        rgb_nxt = 12'hf_7_7;
    end
    else begin
        rgb_nxt = in.rgb;
    end 
end

endmodule
