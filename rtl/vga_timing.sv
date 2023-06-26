/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Vga timing controller.
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,
    vga_if.out out
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

// Add your signals and variables here.


/**
 * Internal logic
 */

// Add your code here.

logic [10:0] hcount_nxt;
logic [10:0] vcount_nxt;
logic vblnk_nxt;
logic hblnk_nxt;
logic hsync_nxt;
logic vsync_nxt;

always_ff @(posedge clk)
begin
    if(rst)
    begin 
        out.hcount<='0;
        out.vcount<='0;
        out.vblnk<='0;
        out.hblnk<='0;
        out.hsync<='0;
        out.vsync<='0;
        out.rgb<=12'h0_0_0;
    end
    else
    begin
        out.hcount<=hcount_nxt;
        out.vcount<=vcount_nxt; 
        out.vsync<=vsync_nxt; 
        out.hsync<=hsync_nxt; 
        out.hblnk<=hblnk_nxt; 
        out.vblnk<=vblnk_nxt;
        out.rgb  <=12'h0_0_0; 
    end
end

always_comb
begin
    if(out.hcount==1055)
    begin
        hcount_nxt='0;
    end
    else
    begin
        hcount_nxt=out.hcount+1;
    end
    if(out.hcount==1055)
    begin
        if (out.vcount==627)
        begin
            vcount_nxt='0;
        end
        else
        begin
            vcount_nxt=out.vcount+1;
        end
    end
    else
    begin
        vcount_nxt=out.vcount;
    end
end

always_comb
begin
    if(out.hcount >= HOR_SYNC_START-1 && out.hcount <= HOR_SYNC_END-1)
    begin
        hsync_nxt = 1;
    end
    else
    begin
        hsync_nxt = 0;
    end

    if(out.hcount==1055)
    begin
        if (out.vcount >= VER_SYNC_START-1 && out.vcount<=VER_SYNC_END-1)
        begin
            vsync_nxt = 1;
        end
        else
        begin
            vsync_nxt = 0;
        end

        if (out.vcount>=VER_BLANK_START-1 && out.vcount<=VER_BLANK_END-1)
        begin
            vblnk_nxt = 1;
        end
        else
        begin
            vblnk_nxt = 0;
        end
    end
    else
    begin
        vsync_nxt=out.vsync;
        vblnk_nxt=out.vblnk;
    end

    if(out.hcount >= HOR_BLANK_START-1 && out.hcount<=HOR_BLANK_END-1)
    begin
        hblnk_nxt = 1;
    end
    else
    begin
        hblnk_nxt = 0;
    end
end 



endmodule
