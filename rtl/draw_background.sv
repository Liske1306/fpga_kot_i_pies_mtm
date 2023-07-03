`timescale 1 ns / 1 ps

module draw_background(
    input  logic clk60MHz,
    input  logic rst,

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
    if (in.vblnk || in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end 
    else begin                              // Active region:
        if ((in.vcount >= 384)&&(in.vcount <= 743)&&(in.hcount >= 497)&&(in.hcount <= 527)) 
            rgb_nxt = 12'h9_7_7;                // fence
        else if (in.vcount <= 668)              
            rgb_nxt = 12'ha_d_f;                // blue
        else                                    // The rest of active display pixels:
            rgb_nxt = 12'h5_c_5;                // grass
    end
end

endmodule
