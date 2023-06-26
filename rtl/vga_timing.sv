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
    output logic [10:0] vcount,
    output logic vsync,
    output logic vblnk,
    output logic [10:0] hcount,
    output logic hsync,
    output logic hblnk
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

always_ff @(posedge clk)
begin
    hcount<=hcount_nxt;
    vcount<=vcount_nxt; 
end

always_comb
begin
    if(rst)
    begin
    hcount_nxt ='0;
    vcount_nxt ='0;
    end
    else
    begin
        if(hcount==1055)
        begin
            hcount_nxt='0;
            if (vcount==627)
            begin
                vcount_nxt='0;
            end
            else
            begin
                vcount_nxt=vcount+1;
            end
        end
        else
        begin
            hcount_nxt=hcount+1;
            vcount_nxt=vcount;
        end
    end
end

always_comb
begin
    if (rst) 
    begin
        hblnk = 0;
        hsync = 0;
        vblnk = 0;
        vsync = 0;
    end
    else 
    begin
        if(hcount > 838 && hcount < 967)
        begin
            hsync = 1;
        end
        else
        begin
            hsync = 0;
        end

        if (vcount > 599 && vcount<605)
        begin
            vsync = 1;
        end
        else
        begin
            vsync = 0;
        end

        if(hcount > 799 && hcount<1056)
        begin
            hblnk = 1;
        end
        else
        begin
            hblnk = 0;
        end

        if (vcount>599 && vcount<628)
        begin
            vblnk = 1;
        end
        else
        begin
            vblnk = 0;
        end
    end 
end


endmodule
