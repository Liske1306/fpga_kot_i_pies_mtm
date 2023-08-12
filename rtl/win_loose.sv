`timescale 1 ns / 1 ps

module win_loose(
    input logic clk60MHz,
    input logic rst,
    input logic win,
    input logic loose,
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
        out.rgb    <= in.rgb;
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
    if (in.vblnk || in.hblnk) begin             
        rgb_nxt = 12'h0_0_0;                   
    end 
    else if(win == 1) begin
        rgb_nxt = 12'h0_f_0; 
    end
    else if(loose == 1) begin
        rgb_nxt = 12'hf_0_0; 
    end
    else begin
        rgb_nxt = in.rgb;
    end

end

endmodule
